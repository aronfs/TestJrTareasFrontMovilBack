import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/models/producto_model.dart';
import 'package:sistema_ventas_app_v1/src/services/producto_service.dart';
import 'package:sistema_ventas_app_v1/src/services/venta_service.dart';
import 'package:sistema_ventas_app_v1/src/models/detalle_venta_model.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/widgets_form/select_producto.dart';

class VentaPage extends StatefulWidget {
  
  const VentaPage({super.key});

  @override
  State<VentaPage> createState() => _VentaPageState();
}

class _VentaPageState extends State<VentaPage> {
  final TextEditingController _cantidadController = TextEditingController();
  int? _selectedRole;
  String? _estadoSeleccionado;
  int? _cantidad ;
  double? _precio;
  int? total;
  final VentaService _ventaService = VentaService();
  final ProductoService _productoService = ProductoService();
 // Lista de estados
  final List<Map<String, dynamic>> estados = [
    {'label': 'Efectivo', 'value': 'Efectivo'},
    {'label': 'Tarjeta', 'value': 'Tarjeta'},
  ];
List<Map<String, dynamic>> ventas = [];
   
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
double parsePrecio(String? precio) {
  if (precio == null || precio.isEmpty) {
    throw FormatException("El precio no puede estar vacío o nulo");
  }

  // Reemplazar coma por punto antes de convertir
  String precioCorregido = precio.replaceAll(',', '.');

  double? parsed = double.tryParse(precioCorregido);
  if (parsed == null) {
    throw FormatException("Formato inválido: '$precio' no es un número válido");
  }

  return parsed;
}
Future<void> agregarVenta(int productoId, int cantidad, String tipoPago) async {
  final producto = await _productoService.getProductoById(productoId);
  
  print("Super Precio");
  
  // Convertir el precio correctamente
  double precioUnitario = parsePrecio(producto.precio);

  print("Precio Unitario: $precioUnitario");

  double total = cantidad * precioUnitario;

  setState(() {
    ventas.add({
      'productoId': productoId,
      'productoNombre': producto.nombre,
      'descripcionProducto': producto.descripcionCategoria,
      'cantidad': cantidad,
      'tipoPago': tipoPago,
      'precioUnitario': precioUnitario,
      'total': total,
    });
  });
}
  double calcularTotalGeneral() {
    return ventas.fold(0.0, (sum, venta) => sum + (venta['total'] as double));
  }

void registrarVenta() {
  if (ventas.isEmpty || _estadoSeleccionado == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Debe agregar productos y seleccionar el tipo de pago'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  double totalVenta = calcularTotalGeneral();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Resumen de Venta"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tipo de Pago: $_estadoSeleccionado",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Total: \$${totalVenta.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const Divider(),
              const Text("Productos:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              ...ventas.map(
                (venta) => ListTile(
                  title: Text('${venta['productoNombre']} (${venta['descripcionProducto']})'),
                  subtitle: Text(
                    'Cantidad: ${venta['cantidad']} - Precio: \$${venta['precioUnitario'].toStringAsFixed(2)}',
                  ),
                  trailing: Text(
                    'Total: \$${venta['total'].toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              confirmarVenta();
            },
            icon: const Icon(Icons.check),
            label: const Text("Confirmar Venta"),
          ),
        ],
      );
    },
  );
}

void confirmarVenta() async {
  try {
    _cantidad = int.tryParse(_cantidadController.text);
    print("Cantidad $_cantidadController.text");
    await _ventaService.guardarVenta(
      context: context,
      tipoPago: _estadoSeleccionado!,
      
      totalTexto: calcularTotalGeneral().toStringAsFixed(2).replaceAll('.', ','),
      detalleVenta: ventas.map((venta) => DetalleVenta(
        idProducto: venta['productoId'],
        cantidad: venta['cantidad'],
        descripcionProducto: venta['descripcionProducto'],
        precioTexto: venta['precioUnitario'].toStringAsFixed(2).replaceAll('.', ','),
        totalTexto: venta['total'].toStringAsFixed(2).replaceAll('.', ','),
      )).toList(),
    );

    setState(() {
      ventas.clear();
      _estadoSeleccionado = null;
    });

  } catch (e) {
    print('❌ Error al registrar la venta: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error al registrar la venta'),
        backgroundColor: Colors.red,
      ),
    );
  }
}








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Venta')),

      
      body: Form(
          
          child: ListView(
            children: [
                const SizedBox(height: 16),
               const Text('Selecciona el Producto'),
              SelectProducto(
                value: _selectedRole,
                    onChanged: (idProducto) {
                      setState(() => _selectedRole = idProducto);
                    },
                ),
                 const SizedBox(height: 16),
              //Seleccion del Stock del Producto------------------------------------ 
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  suffixIcon: Icon(Icons.numbers),
                  ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese un valor entero valido'
                    : null,
              ),
              const SizedBox(height: 16),
                const SizedBox(height: 32),
              const Text('Tipo de Pago:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _estadoSeleccionado,
                hint: const Text('Selecciona el Tipo de Pago'),
                items: estados.map((estado) {
                  return DropdownMenuItem<String>(
                    value: estado['value'],
                    child: Text(estado['label']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() => _estadoSeleccionado = newValue);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_selectedRole != null &&
                    _cantidadController.text.isNotEmpty &&
                    _estadoSeleccionado != null) {
                  agregarVenta(
                    _selectedRole!,
                    int.parse(_cantidadController.text),
                    _estadoSeleccionado!,
                  );
                }
              },
              child: Text("Agregar"),
            ),
            const SizedBox(height: 16),
            const Text('Ventas Registradas:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ventas.length,
              itemBuilder: (context, index) {
                final venta = ventas[index];
                return Card(
                  child: ListTile(
                       title: Text('Producto: ${venta['productoNombre']}'),
        subtitle: Text(
          'Cantidad: ${venta['cantidad']} - Pago: ${venta['tipoPago']}\n'
          'Precio: \$${venta['precioUnitario']} - Total: \$${venta['total']}',
        ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          ventas.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
              const SizedBox(height: 16),
            ElevatedButton(
              onPressed: registrarVenta,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("Registrar Venta"),
            ),
          ],
        ),
    ),
  );
}
}