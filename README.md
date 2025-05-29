# 🧘 MindCalm: Tu Compañero de Bienestar Mental

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

