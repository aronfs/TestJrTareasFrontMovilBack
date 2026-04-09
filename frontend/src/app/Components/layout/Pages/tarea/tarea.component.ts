import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { tareas } from '../../../../Interfaces/tareas';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { MatDialog } from '@angular/material/dialog';
import { TareasService } from '../../../../Services/tareas.service';
import { UtilidadService } from '../../../../Reutilizable/utilidad.service';
import { UsuarioService } from '../../../../Services/usuario.service';
import { RolService } from '../../../../Services/rol.service';
import { Usuario } from '../../../../Interfaces/usuario';
import { jwtDecode } from 'jwt-decode';
import { ModalTareasComponent } from '../../Modales/modal-tareas/modal-tareas.component';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-tarea',
  standalone: false,
  templateUrl: './tarea.component.html',
  styleUrl: './tarea.component.css'
})
export class TareaComponent implements OnInit, AfterViewInit {


  columnasTable: string[] = ['titulo_Tarea', 'descripcion', 'comentario', 'estado_Tarea', 'acciones']
  dataInicio: tareas[] = [];
  dataListaTareasa = new MatTableDataSource(this.dataInicio)
  correoUsuario: string = "";
  @ViewChild(MatPaginator) paginacionTabla!: MatPaginator;

  constructor(
    private dialog: MatDialog,
    private _tareasService: TareasService,
    private _utilidadService: UtilidadService,
    private _rolServicio: RolService,
    private _usuarioServicio: UsuarioService
  ) { }

  obtenerListatareas() {
    const token = this._utilidadService.obtenerToken();
    if (token) {
      try {
        const usuario: any = jwtDecode(token);  // Decodificar el token
        console.log("Correo:", usuario);
        //Mis variables 
        //Obtener los claims del payload del token
        this.correoUsuario = usuario["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"];
        // this.rolUsuario = usuario["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
      } catch (error) {
        console.error("Error al decodificar el token:", error);
      }
    };
    this._usuarioServicio.lista().subscribe({
      next: (response) => {
        if (response.status) {
          const usuarios = response.value;
          //Encontrar el usuario por el correo
          const usuarioEncontrado = usuarios.find((usuario: Usuario) => usuario.correo === this.correoUsuario);
          if (usuarioEncontrado) {
            // this.dataUsuario = usuarioEncontrado;
            console.log("Usuario encontrado en tareas:", usuarioEncontrado.idUsuario);
          }

          this._tareasService.lista(usuarioEncontrado.idUsuario).subscribe({
            next: (response) => {
              if (response.status) {

                const tareas = response.value;
                this.dataListaTareasa.data = tareas
              }
            }
          })



        }
      }
    }
    );

  }


  ngOnInit(): void {
    this.obtenerListatareas();
  }

  ngAfterViewInit(): void {

  }

  nuevaTarea() {
    this.dialog.open(ModalTareasComponent, {
      disableClose: true,
      width: '920px',
      maxWidth: '95vw',
      autoFocus: false
    })
      .afterClosed().subscribe(
        resultado => {
          if(resultado === "true") this.obtenerListatareas();
        }
      )
  }

  editarTarea(tarea: tareas) {
    this.dialog.open(ModalTareasComponent, {
      disableClose: true,
      data: tarea,
      width: '920px',
      maxWidth: '95vw',
      autoFocus: false
    })
      .afterClosed().subscribe(
        resultado => {
          if (resultado === "true") this.obtenerListatareas() 
        }
      )
  }

  inactivarTarea(tarea: tareas) {
    Swal.fire({
      title: "¿Desea inactivar la tarea?",
      text: tarea.titulo_tarea,
      icon: "warning",
      confirmButtonColor: '#3085d6',
      confirmButtonText: "Si, inactivar",
      showCancelButton: true,
      cancelButtonColor: '#d33',
      cancelButtonText: 'No, volver'
    }).then((resultado)=> { 
      if (resultado.isConfirmed){
         this._tareasService.inactivarTarea(tarea.idTarea).subscribe({
          next: (data)=> {
            if(data.status){
              this._utilidadService.mostrarAlerta("La tarea fue inactivada", "OK");
              this.obtenerListatareas();
            }else{
              this._utilidadService.mostrarAlerta("No se pudo inactivar la tarea ", "Error");
            
            }
          }
         })
      }
     
    })
  }

  completarTarea(tarea: tareas) {
 Swal.fire({
      title: "¿Desea completar la tarea?",
      text: tarea.titulo_tarea,
      icon: "warning",
      confirmButtonColor: '#3085d6',
      confirmButtonText: "Si, completar",
      showCancelButton: true,
      cancelButtonColor: '#d33',
      cancelButtonText: 'No, volver'
    }).then((resultado)=> { 
      if (resultado.isConfirmed){
         this._tareasService.completarTarea(tarea.idTarea).subscribe({
          next: (data)=> {
            if(data.status){
              this._utilidadService.mostrarAlerta("La tarea fue completada", "OK");
              this.obtenerListatareas();
            }else{
              this._utilidadService.mostrarAlerta("No se pudo completar la tarea", "Error");
            
            }
          }
         })
      }
     
    })
  }

  aplicarFiltroTabla(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataListaTareasa.filter = filterValue.trim().toLowerCase();
  }



}
