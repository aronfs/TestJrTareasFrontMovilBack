import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/venta_bloc/venta_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/detalle_venta_model.dart';
import 'package:sistema_ventas_app_v1/src/models/reporte_model.dart';
import 'package:sistema_ventas_app_v1/src/models/venta_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/session_manager.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
class VentaService {
  final VentaBloc _ventaBloc = ventaBloc;
  final sessionManager = SessionManager();

  void _mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }
Future<void> _solicitarPermisos() async {
  if (await Permission.storage.request().isGranted) {
    print("✅ Permiso concedido");
  } else {
    print("❌ Permiso denegado");
  }
}
  Future<void> guardarVenta({
    required BuildContext context,
    required String tipoPago,
    required String totalTexto,
    required List<DetalleVenta> detalleVenta,
  }) async {
    await sessionManager.init();
    final token = sessionManager.token;

    if (token == null || token.isEmpty) {
      print('⚠️ No se encontró el token.');
      _mostrarMensaje(context, 'Error: No se encontró el token de sesión.');
      return;
    }

    final venta = VentaModel(
      idVenta: 0, // ID autogenerado en la API
      tipoPago: tipoPago,
      totalTexto: totalTexto,
      detalleVenta: detalleVenta, // Se envía la lista de detalles
    );

    try {
      final resultado = await _ventaBloc.registroVenta(token, venta);

      if (resultado) {
        _mostrarMensaje(context, 'Venta registrada exitosamente');
       // Navigator.pop(context);
      } else {
        _mostrarMensaje(context, 'Error al registrar la venta $resultado');
      }
    } catch (e) {
      print('❌ Error al registrar venta: $e');
      _mostrarMensaje(context, 'Error al registrar la venta');
    }
  }

 Future<List<VentaModel>> BuscarPorFechaInicioFin(BuildContext context, String FechaInicio, String FechaFin) async {
  await sessionManager.init();
  final token = sessionManager.token;

  if (token == null || token.isEmpty) {
    print('⚠️ No se encontró el token.');
    _mostrarMensaje(context, 'Error: No se encontró el token de sesión.');
    return []; // Retorna una lista vacía en caso de error
  }

  try {
    // ✅ Convierte las fechas de "YYYY-MM-DD" a "DD/MM/YYYY"
    String fechaInicioFormat = _convertirFechaFormato(FechaInicio);
    String fechaFinFormat = _convertirFechaFormato(FechaFin);

    print("📅 Buscando ventas del $fechaInicioFormat al $fechaFinFormat");

    final resultado = await _ventaBloc.cargaHistorialNumeroVenta(
      token, "fecha", "", fechaInicioFormat, fechaFinFormat
    );

    // Verifica si la lista está vacía
    if (resultado.isEmpty) {
      print('⚠️ No hay datos para las fechas seleccionadas.');
      _mostrarMensaje(context, 'No hay ventas en este rango de fechas.');
    }

    return resultado; // Retorna la lista obtenida
  } catch (e) {
    print('❌ Error al obtener datos: $e');
    _mostrarMensaje(context, 'Error al obtener datos');
    return []; // En caso de error, devuelve una lista vacía
  }
}


 Future<List<ReporteModel>> ReporteFechaFinyInicio(BuildContext context, String FechaInicio, String FechaFin) async {
  await sessionManager.init();
  final token = sessionManager.token;

  if (token == null || token.isEmpty) {
    print('⚠️ No se encontró el token.');
    _mostrarMensaje(context, 'Error: No se encontró el token de sesión.');
    return []; // Retorna una lista vacía en caso de error
  }

  try {
    // ✅ Convierte las fechas de "YYYY-MM-DD" a "DD/MM/YYYY"
    String fechaInicioFormat = _convertirFechaFormato(FechaInicio);
    String fechaFinFormat = _convertirFechaFormato(FechaFin);

    print("📅 Buscando ventas del $fechaInicioFormat al $fechaFinFormat");

    final resultado = await _ventaBloc.reporteVentas(
      token,  fechaInicioFormat, fechaFinFormat
    );

    // Verifica si la lista está vacía
    if (resultado.isEmpty) {
      print('⚠️ No hay datos para las fechas seleccionadas.');
      _mostrarMensaje(context, 'No hay ventas en este rango de fechas.');
    }

    return resultado; // Retorna la lista obtenida
  } catch (e) {
    print('❌ Error al obtener datos: $e');
    _mostrarMensaje(context, 'Error al obtener datos');
    return []; // En caso de error, devuelve una lista vacía
  }
}

Future<List<ReporteModel>> generarReporte(BuildContext context, String FechaInicio, String FechaFin) async {
  await sessionManager.init();
  final token = sessionManager.token;

  if (token == null || token.isEmpty) {
    print('⚠️ No se encontró el token.');
    _mostrarMensaje(context, 'Error: No se encontró el token de sesión.');
    return []; // Retorna una lista vacía en caso de error
  }

  try {
    // ✅ Convierte las fechas de "YYYY-MM-DD" a "DD/MM/YYYY"
    String fechaInicioFormat = _convertirFechaFormato(FechaInicio);
    String fechaFinFormat = _convertirFechaFormato(FechaFin);

    print("📅 Buscando ventas del $fechaInicioFormat al $fechaFinFormat");

    final resultado = await _ventaBloc.reporteVentas(
      token, fechaInicioFormat, fechaFinFormat
    );

    // Verifica si la lista está vacía
    if (resultado.isEmpty) {
      print('⚠️ No hay datos para las fechas seleccionadas.');
      _mostrarMensaje(context, 'No hay ventas en este rango de fechas.');
    } else {
      await generarExcel(resultado); // Genera el archivo Excel con los datos obtenidos
    }

    return resultado; // Retorna la lista obtenida
  } catch (e) {
    print('❌ Error al obtener datos: $e');
    _mostrarMensaje(context, 'Error al obtener datos');
    return []; // En caso de error, devuelve una lista vacía
  }
}

Future<void> generarExcel(List<ReporteModel> ventas) async {
  await _solicitarPermisos(); // Asegurar permisos

  var excel = Excel.createExcel();
  Sheet sheetObject = excel["Reporte de Ventas"];

  // Agregar encabezados
  sheetObject.appendRow([
    TextCellValue("Documento"),
    TextCellValue("Tipo Pago"),
    TextCellValue("Total Venta"),
    TextCellValue("Fecha Registro"),
    TextCellValue("Producto"),
    TextCellValue("Cantidad"),
    TextCellValue("Precio")
  ]);

  // Agregar datos
  for (var venta in ventas) {
    sheetObject.appendRow([
      TextCellValue(venta.numeroDocumento ?? 'N/A'),
      TextCellValue(venta.tipoPago ?? 'N/A'),
      DoubleCellValue(double.tryParse(venta.totalVenta.toString()) ?? 0.0),
      TextCellValue(venta.fechaRegistro ?? 'N/A'),
      TextCellValue(venta.producto ?? 'N/A'),
      IntCellValue(venta.cantidad ?? 0),
      DoubleCellValue(double.tryParse(venta.precio.toString()) ?? 0.0),
    ]);
  }

  // Obtener la carpeta de Documentos
  Directory directory = await getApplicationDocumentsDirectory();
  String filePath = "${directory.path}/Reporte_Ventas.xlsx";
  File file = File(filePath);

  // Guardar archivo
  try {
    await file.create(recursive: true);
    await file.writeAsBytes(excel.encode()!);
    print("✅ Archivo guardado en: $filePath");

    // 🔥 Abrir el archivo después de guardarlo
    OpenFile.open(filePath);
  } catch (e) {
    print("❌ Error al guardar archivo: $e");
  }
}



 void mostrarDetalleReporte(BuildContext context, ReporteModel venta) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.receipt_long, color: Colors.blueAccent),
            SizedBox(width: 8),
            Text("Detalle", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.confirmation_number, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text("Documento: ${venta.numeroDocumento}")
            ]),
            Row(children: [
              Icon(Icons.payment, color: Colors.green),
              SizedBox(width: 8),
              Text("Tipo Pago: ${venta.tipoPago}")
            ]),
            Row(children: [
              Icon(Icons.attach_money, color: Colors.orange),
              SizedBox(width: 8),
              Text("Total Venta: ${venta.totalVenta}")
            ]),
            Row(children: [
              Icon(Icons.calendar_today, color: Colors.red),
              SizedBox(width: 8),
              Text("Fecha: ${venta.fechaRegistro}")
            ]),
            SizedBox(height: 10),
            Divider(),
            Text("Productos:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Row(children: [
              Icon(Icons.inventory, color: Colors.purple),
              SizedBox(width: 8),
              Text("Nombre: ${venta.producto}")
            ]),
            Row(children: [
              Icon(Icons.production_quantity_limits, color: Colors.blueGrey),
              SizedBox(width: 8),
              Text("Cantidad: ${venta.cantidad}")
            ]),
            Row(children: [
              Icon(Icons.monetization_on, color: Colors.green),
              SizedBox(width: 8),
              Text("Precio: ${venta.precio}")
            ]),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cerrar", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      );
    },
  );
}





 /// Función para mostrar los detalles de la venta en un diálogo modal
  void mostrarDetalleVenta(BuildContext context, VentaModel venta) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Detalles de la Venta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📄 Documento: ${venta.numeroDocumento}"),
              Text("📅 Fecha: ${venta.fechaRegistro}"),
             
              Text("💰 Total: ${venta.totalTexto}"),
              const SizedBox(height: 10),
              const Divider(),
              Text("📦 Productos:", style: TextStyle(fontWeight: FontWeight.bold)),
              if (venta.detalleVenta != null) 
                for (var producto in venta.detalleVenta!) 
                  Text("• ${producto.descripcionProducto} - ${producto.cantidad} x ${producto.precioTexto}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

/// 🔥 **Función para convertir fecha de "YYYY-MM-DD" a "DD/MM/YYYY"**
String _convertirFechaFormato(String fecha) {
  try {
    List<String> partes = fecha.split('-'); // Divide en partes
    if (partes.length == 3) {
      return "${partes[2]}/${partes[1]}/${partes[0]}"; // Reorganiza en DD/MM/YYYY
    }
  } catch (e) {
    print("⚠️ Error formateando fecha: $fecha");
  }
  return fecha; // Si hay un error, devuelve la fecha original
}



  Future<List<VentaModel>> BuscarPorNumeroVenta(BuildContext context, String NumeroVenta) async {
  await sessionManager.init();
  final token = sessionManager.token;

  if (token == null || token.isEmpty) {
    print('⚠️ No se encontró el token.');
    _mostrarMensaje(context, 'Error: No se encontró el token de sesión.');
    return []; // Retorna una lista vacía en caso de error
  }

  try {
    final resultado = await _ventaBloc.cargaHistorialNumeroVenta(
      token, "NumeroVenta", NumeroVenta, "", ""
    );
    
    // Verifica si la lista está vacía
    if (resultado.isEmpty) {
      print('⚠️ No hay datos para las fechas seleccionadas.');
      _mostrarMensaje(context, 'No hay ventas en este rango de fechas.');
    }

    return resultado; // Retorna la lista obtenida
  } catch (e) {
    print('❌ Error al obtener datos: $e');
    _mostrarMensaje(context, 'Error al obtener datos');
    return []; // En caso de error, devuelve una lista vacía
  }
}


}
