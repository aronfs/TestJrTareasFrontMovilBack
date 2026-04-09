import 'package:rxdart/rxdart.dart';
import 'package:sistema_ventas_app_v1/src/models/reporte_model.dart';
import 'package:sistema_ventas_app_v1/src/models/venta_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/venta_repository.dart';

class VentaBloc {
  final _ventaRepository = VentaRepository();
  
  // Controla el estado de carga
  final _isLoadingController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoading => _isLoadingController.stream;

  // Controla el estado de guardado (true si se crea exitosamente)
  final _ventaRegistroController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get ventaSave => _ventaRegistroController.stream;

final _ventaHistorialController = BehaviorSubject<List<VentaModel>>.seeded([]);
  Stream<List<VentaModel>> get historialStream => _ventaHistorialController.stream;

final _ventaReporteController = BehaviorSubject<List<ReporteModel>>.seeded([]);
  Stream<List<ReporteModel>> get reporteStream => _ventaReporteController.stream;



  // Crear un nuevo usuario
  Future<bool> registroVenta(String token, VentaModel venta) async {
    _setLoadingState(true);
    try {
      final ventaCreada = await _ventaRepository.registrarVenta(venta, token);
      if (ventaCreada) {
        _ventaRegistroController.add(true); // Éxito
        return true;
      } else {
        _ventaRegistroController.add(false); // Error
        return false;
      }
    } catch (e) {
      _ventaRegistroController.add(false);
      print('❌ Error en crear Venta: $e');
      return false;
    } finally {
      _setLoadingState(false);
    }
  }


  
Future<List<VentaModel>> cargaHistorialNumeroVenta(
    String token, String filtro, String numeroVenta, String fechaInicio, String fechaFin) async {
  
  _setLoadingState(true);
  
  try {
    // Obtener historial de ventas desde el repositorio
    final historialVentas = await _ventaRepository.historial(token, filtro, numeroVenta, fechaInicio, fechaFin);
    
    // Emitir los datos al stream
    _ventaHistorialController.add(historialVentas);
    
    return historialVentas;
  } catch (e) {
    _ventaHistorialController.addError('❌ Error al cargar historial de ventas: $e');
    print('❌ Error al cargar historial de ventas: $e');
    return [];
  } finally {
    _setLoadingState(false);
  }
}



Future<List<ReporteModel>> reporteVentas(String token,  String fechaInicio, String fechaFin) async {
  
  _setLoadingState(true);
  
  try {
    // Obtener historial de ventas desde el repositorio
    final reporteVentas = await _ventaRepository.reporte(token, fechaInicio, fechaFin);
    
    // Emitir los datos al stream
    _ventaReporteController.add(reporteVentas);
    
    return reporteVentas;
  } catch (e) {
    _ventaReporteController.addError('❌ Error al cargar el reporte de ventas: $e');
    print('❌ Error al cargar reporte de ventas: $e');
    return [];
  } finally {
    _setLoadingState(false);
  }
}

  // Control de estado de carga
  void _setLoadingState(bool isLoading) {
    if (!_isLoadingController.isClosed) {
      _isLoadingController.add(isLoading);
    }
  }

  // Limpiar los streams
  void dispose() {
    _isLoadingController.close();
    _ventaRegistroController.close();
   
  }
}

// Instancia global del UsuarioBloc
final ventaBloc = VentaBloc();
