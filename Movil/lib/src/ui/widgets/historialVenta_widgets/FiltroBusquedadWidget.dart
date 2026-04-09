import 'package:flutter/material.dart';

class FiltroBusquedaWidget extends StatefulWidget {
  final Function(String numeroVenta)? onBuscarPorNumeroVenta;
  final Function(String fechaInicio, String fechaFin)? onBuscarPorFecha;

  const FiltroBusquedaWidget({
    super.key,
    this.onBuscarPorNumeroVenta,
    this.onBuscarPorFecha,
  });

  @override
  _FiltroBusquedaWidgetState createState() => _FiltroBusquedaWidgetState();
}

class _FiltroBusquedaWidgetState extends State<FiltroBusquedaWidget> {
  String _filtroSeleccionado = 'numero_venta';
  final TextEditingController _numeroVentaController = TextEditingController();
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

  void _buscarPorNumeroVenta() {
    if (_numeroVentaController.text.isEmpty) {
      _mostrarMensaje("⚠️ Ingrese un número de venta");
      return;
    }
    widget.onBuscarPorNumeroVenta?.call(_numeroVentaController.text);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: _filtroSeleccionado,
          items: const [
            DropdownMenuItem(value: 'numero_venta', child: Text("Buscar por Número de Venta")),
            DropdownMenuItem(value: 'fecha', child: Text("Buscar por Fechas")),
          ],
          onChanged: (value) {
            setState(() {
              _filtroSeleccionado = value!;
            });
          },
        ),
        if (_filtroSeleccionado == 'numero_venta') ...[
          TextField(
            controller: _numeroVentaController,
            decoration: const InputDecoration(labelText: "Número de Venta"),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: _buscarPorNumeroVenta,
            child: const Text("Buscar"),
          ),
        ] else ...[
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
        ],
      ],
    );
  }
}
