import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_ventas_app_v1/src/models/dashboard_model.dart';
import 'package:sistema_ventas_app_v1/src/models/tareas_model.dart';
import 'package:sistema_ventas_app_v1/src/theme/app_theme.dart';

class DashboardWidget extends StatelessWidget {
  final List<DashBoardModel> dashboardData;
  final List<Tareas> tareas;
  final VoidCallback onGenerarMasTareas;

  const DashboardWidget({
    super.key,
    required this.dashboardData,
    required this.tareas,
    required this.onGenerarMasTareas,
  });

  @override
  Widget build(BuildContext context) {
    if (dashboardData.isEmpty) {
      return const Center(child: Text('No hay datos disponibles'));
    }

    final dashboard = dashboardData.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      children: [
        _buildHero(context),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total ventas',
                dashboard.totalVentas.toString(),
                FontAwesomeIcons.cartShopping,
                const Color(0xFF295C6B),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Ingresos',
                dashboard.totalIngresos ?? 'N/A',
                FontAwesomeIcons.sackDollar,
                const Color(0xFF5C8B7B),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Productos',
                dashboard.totalProductos.toString(),
                FontAwesomeIcons.boxOpen,
                const Color(0xFFBE7D3A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _buildTaskSummary(context),
        const SizedBox(height: 18),
        _buildChartCard(context, dashboard),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16343D), Color(0xFF2C6673)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2212323B),
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x1FFFFFFF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Resumen ejecutivo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tu operacion se ve mejor cuando ventas y tareas viven en el mismo tablero.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${_contarTareasTotales()} tareas registradas para seguimiento',
            style: const TextStyle(
              color: Color(0xFFD6EAE5),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onGenerarMasTareas,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.paper,
              foregroundColor: AppTheme.ink,
            ),
            icon: const Icon(Icons.add_task_rounded),
            label: const Text('Generar mas tareas'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSummary(BuildContext context) {
    final total = _contarTareasTotales();
    final completadas = _contarTareasCompletadas();
    final pendientes = _contarTareasPendientes();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE3DCCE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado de tareas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Contadores calculados desde tu listado actual.',
            style: TextStyle(color: AppTheme.muted),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildMiniCounter(
                  'Total',
                  total.toString(),
                  Icons.sticky_note_2_outlined,
                  const Color(0xFFE8EFE9),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniCounter(
                  'Pendientes',
                  pendientes.toString(),
                  Icons.pending_actions_rounded,
                  const Color(0xFFF2E7D6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniCounter(
                  'Completadas',
                  completadas.toString(),
                  Icons.task_alt_rounded,
                  const Color(0xFFDCEDE6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, DashBoardModel dashboard) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE3DCCE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ventas ultima semana',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Tendencia diaria para seguir el ritmo comercial.',
            style: TextStyle(color: AppTheme.muted),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.45,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(dashboard),
                barGroups: _generateBarGroups(dashboard),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) {
                    return const FlLine(
                      color: Color(0xFFE6DED0),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final ventas = dashboard.ventaUltimaSemana ?? [];
                        if (value.toInt() < 0 || value.toInt() >= ventas.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            ventas[value.toInt()].fecha ?? '',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.muted,
                            ),
                          ),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color accent,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE3DCCE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCounter(
    String label,
    String value,
    IconData icon,
    Color background,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.ink),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  int _contarTareasTotales() {
    return tareas.length;
  }

  int _contarTareasCompletadas() {
    return tareas.where((tarea) => tarea.estadoTarea == true).length;
  }

  int _contarTareasPendientes() {
    return tareas.where((tarea) => tarea.estadoTarea != true).length;
  }

  List<BarChartGroupData> _generateBarGroups(DashBoardModel dashboard) {
    return List.generate(dashboard.ventaUltimaSemana?.length ?? 0, (index) {
      final data = dashboard.ventaUltimaSemana?[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data?.total?.toDouble() ?? 0.0,
            color: AppTheme.ocean,
            width: 18,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
        ],
      );
    });
  }

  double _getMaxY(DashBoardModel dashboard) {
    final ventas = dashboard.ventaUltimaSemana;
    if (ventas == null || ventas.isEmpty) {
      return 10;
    }

    final maxVal = ventas
        .map((e) => e.total?.toDouble() ?? 0.0)
        .reduce((a, b) => a > b ? a : b);

    return maxVal == 0 ? 10 : maxVal + (maxVal * 0.2);
  }
}
