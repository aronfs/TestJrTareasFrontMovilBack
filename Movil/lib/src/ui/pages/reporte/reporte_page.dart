import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/venta_bloc/venta_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/reporte_model.dart';
import 'package:sistema_ventas_app_v1/src/services/venta_service.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/historialVenta_widgets/ReporteBusquedadWidget.dart';

class ReportePage extends StatelessWidget {
  final VentaService _ventaService = VentaService();

  ReportePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Ventas')),
      body: Column(
        children: [
          // Widget de búsqueda
          Reportebusquedadwidget(
            onBuscarPorFecha: (fechaInicio, fechaFin) {
              _ventaService.ReporteFechaFinyInicio(context, fechaInicio, fechaFin);
              
            },
            generarReporte:  (fechaInicio, fechaFin) {
              _ventaService.generarReporte(context, fechaInicio, fechaFin);
              
            },
          ),
          Expanded(
            child: StreamBuilder<List<ReporteModel>>(
              stream: ventaBloc.reporteStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                final ventas = snapshot.data ?? [];
                if (ventas.isEmpty) {
                  return const Center(child: Text("No hay ventas disponibles."));
                }

                return ListView.builder(
                  itemCount: ventas.length,
                  itemBuilder: (context, index) {
                    final venta = ventas[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text("Venta: ${venta.numeroDocumento}"),
                        subtitle: Text("Fecha: ${venta.fechaRegistro}"),
                        trailing: ElevatedButton(
                          onPressed: () => _ventaService.mostrarDetalleReporte(context, venta),
                          child: const Text("Ver Más"),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

 
}
