using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SistemaVenta.BLL.Services.Contrato;
using SistemaVenta.API.Utilidad;
using SistemaVenta.DTO;
namespace SistemaVenta.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class TareasController : ControllerBase
    {
      private readonly ITareasService _tareasService;

        public TareasController (ITareasService tareasService)
        {
            _tareasService = tareasService;
        }

        [HttpGet]
        [Route("Lista/{id:int}")]
        public async Task<IActionResult> Lista(int id) 
        {
            var response = new Response<List<TareaListarDTO>>();
            try {
                response.status = true;
                response.Value = await _tareasService.Lista(id);

            } 
            catch (Exception ex)
            {
                response.status = false;
                response.msg = ex.Message;
            }
            return Ok(response);
        }




        [HttpPost]
        [Route("Guardar")]
        public async Task<IActionResult> Guardar([FromBody] TareaDTO modelo)
        {
            var response = new Response<TareaDTO>();
            try
            {
                response.status = true;
                response.Value = await _tareasService.Crear(modelo);

            }
            catch (Exception ex)
            {
                response.status = false;
                response.msg = ex.Message;
            }
            return Ok(response);
        }


        [HttpPut]
        [Route("Editar")]
        public async Task<IActionResult> Editar([FromBody] TareaDTO modelo)
        {
            var response = new Response<bool>();
            try
            {
                response.status = true;
                response.Value = await _tareasService.Editar(modelo);

            }
            catch (Exception ex)
            {
                response.status = false;
                response.msg = ex.Message;
            }
            return Ok(response);
        }



        [HttpPut]
        [Route("CompletarTarea/{id:int}")]
        public async Task<IActionResult> CompletarTarea(int id)
        {
            var response = new Response<bool>();
            try
            {
                response.status = true;
                response.Value = await _tareasService.Completar_Tarea(id);
                response.msg = "Tarea se ha completado correctamente";
            }
            catch (Exception ex)
            {
                response.status = false;
                response.msg = ex.Message;
            }
            return Ok(response);
        }


        [HttpPut]
        [Route("Inactivar_Tarea/{id:int}")]
        public async Task<IActionResult> InactivarTarea(int id)
        {
            var response = new Response<bool>();
            try
            {
                response.status = true;
                response.Value = await _tareasService.Eliminado_Logico(id);
                response.msg = "Tarea Inactivada correctamente";
            }
            catch (Exception ex)
            {
                response.status = false;
                response.msg = ex.Message;
            }
            return Ok(response);
        }

        [HttpDelete]
        [Route("Eliminar/{id:int}")]
        public async Task<IActionResult> Eliminar(int id)
        {
            var response = new Response<bool>();
            try
            {
                response.status = true;
                response.Value = await _tareasService.Eliminar(id);

            }
            catch (Exception ex)
            {
                response.status = false;
                response.msg = ex.Message;
            }
            return Ok(response);
        }
    }
}
