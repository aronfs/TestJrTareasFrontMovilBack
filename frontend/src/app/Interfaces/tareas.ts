export interface tareas {
    idTarea: number,
    titulo_tarea: string,
    descripcion:string,
    comentario: string,
    idUsuario?: number,
    estado_tarea?: boolean,
    inactivo?: boolean
}