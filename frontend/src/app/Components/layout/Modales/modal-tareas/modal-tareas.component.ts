import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { tareas } from '../../../../Interfaces/tareas';
import { TareasService } from '../../../../Services/tareas.service';
import { UtilidadService } from '../../../../Reutilizable/utilidad.service';
import { RolService } from '../../../../Services/rol.service';
import { UsuarioService } from '../../../../Services/usuario.service';
import { jwtDecode } from 'jwt-decode';
import { Usuario } from '../../../../Interfaces/usuario';

@Component({
  selector: 'app-modal-tareas',
  standalone: false,
  templateUrl: './modal-tareas.component.html',
  styleUrl: './modal-tareas.component.css'
})
export class ModalTareasComponent implements OnInit {

  formularioTareas: FormGroup;
  tituloAccion: string = "Agregar Nueva Tarea";
  botonAccion: string = "Guardar";
  correoUsuario: string = "";
//usuarioEncontrado: any = null;
  constructor(
    private modalActual: MatDialogRef<ModalTareasComponent>,
    @Inject(MAT_DIALOG_DATA)
    public datosTareas: tareas,
    private fb: FormBuilder,
    private _tareasService: TareasService,
    private _utilidadService: UtilidadService,
    private _rolServicio: RolService,
    private _usuarioServicio: UsuarioService

  ) {
    this.formularioTareas = this.fb.group({
      titulo_Tarea: ['', Validators.required],
      descripcion: ['', Validators.required],
      comentario: ['', Validators.required],
    })

    if (this.datosTareas != null) {
      this.tituloAccion = 'Editar Tarea';
      this.botonAccion = 'Actualizar'

    }



  }



  ngOnInit(): void {
    if(this.datosTareas != null){
      this.formularioTareas.patchValue({
        titulo_Tarea: this.datosTareas.titulo_tarea,
        descripcion: this.datosTareas.descripcion,
        comentario: this.datosTareas.comentario
      })
    }
  }

  obtenerEstadoVisual(): string {
    const estado = (this.datosTareas as any)?.estado_Tarea ?? this.datosTareas?.estado_tarea;
    return estado ? 'Finalizada' : 'Para hacer';
  }

  guardarEditar_Tareas() {
       const token = this._utilidadService.obtenerToken();
        if (token) {
          try {
            const usuario: any = jwtDecode(token);  // Decodificar el token
            console.log("ID AQUI:", usuario);
            //Mis variables 
            //Obtener los claims del payload del token
            this.correoUsuario = usuario["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
            // this.rolUsuario = usuario["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
          } catch (error) {
            console.error("Error al decodificar el token:", error);
          }
        };


    const _tareas: tareas = {
      idTarea: this.datosTareas == null ? 0 : this.datosTareas.idTarea,
      titulo_tarea: this.formularioTareas.value.titulo_Tarea,
      descripcion: this.formularioTareas.value.descripcion,
      comentario: this.formularioTareas.value.comentario,
      idUsuario: Number(this.correoUsuario)
    }


    if (this.datosTareas == null) {
      this._tareasService.guardar(_tareas).subscribe({
        next: (data) => {
          if (data.status) {
            this._utilidadService.mostrarAlerta("La Tarea fue registrado", "Super Éxito");
            this.modalActual.close("true");
          }
        }
      }
      )
    } else {
      
      this._tareasService.editar(_tareas).subscribe({
        next: (data) => {
          if (data.status) {
            this._utilidadService.mostrarAlerta("La Tarea fue actualizado", "Super Éxito");
            this.modalActual.close("true");
          } else {
            console.log(_tareas)
            this._utilidadService.mostrarAlerta("No se puede actualizar la tarea", "Super Error");
          }
        }
      })
    }
  }
}
