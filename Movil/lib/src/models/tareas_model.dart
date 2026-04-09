class Tareas {
    final int? idTarea;
    final String? tituloTarea;
    final String? descripcion;
    final String? comentario;
    final bool? estadoTarea;
    final int? idUsuario;

    Tareas({
        this.idTarea,
        this.tituloTarea,
        this.descripcion,
        this.comentario,
        this.estadoTarea,
        this.idUsuario
    });

    Tareas copyWith({
        int? idTarea,
        String? tituloTarea,
        String? descripcion,
        String? comentario,
        bool? estadoTarea,
        int? idUsuario
    }) => 
        Tareas(
            idTarea: idTarea ?? this.idTarea,
            tituloTarea: tituloTarea ?? this.tituloTarea,
            descripcion: descripcion ?? this.descripcion,
            comentario: comentario ?? this.comentario,
            estadoTarea: estadoTarea ?? this.estadoTarea,
            idUsuario: idUsuario ?? this.idUsuario
        );

    factory Tareas.fromJson(Map<String, dynamic> json){
      return Tareas(
        idTarea: json['idTarea'] ?? 0,
        tituloTarea: json['titulo_Tarea'] ?? 'No hay tareas',
        descripcion: json['descripcion'],
        comentario: json['comentario'],
        estadoTarea: json['estado_Tarea'],
        idUsuario: json['idUsuario'] 
      );
    }

    Map<String, dynamic> toJson(){
      return {
        'idTarea': idTarea,
        'titulo_Tarea': tituloTarea,
        'descripcion': descripcion,
        'comentario': comentario,
        'idUsuario': idUsuario
      };
    }

}
