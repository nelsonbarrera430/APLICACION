### 🧘 MindCalm: Tu Compañero de Bienestar Mental

MindCalm es una aplicación móvil desarrollada con Flutter cuyo objetivo es ofrecer un soporte integral para la gestión de la ansiedad y el estrés. La aplicación permite a los usuarios monitorear su estado emocional, interactuar con un chatbot inteligente, realizar ejercicios de respiración guiados y conectarse con una comunidad de apoyo.

---

## 🚀 Requisitos del Sistema

Para poder ejecutar y desarrollar esta aplicación, asegúrate de tener instaladas las siguientes herramientas y versiones, basadas en el entorno de desarrollo probado:

### Flutter SDK

* **Versión:** `3.29.3` (canal `stable`)

### Dart SDK

* **Versión:** `3.7.2`
* **DevTools:** `2.42.3`
* **Nota:** Dart SDK viene incluido con Flutter, así que no necesitas instalarlo por separado.

### Java Development Kit (JDK)

* **Versión:** `Java 17.0.15` (OpenJDK, build `17.0.15+9-LTS-241`)
* **Comprobar Instalación:** `java -version`

### Android Development

* **Android Studio:** Se recomienda una versión reciente para acceder a herramientas de SDK y emuladores.
* **Android SDK:** Versión `35.0.1`
    * `Platform android-35`
    * `build-tools 35.0.1`
* **Android NDK:** `27.0.12077973` (según tu configuración `ndkVersion` en Gradle).
* **Gradle:** El proyecto utiliza `gradle-8.10.2-all.zip` (indicado en `gradle-wrapper.properties`) con `Android Gradle Plugin` versión `8.7.0`.
* **Nota:** Si encuentras errores de Gradle al ejecutar en un dispositivo físico, verifica la configuración de tu `minSdk` y `targetSdk` en `android/app/build.gradle`.
---
✨ Características Principales
Cuestionarios de Bienestar Diarios: Preguntas generadas por Inteligencia Artificial (IA) para monitorear y evaluar el estado emocional del usuario.

Chatbot Interactivo: Un compañero de conversación inteligente que ofrece apoyo, consejos y herramientas de afrontamiento en tiempo real.

Ejercicios de Respiración Guiados: Herramientas interactivas para ayudar a la relajación, reducir el estrés y controlar la ansiedad a través de patrones de respiración.

Sección de Comunidad: Un espacio para que los usuarios se conecten, compartan experiencias, publiquen contenido y comenten en publicaciones de otros (con funciones de "me gusta").

Monitoreo y Visualización de Progreso: Almacenamiento de datos históricos de bienestar en Appwrite y representación visual de tendencias a través de gráficos interactivos.

Contactos de Emergencia: Funcionalidad para gestionar y acceder rápidamente a contactos importantes en situaciones de crisis.

---
clonacion:
---
git clone https://github.com/nelsonbarrera430/APLICACION.git ///
cd APLICACION

depues:
flutter pub get
flutter run

datos a tener en cuenta:
---
al subirce a github se genera un error en la api de la IA entonces cambiar el APIKEY por este:
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

apartado donde se debe cambiar el APIKEY (services):
archvios: 
chat_ia Y preguntas_ia

Este proyecto utiliza las siguientes dependencias clave para su funcionamiento, según se definen en pubspec.yaml:

* appwrite: ^15.0.2 – Cliente SDK oficial para interactuar con tu backend de Appwrite.
* cupertino_icons: ^1.0.8 – Proporciona un conjunto de íconos con el estilo de Apple (iOS).
* *flutter_echarts: ^2.0.5 – Integra gráficos dinámicos y personalizables en tu aplicación.
* *intl: ^0.19.0 – Ofrece funcionalidades de internacionalización y formato de datos (fechas, números).
* *image_picker: ^1.0.7 – Permite seleccionar o capturar imágenes desde la galería o cámara.
* *cached_network_image: ^3.2.3 – Carga imágenes de red de forma eficiente y las almacena en caché.
* *extended_image: ^10.0.1 – Un widget de imagen avanzado con funcionalidades como zoom y rotación.
* *visibility_detector: ^0.4.0+2 – Permite detectar cuándo un widget es visible en pantalla.
* *flutter_glow: ^0.2.0 – Proporciona efectos visuales de "brillo" para widgets.
* *shared_preferences: ^2.0.15 – Permite almacenar datos simples.
* *flutter_web_auth_2: ^4.1.0 (desde dependency_overrides) – Gestiona la autenticación Auth y otros flujos de autenticación basados en web.

## ⚙️ Configuración del Backend (Appwrite)

Esta aplicación utiliza Appwrite como su plataforma backend para gestionar usuarios, datos de la aplicación y la comunidad.

### 1. Endpoint y Credenciales

Appwrite se encuentra en `lib/appwirte/constants.dart`:

```dart
class AppwriteConstants {
  static const String endpoint = '[https://fra.cloud.appwrite.io/v1](https://fra.cloud.appwrite.io/v1)';
  static const String projectId = '68195b09002d984cf4f7';
  static const String databaseId = '68195b2600264df5ab1d';
  static const String usersCollectionId = '68195b2c0029aeb4c22f';
  static const String graphicsCollectionId = '6819a041000c716f84b9';
  static const String postsCollectionId = '681aba19002b57c6fbac';
  static const String commentsCollectionId = '681abb110035573bad4a';
  static const String likesCollectionId = '681ac5cd001ab4e4c893';
  static const String storageBucketId ='681d652600364d1b43d0';
  static const String emergencyCollectionId = '68294a54000b287db588';
}

