using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SistemaVenta.DTO
{
    public class TareaDTO
    {
        public int? idTarea { get; set; }
        
        public string? Titulo_Tarea { get; set; }

        public string? descripcion { get; set; }

        public string? comentario { get; set; }
        public int idUsuario { get; set; }
        public bool? Estado_Tarea { get; set; }

        public bool? Inactivo { get; set; }
    }

    public class TareaListarDTO
    {
        public int? idTarea { get; set; }

        public string? Titulo_Tarea { get; set; }

        public string? descripcion { get; set; }

        public string? comentario { get; set; }

        public bool? Estado_Tarea { get; set; }

      

    }
}
