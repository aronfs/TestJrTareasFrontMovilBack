using SistemaVenta.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SistemaVenta.BLL.Services.Contrato
{
    public interface ITareasService
    {
        Task<List<TareaListarDTO>> Lista(int id);
        Task<List<TareaListarDTO>> ListaCompletadas(int id);
        Task<TareaDTO> Crear(TareaDTO tarea);
        Task<bool> Editar(TareaDTO tarea);
        Task<bool> Eliminado_Logico(int id);
        Task<bool> Completar_Tarea(int id);
        Task<bool> Eliminar(int id);
    }
}
