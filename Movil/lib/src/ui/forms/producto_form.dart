import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/producto_model.dart';
import 'package:sistema_ventas_app_v1/src/services/categoria_service.dart';
import 'package:sistema_ventas_app_v1/src/services/producto_service.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/widgets_form/select_categoria.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sistema_ventas_app_v1/src/utility/imgBBenv.dart';

class ProductoForm extends StatefulWidget {
  final ProductoModel? producto;

  const ProductoForm({super.key, this.producto});

  @override
  State<ProductoForm> createState() => _ProductoFormState();
}

class _ProductoFormState extends State<ProductoForm> {
  final _formKey = GlobalKey<FormState>();
  final CategoriaService _categoriaService = CategoriaService();
  final ProductoService _productoService = ProductoService();
  //final UsuarioService _usuarioService = UsuarioService();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  int? _selectedRole;
  int? _estadoSeleccionado;
  String? foto;

  // Foto
  File? _selectedImage;
  String? _imageUrl;
  Imgbbenv imgbbenv = Imgbbenv();
Future<void> _checkPermissions() async {
  final status = await Permission.storage.request();

  if (status.isGranted) {
    _pickImage(); // Solo procede si el permiso fue concedido
  } else if (status.isPermanentlyDenied) {
    // Mostrar un diálogo antes de redirigir a configuración
    if (mounted) {
      _showPermissionDialog();
    }
  } else {
    print("❌ Permiso denegado");
  }
}

// Mostrar alerta antes de abrir la configuración de la app
void _showPermissionDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Permiso requerido"),
      content: Text("Para seleccionar una imagen, debes habilitar el acceso al almacenamiento."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            openAppSettings(); // Solo abre configuración si el usuario lo decide
          },
          child: Text("Ir a configuración"),
        ),
      ],
    ),
  );
}

  // Verificar permisos
  /*Future<void> _checkPermissions() async {
    if (await Permission.storage.request().isGranted) {
      _pickImage();
    } else if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    } else {
      print("❌ Permiso denegado");
    }
  }*/
  bool _isPickingImage = false;
/*
Future<void> _pickImage() async {
  if (_isPickingImage) return; // Evita abrir múltiples veces el selector
  _isPickingImage = true;

  try {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imagenSeleccionada = File(pickedFile.path);

      setState(() {
        _selectedImage = imagenSeleccionada; // Actualiza la imagen en la UI
      });

      print('📸 Imagen seleccionada: ${pickedFile.path}');

      // Subir imagen a ImgBB
      String? nuevaUrl = await imgbbenv.subirImagenAImgBB(imagenSeleccionada);

      if (nuevaUrl != null && nuevaUrl.isNotEmpty) {
        setState(() {
          _imageUrl = nuevaUrl; // Actualiza la URL después de subirla
        });
        print('✅ Imagen subida con éxito: $_imageUrl');
      } else {
        print('❌ Error al subir la imagen.');
      }
    } else {
      print('⚠️ No se seleccionó ninguna imagen.');
    }
  } catch (e) {
    print('❌ Error al seleccionar o subir imagen: $e');
  } finally {
    _isPickingImage = false; // Restablece el flag al finalizar
  }
}*/
Future<void> _pickImage() async {
  if (_isPickingImage) return;
  setState(() => _isPickingImage = true); // Asegura que el flag esté en el estado

  try {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imagenSeleccionada = File(pickedFile.path);

      // Primero, subir la imagen antes de actualizar el estado
      String? nuevaUrl = await imgbbenv.subirImagenAImgBB(imagenSeleccionada);

      if (nuevaUrl.isNotEmpty) {
        setState(() {
          _selectedImage = imagenSeleccionada; // Actualiza la imagen en la UI
          _imageUrl = nuevaUrl;
        });
        print('✅ Imagen subida con éxito: $_imageUrl');
      } else {
        print('❌ Error al subir la imagen.');
      }
    } else {
      print('⚠️ No se seleccionó ninguna imagen.');
    }
  } catch (e) {
    print('❌ Error al seleccionar o subir imagen: $e');
  } finally {
    if (mounted) {
      setState(() => _isPickingImage = false); // Evita llamadas a setState después de que el widget se destruya
    }
  }
}



  // Sele/*ccionar imagen

  // Lista de estados
  final List<Map<String, dynamic>> estados = [
    {'label': 'Activo', 'value': 1},
    {'label': 'No Activo', 'value': 0},
  ];

  @override
  void initState() {
    super.initState();
    _categoriaService.cargarCategoriasProducto(context);
    _productoService.cargarProductosConCategorias(context);

    // Si estamos editando un usuario, cargar los datos en los controladores
    if (widget.producto != null) {
      
      _nombreController.text = widget.producto!.nombre ?? '' ;
      _stockController.text = widget.producto!.stock.toString();
      _precioController.text = widget.producto!.precio.toString() ;
      _selectedRole = widget.producto!.idCategoria;
      _estadoSeleccionado = widget.producto!.esActivo;
      _imageUrl = widget.producto!.foto;
    }
  

  }
   // ✅ Método auxiliar para manejar las imágenes (de red o local)
  ImageProvider? _getImageProvider() {
    if (_imageUrl != null) {
      return NetworkImage(_imageUrl!);
    }
    if (_selectedImage != null) {
      return FileImage(File(_selectedImage!.path));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.producto != null ? 'Actualizar Usuario' : 'Agregar Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Foto
               GestureDetector(
              onTap:  () {
    print("📸 Se tocó el botón para seleccionar imagen");
    _checkPermissions();
    print("📌 Se ejecutó _checkPermissions");
  },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _getImageProvider(),
                child: _selectedImage == null && _imageUrl == null
                    ? const Icon(Icons.add_a_photo, size: 30)
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _imageUrl != null
                  ? '✅ Imagen subida con éxito'
                  : '❌ No hay imagen seleccionada',
              style: const TextStyle(color: Colors.grey),
            ),
              /*const Text(
                'Foto de Producto:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _checkPermissions,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _imageUrl != null
                      ? NetworkImage(_imageUrl!)
                      : _selectedImage != null
                          ? FileImage(File(_selectedImage!.path))
                          : null,
                  child: _selectedImage == null && _imageUrl == null
                      ? const Icon(Icons.add_a_photo, size: 30)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _imageUrl != null ? 'Imagen subida con éxito $_imageUrl' : 'No hay imagen seleccionada',
                style: const TextStyle(color: Colors.grey),
              ),*/
               //Nombre del Producto--------------------------------     
              const SizedBox(height: 32),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del Producto'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese un nombre completo del Producto'
                    : null,
              ),
              const SizedBox(height: 16),
              //Seleccion de Categoria---------------------------------------
              const Text('Selecciona la Categoria'),
              SelectCategoria(
                 value: _selectedRole,
                onChanged: (categoriaId) {
                  setState(() => _selectedRole = categoriaId);
                },
              ),
              const SizedBox(height: 16),
              //Seleccion del Stock del Producto------------------------------------ 
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese el Stock',
                  suffixIcon: Icon(Icons.store),
                  ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese un valor entero valido'
                    : null,
              ),
              const SizedBox(height: 16),
              //PRECIO -------------------------------Double
 TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _precioController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese el Precio',
                  suffixIcon: Icon(Icons.attach_money),
                  ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese un valor de precio valido'
                    : null,
              ),
              const SizedBox(height: 32),
              const Text('Estado del Producto:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                initialValue: _estadoSeleccionado,
                hint: const Text('Selecciona el estado'),
                items: estados.map((estado) {
                  return DropdownMenuItem<int>(
                    value: estado['value'],
                    child: Text(estado['label']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() => _estadoSeleccionado = newValue);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              const SizedBox(height: 32),
           ElevatedButton(
  onPressed: () async {
    if (_formKey.currentState?.validate() ?? false) {
      String? nuevaImagenUrl = _imageUrl;

      // Si hay una imagen seleccionada, la subimos
      if (_selectedImage != null) {
        nuevaImagenUrl = await imgbbenv.subirImagenAImgBB(_selectedImage!);
      }

      if (widget.producto != null) {
        // Actualizar Producto
        await _productoService.actualizarProducto(
          context: context,
          formKey: _formKey,
          idProducto: widget.producto?.idProducto ?? 0,
          nombre: _nombreController.text,
          stock: int.parse(_stockController.text),
          precio: _precioController.text,
          selectedCategoria: _selectedRole,
          estadoSeleccionado: _estadoSeleccionado,
          fotoBase64: nuevaImagenUrl, // Usa la nueva URL si hay imagen nueva
        );
      } else {
        // Crear Nuevo Producto
        await _productoService.guardarProducto(
          context: context,
          formKey: _formKey,
          nombre: _nombreController.text,
          stock: int.parse(_stockController.text),
          precio: _precioController.text,
          selectedCategoria: _selectedRole,
          estadoSeleccionado: _estadoSeleccionado,
          fotoBase64: nuevaImagenUrl, // Usa la nueva URL si hay imagen nueva
        );
      }
    }
  },
  child: Text(widget.producto != null ? 'Actualizar Producto' : 'Guardar Producto'),
),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _stockController.dispose();
    _precioController.dispose();
    _selectedRole = 0;
    _estadoSeleccionado = null;
    _selectedImage = null; // Limpia la imagen seleccionada
    _imageUrl = null; // Limpia la URL de la imagen subida
    super.dispose();
  }
}
