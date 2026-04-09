import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/usuario_model.dart';
import 'package:sistema_ventas_app_v1/src/services/rol_service.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/widgets_form/select_rol.dart';
import 'package:sistema_ventas_app_v1/src/services/usuario_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sistema_ventas_app_v1/src/utility/imgBBenv.dart';

class UsuarioForm extends StatefulWidget {
  final UsuarioModel? usuario;

  const UsuarioForm({super.key, this.usuario});

  @override
  State<UsuarioForm> createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  final RolService _rolService = RolService();
  final UsuarioService _usuarioService = UsuarioService();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();

  int? _selectedRole;
  int? _estadoSeleccionado;
  String? foto;

  // Foto
  File? _selectedImage;
  String? _imageUrl;
  Imgbbenv imgbbenv = Imgbbenv();

  // Verificar permisos
  Future<void> _checkPermissions() async {
    if (await Permission.storage.request().isGranted) {
      _pickImage();
    } else if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    } else {
       
      print("❌ Permiso denegado");
    }
  }

  bool _isPickingImage = false;

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

        if (nuevaUrl.isNotEmpty) {
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
  }

  // Lista de estados
  final List<Map<String, dynamic>> estados = [
    {'label': 'Activo', 'value': 1},
    {'label': 'No Activo', 'value': 0},
  ];

  @override
  void initState() {
    super.initState();
    _rolService.cargarRoles(context);
    _usuarioService.CargarUsuarios(context);

    // Si estamos editando un usuario, cargar los datos en los controladores
    if (widget.usuario != null) {
      _nombreController.text = widget.usuario!.nombreCompleto;
      _correoController.text = widget.usuario!.correo;
      _claveController.text = widget.usuario!.clave;
      _selectedRole = widget.usuario!.idRol;
      _estadoSeleccionado = widget.usuario!.esActivo;
      _imageUrl = widget.usuario!.foto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.usuario != null ? 'Actualizar Usuario' : 'Agregar Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Foto
              const Text(
                'Foto de Perfil:',
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
              ),

              const SizedBox(height: 32),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre Completo'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese un nombre completo'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese un correo válido'
                    : null,
              ),
              const SizedBox(height: 16),
              const Text('Selecciona un Rol'),
              SelectRol(
                value: _selectedRole,
                onChanged: (rolId) {
                  setState(() => _selectedRole = rolId);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _claveController,
                decoration: const InputDecoration(labelText: 'Clave'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese una clave'
                    : null,
              ),
              const SizedBox(height: 32),
              const Text('Estado del Usuario:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    if (widget.usuario != null) {
                      // Actualizar Usuario
                      await _usuarioService.actualizarUsuario(
                        context: context,
                        formKey: _formKey,
                        idUsuario: widget.usuario?.idUsuario ?? 0,
                        nombre: _nombreController.text,
                        correo: _correoController.text,
                        clave: _claveController.text,
                        selectedRole: _selectedRole,
                        estadoSeleccionado: _estadoSeleccionado,
                        fotoBase64: _imageUrl,
                      );
                    } else {
                      // Crear Nuevo Usuario
                      await _usuarioService.guardarUsuario(
                        context: context,
                        formKey: _formKey,
                        nombre: _nombreController.text,
                        correo: _correoController.text,
                        clave: _claveController.text,
                        selectedRole: _selectedRole,
                        estadoSeleccionado: _estadoSeleccionado,
                        fotoBase64: _imageUrl,
                      );
                    }
                  }
                },
                child: Text(widget.usuario != null ? 'Actualizar Usuario' : 'Guardar Usuario'),
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
    _correoController.dispose();
    _claveController.dispose();
    _selectedRole = 0;
    _estadoSeleccionado = null;
    _selectedImage = null; // Limpia la imagen seleccionada
    _imageUrl = null; // Limpia la URL de la imagen subida
    super.dispose();
  }
}
