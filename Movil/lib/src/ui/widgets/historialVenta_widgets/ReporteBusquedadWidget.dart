import 'package:flutter/material.dart';

class Reportebusquedadwidget extends StatefulWidget {
 
  final Function(String fechaInicio, String fechaFin)? onBuscarPorFecha;
  final Function(String fechaInicio, String fechaFin)? generarReporte;

  const Reportebusquedadwidget({
    super.key,
    this.onBuscarPorFecha,
    this.generarReporte
  });

  @override
  _ReportebusquedadwidgetState createState() => _ReportebusquedadwidgetState();
}

class _ReportebusquedadwidgetState extends State<Reportebusquedadwidget> {
 
  
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();

  void _seleccionarFecha(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        // Asegura que el mes y día tengan 2 dígitos
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }
 void _generarReporteManual() {
   if (_fechaInicioController.text.isEmpty || _fechaFinController.text.isEmpty) {
      _mostrarMensaje("⚠️ Seleccione ambas fechas");
      return;
    }
    widget.generarReporte?.call(_fechaInicioController.text, _fechaFinController.text);
    _mostrarMensaje2("📂 Generando reporte en Excel...");
    
    }

  void _buscarPorFecha() {
    if (_fechaInicioController.text.isEmpty || _fechaFinController.text.isEmpty) {
      _mostrarMensaje("⚠️ Seleccione ambas fechas");
      return;
    }
    widget.onBuscarPorFecha?.call(_fechaInicioController.text, _fechaFinController.text);
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }


   void _mostrarMensaje2(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: const Color.fromARGB(255, 15, 49, 202)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          TextField(
            controller: _fechaInicioController,
            decoration: const InputDecoration(labelText: "Fecha Inicio"),
            readOnly: true,
            onTap: () => _seleccionarFecha(_fechaInicioController),
          ),
          TextField(
            controller: _fechaFinController,
            decoration: const InputDecoration(labelText: "Fecha Fin"),
            readOnly: true,
            onTap: () => _seleccionarFecha(_fechaFinController),
          ),
          ElevatedButton(
            onPressed: _buscarPorFecha,
            child: const Text("Buscar"),
          ),
           ElevatedButton(
            onPressed: _generarReporteManual,
            child: const Text("Generar Reporte"),
          ),
           
        
      ],
    );
  }
}
