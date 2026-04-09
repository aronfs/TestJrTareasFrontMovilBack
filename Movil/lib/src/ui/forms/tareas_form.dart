import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/tareas_model.dart';
import 'package:sistema_ventas_app_v1/src/services/tareas_service.dart';
import 'package:sistema_ventas_app_v1/src/theme/app_theme.dart';

class TareasForm extends StatefulWidget {
  final Tareas? tareas;

  const TareasForm({super.key, this.tareas});

  @override
  State<TareasForm> createState() => _TareasFormState();
}

class _TareasFormState extends State<TareasForm> {
  final _formKey = GlobalKey<FormState>();
  final TareaService _tareasService = TareaService();

  final TextEditingController _tituloTareaController = TextEditingController();
  final TextEditingController _descripcionTareaController =
      TextEditingController();
  final TextEditingController _comentarioTareaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.tareas != null) {
      _tituloTareaController.text = widget.tareas!.tituloTarea ?? '';
      _descripcionTareaController.text = widget.tareas!.descripcion ?? '';
      _comentarioTareaController.text = widget.tareas!.comentario ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tareas != null;

    return Scaffold(
      backgroundColor: AppTheme.sand,
      appBar: AppBar(
        title: Text(isEditing ? 'Editar tarea' : 'Nueva tarea'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8D7B4), Color(0xFFF5EDDE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Refina una tarea existente' : 'Crea una tarea con claridad',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mantén el contenido breve, accionable y fácil de seguir para el resto del equipo.',
                  style: TextStyle(color: AppTheme.muted, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.paper,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE3DCCE)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _tituloTareaController,
                    decoration: const InputDecoration(
                      labelText: 'Titulo de la tarea',
                      hintText: 'Ej. Confirmar entrega del pedido',
                      prefixIcon: Icon(Icons.title_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese el titulo de la tarea';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _descripcionTareaController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Descripcion',
                      hintText: 'Describe el objetivo y los detalles clave.',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.notes_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese la descripcion de la tarea';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _comentarioTareaController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Comentario',
                      hintText: 'Anota contexto adicional o seguimiento.',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese un comentario para la tarea';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (!(_formKey.currentState?.validate() ?? false)) return;

                      if (isEditing) {
                        await _tareasService.actualizartarea(
                          context: context,
                          formKey: _formKey,
                          idTarea: widget.tareas?.idTarea ?? 0,
                          idUsuario: widget.tareas?.idUsuario,
                          tituloTarea: _tituloTareaController.text,
                          descripcionTarea: _descripcionTareaController.text,
                          comentarioTarea: _comentarioTareaController.text,
                        );
                      } else {
                        await _tareasService.guardarTarea(
                          context: context,
                          formKey: _formKey,
                          tituloTarea: _tituloTareaController.text,
                          descripcionTarea: _descripcionTareaController.text,
                          comentarioTarea: _comentarioTareaController.text,
                        );
                      }
                    },
                    icon: Icon(
                      isEditing ? Icons.system_update_alt_rounded : Icons.save_rounded,
                    ),
                    label: Text(
                      isEditing ? 'Actualizar tarea' : 'Guardar tarea',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tituloTareaController.dispose();
    _descripcionTareaController.dispose();
    _comentarioTareaController.dispose();
    super.dispose();
  }
}
