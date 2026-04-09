using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using SistemaVenta.IOC;
using Microsoft.OpenApi.Models;
using Microsoft.EntityFrameworkCore;
using SistemaVenta.DAL.DBContext;
using Fleck;
using System.Text.Json;
using SistemaVenta.BLL.Services.Contrato;

var builder = WebApplication.CreateBuilder(args);

// Cargar configuracion explicitamente
builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);

// Servicios esenciales
builder.Services.AddControllers();

AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

// Swagger Configuration
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Sistema de Ventas API", Version = "v1" });

    // Configurar autenticacion con JWT en Swagger
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "Introduce el token en este formato: Bearer {token}",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

// Inyeccion de dependencias
builder.Services.InyectarDepedencias(builder.Configuration);

// Mostrar clave en consola para verificar que se lee correctamente
var jwtKey = builder.Configuration["Jwt:Key"];
Console.WriteLine($"JWT Key: {jwtKey}");

// Validar que la clave no sea null o vacia
if (string.IsNullOrEmpty(jwtKey))
{
    throw new InvalidOperationException("La clave JWT no se encuentra en la configuracion.");
}

// Configurar autenticacion con JWT
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ClockSkew = TimeSpan.Zero,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };
    });
// Configuracion de CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("NuevaPoliticaCors", policy =>
    {
        // Permite cualquier encabezado

        policy.SetIsOriginAllowed(_ => true)  // Permite cualquier origen
           .AllowAnyMethod()
           .AllowAnyHeader();


    });
});

var app = builder.Build();

var server = new WebSocketServer("ws://0.0.0.0:8181");

server.Start(ws =>
{
    CancellationTokenSource? actualizacionCts = null;

    ws.OnOpen = () =>
    {
        Console.WriteLine("Cliente WebSocket conectado.");
    };

    ws.OnClose = () =>
    {
        actualizacionCts?.Cancel();
        actualizacionCts?.Dispose();
        Console.WriteLine("Cliente WebSocket desconectado.");
    };

    ws.OnMessage = message =>
    {
        try
        {
            var idUsuario = ObtenerIdUsuarioDesdeMensaje(message);

            if (idUsuario <= 0)
            {
                ws.Send(JsonSerializer.Serialize(new
                {
                    ok = false,
                    mensaje = "Debes enviar un id de usuario valido en el mensaje del socket."
                }));
                return;
            }

            actualizacionCts?.Cancel();
            actualizacionCts?.Dispose();
            actualizacionCts = new CancellationTokenSource();

            _ = Task.Run(() => EnviarTareasCompletadasPeriodicamenteAsync(
                ws,
                app.Services,
                idUsuario,
                actualizacionCts.Token));
        }
        catch (Exception ex)
        {
            ws.Send(JsonSerializer.Serialize(new
            {
                ok = false,
                mensaje = ex.Message
            }));
        }
    };
});

// Middleware
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Sistema Demo API v1");
    });
}
app.Urls.Add("http://0.0.0.0:5185");

app.UseCors("NuevaPoliticaCors");
app.UseAuthentication();  // Autenticacion antes de la autorizacion
app.UseAuthorization();

app.MapControllers();

app.Run();

static int ObtenerIdUsuarioDesdeMensaje(string message)
{
    if (int.TryParse(message, out var idUsuario))
    {
        return idUsuario;
    }

    using var jsonDocument = JsonDocument.Parse(message);

    if (jsonDocument.RootElement.TryGetProperty("idUsuario", out var idUsuarioElement) &&
        idUsuarioElement.TryGetInt32(out idUsuario))
    {
        return idUsuario;
    }

    return 0;
}

static async Task EnviarTareasCompletadasPeriodicamenteAsync(
    IWebSocketConnection ws,
    IServiceProvider services,
    int idUsuario,
    CancellationToken cancellationToken)
{
    try
    {
        await EnviarTareasCompletadasAsync(ws, services, idUsuario, cancellationToken);

        using var timer = new PeriodicTimer(TimeSpan.FromSeconds(5));

        while (await timer.WaitForNextTickAsync(cancellationToken))
        {
            await EnviarTareasCompletadasAsync(ws, services, idUsuario, cancellationToken);
        }
    }
    catch (OperationCanceledException)
    {
        // La cancelacion es esperada cuando el cliente se desconecta o se vuelve a suscribir.
    }
}

static async Task EnviarTareasCompletadasAsync(
    IWebSocketConnection ws,
    IServiceProvider services,
    int idUsuario,
    CancellationToken cancellationToken)
{
    if (!ws.IsAvailable)
    {
        return;
    }

    using var scope = services.CreateScope();
    var tareasService = scope.ServiceProvider.GetRequiredService<ITareasService>();
    var tareasCompletadas = await tareasService.ListaCompletadas(idUsuario);

    cancellationToken.ThrowIfCancellationRequested();

    ws.Send(JsonSerializer.Serialize(new
    {
        ok = true,
        idUsuario,
        total = tareasCompletadas.Count,
        tareas = tareasCompletadas,
        fechaActualizacion = DateTime.UtcNow
    }));
}



