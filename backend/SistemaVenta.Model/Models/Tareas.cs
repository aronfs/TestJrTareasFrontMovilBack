using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SistemaVenta.Model.Models;



public  partial class Tareas{
       public int IdTarea { get; set; }
       
       public string? Titulo_Tarea { get; set; }
       
       public string? Descripcion { get; set; }
        
       public string? Comentario { get; set; }

       public int IdUsuario{ get; set; }

       public bool Estado_Tarea { get; set; }
        
       public bool Inactivo { get; set; }

}
