# 🛒 Sistema de Ventas

Este es un sistema de ventas desarrollado con **Flutter** utilizando la arquitectura **Clean Architecture** y gestionando el estado con **BLoC**. La aplicación consume un **API REST** construido en **ASP.NET Core 8** para la gestión de usuarios, productos, ventas y autenticación mediante **JWT**.

## 📱 Características Principales

- Autenticación segura con **JWT**.
- Gestión de usuarios, productos y ventas.
- Manejo de estado con **flutter_bloc** y **RxDart**.
- Navegación modular con **go_router**.
- Almacenamiento seguro del token con **flutter_secure_storage**.
- Optimizado para la última versión de **Flutter**.

## 📊 Tecnologías Utilizadas

- **Flutter** (última versión)
- **ASP.NET Core 8** (API REST)
- **BLoC + RxDart** (Gestión de estado reactiva)
- **go_router** (Navegación declarativa)
- **flutter_secure_storage** (Almacenamiento seguro del token)
- **http** (Consumo del API REST)

## 📚 ¿Qué es Clean Architecture y BLoC?

- **Clean Architecture**: Es un enfoque que separa la lógica de negocio, la lógica de presentación y los detalles de infraestructura. Facilita la escalabilidad, la mantenibilidad y las pruebas unitarias. En este proyecto se divide en capas como `blocs`, `models`, `resources`, `services`, `ui` y `utility`.

- **BLoC (Business Logic Component)**: Es un patrón de gestión de estado que organiza la lógica de negocio en componentes independientes. Usa **Streams** y **RxDart** para manejar la reactividad y asegurar un flujo claro de los eventos y estados.

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  rxdart: ^0.27.7
  go_router: ^14.1.1
  flutter_secure_storage: ^9.0.0
  http: ^1.2.0
```

## 📂 Arquitectura del Proyecto

```bash
├── lib/
│   ├── blocs/           # Gestión de estado con BLoC
│   ├── models/          # Modelos de datos
│   ├── resources/       # Proveedores de API y repositorios
│   ├── services/        # Lógica de negocio
│   ├── ui/              # Vistas y widgets
│   ├── utility/         # Utilidades (configuración, env.dart)
│   └── main.dart        # Punto de entrada de la aplicación
```

## 🚀 Configuración del Proyecto

1. Clonar el repositorio:

```bash
git clone https://gitlab.com/tu-usuario/sistema-ventas.git
cd sistema-ventas
```

2. Instalar las dependencias:

```bash
flutter pub get
```

3. Configurar el entorno:

Crear un archivo `.env` en la carpeta `lib/utility/` con el siguiente contenido:

```env
API_URL=https://tu-api.com
```

4. Ejecutar la aplicación:

```bash
flutter run
```

## 📌 Notas

- Asegúrate de tener el **API REST** de **ASP.NET Core 8** ejecutándose y accesible desde la aplicación Flutter.
- Esta aplicación está optimizada para la **última versión de Flutter**.

## 📧 Contacto

Si tienes preguntas o sugerencias, no dudes en contactarme.
