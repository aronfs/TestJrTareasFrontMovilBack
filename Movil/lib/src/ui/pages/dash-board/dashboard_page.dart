import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/tareas_model.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/services/tareas_service.dart';
import 'package:sistema_ventas_app_v1/src/theme/app_theme.dart';
import 'package:sistema_ventas_app_v1/src/utility/navigation_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashBoardPageState();
}

enum _KanbanStage { todo, doing, done }

class _DashBoardPageState extends State<DashboardPage> {
  final TareaService _tareaService = TareaService();
  final PageController _pageController = PageController(viewportFraction: 0.92);

  bool _isLoading = true;
  final Map<_KanbanStage, List<Tareas>> _board = {
    _KanbanStage.todo: [],
    _KanbanStage.doing: [],
    _KanbanStage.done: [],
  };

  @override
  void initState() {
    super.initState();
    _cargarTablero();
  }

  Future<void> _cargarTablero() async {
    setState(() => _isLoading = true);
    final tareas = await _tareaService.cargarTareas(context);

    final todo = <Tareas>[];
    final doing = <Tareas>[];
    final done = <Tareas>[];

    for (final tarea in tareas) {
      if (tarea.estadoTarea == true) {
        done.add(tarea);
      } else if (doing.length < todo.length) {
        doing.add(tarea);
      } else {
        todo.add(tarea);
      }
    }

    if (!mounted) return;
    setState(() {
      _board[_KanbanStage.todo] = todo;
      _board[_KanbanStage.doing] = doing;
      _board[_KanbanStage.done] = done;
      _isLoading = false;
    });
  }

  Future<void> _moverTarea(Tareas tarea, _KanbanStage destino) async {
    final origen = _obtenerEtapaActual(tarea);
    if (origen == destino) return;

    if (origen == _KanbanStage.done && destino != _KanbanStage.done) {
      _mostrarMensaje('La tarea ya esta completada y no puede volver a pendiente.');
      return;
    }

    if (destino == _KanbanStage.done && tarea.estadoTarea != true) {
      await _tareaService.completearTarea(
        context: context,
        idTarea: tarea.idTarea,
      );
      await _cargarTablero();
      _mostrarMensaje('Tarea movida a finalizado.');
      return;
    }

    setState(() {
      for (final stage in _KanbanStage.values) {
        _board[stage]!.removeWhere((item) => item.idTarea == tarea.idTarea);
      }
      _board[destino]!.insert(0, tarea);
    });
  }

  _KanbanStage _obtenerEtapaActual(Tareas tarea) {
    for (final stage in _KanbanStage.values) {
      final existe = _board[stage]!.any((item) => item.idTarea == tarea.idTarea);
      if (existe) return stage;
    }
    return _KanbanStage.todo;
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _abrirFormularioNuevaTarea() async {
    navigationService.pushNamed(AppRoutes.tareasForm);
  }

  int _contarTotal() {
    return _KanbanStage.values.fold(0, (sum, stage) => sum + _board[stage]!.length);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Tablero de tareas'),
        actions: [
          IconButton(
            onPressed: _cargarTablero,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF16343D), Color(0xFF2C6673)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x2212323B),
                          blurRadius: 22,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x1FFFFFFF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Vista movil',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Desliza entre columnas y mueve tus tareas de una etapa a otra.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '${_contarTotal()} tareas cargadas en el tablero',
                          style: const TextStyle(
                            color: Color(0xFFD6EAE5),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildCounterChip('Para hacer', _board[_KanbanStage.todo]!.length),
                      _buildCounterChip('En proceso', _board[_KanbanStage.doing]!.length),
                      _buildCounterChip('Finalizado', _board[_KanbanStage.done]!.length),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    padEnds: false,
                    children: [
                      _buildColumn(
                        title: 'Para hacer',
                        subtitle: 'Pendientes por iniciar',
                        stage: _KanbanStage.todo,
                        accent: const Color(0xFFE8D7B4),
                      ),
                      _buildColumn(
                        title: 'En proceso',
                        subtitle: 'Trabajo en marcha',
                        stage: _KanbanStage.doing,
                        accent: const Color(0xFFDCEBE4),
                      ),
                      _buildColumn(
                        title: 'Finalizado',
                        subtitle: 'Tareas resueltas',
                        stage: _KanbanStage.done,
                        accent: const Color(0xFFD8E4F1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormularioNuevaTarea,
        backgroundColor: AppTheme.ink,
        foregroundColor: AppTheme.paper,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Anadir tarea'),
      ),
    );
  }

  Widget _buildCounterChip(String label, int count) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE3DCCE)),
      ),
      child: Text(
        '$label  $count',
        style: const TextStyle(
          color: AppTheme.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildColumn({
    required String title,
    required String subtitle,
    required _KanbanStage stage,
    required Color accent,
  }) {
    final tareas = _board[stage]!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 8, 110),
      child: DragTarget<Tareas>(
        onAcceptWithDetails: (details) async {
          await _moverTarea(details.data, stage);
        },
        builder: (context, candidateData, rejectedData) {
          final isActive = candidateData.isNotEmpty;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isActive ? accent.withOpacity(0.7) : AppTheme.paper,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isActive ? AppTheme.ocean : const Color(0xFFE3DCCE),
                width: isActive ? 2 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppTheme.ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$subtitle  ${tareas.length}',
                        style: const TextStyle(
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: tareas.isEmpty
                      ? Center(
                          child: Text(
                            'Suelta aqui una tarea',
                            style: TextStyle(
                              color: AppTheme.muted.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: tareas.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _buildTaskCard(tareas[index], stage);
                          },
                        ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _abrirFormularioNuevaTarea,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Anadir tarea'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(Tareas tarea, _KanbanStage stage) {
    return LongPressDraggable<Tareas>(
      data: tarea,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 280,
          child: _taskCardContent(tarea, compact: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: _taskCardContent(tarea),
      ),
      child: _taskCardContent(tarea),
    );
  }

  Widget _taskCardContent(Tareas tarea, {bool compact = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7E0D4)),
        boxShadow: compact
            ? const []
            : const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 14,
                  offset: Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppTheme.ocean,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  tarea.tituloTarea ?? 'Tarea sin titulo',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tarea.descripcion ?? 'Sin descripcion',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.muted,
              height: 1.35,
            ),
          ),
          if ((tarea.comentario ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F3EA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                tarea.comentario ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.muted,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
