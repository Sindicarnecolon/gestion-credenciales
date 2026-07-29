# Guía de Compilación, Testeo y Vinculación Web - iOS

**Opciones de Compilación (Online y Físicas) + Despliegue en iPhone/iPad**

> 📌 **Nota Arquitectónica sobre iOS en Entornos Windows**  
> Dado que Apple requiere las herramientas propietarias de Xcode (que se ejecutan únicamente sobre el sistema operativo macOS) para firmar y compilar aplicaciones iOS, a continuación se presentan **4 opciones ordenadas de la MÁS SIMPLE (100% Cloud / Sin equipo Mac) a la MÁS COMPLEJA (Mac física/virtual)**.

---

## 1. Opciones de Compilación iOS (Ordenadas de más SIMPLE a más COMPLEJA)

| Opción | Método / Herramienta | Requiere Mac Física | Dificultad | Costo Aprox. |
| :--- | :--- | :---: | :---: | :--- |
| **Opción 1** | **Codemagic / GitHub Actions (Cloud)** | **NO** | ⭐ Muy Fácil | Gratis (Free Tier) |
| **Opción 2** | **Mac en la Nube (MacInCloud)** | **NO** | ⭐⭐ Fácil | ~$1 / hora |
| **Opción 3** | **macOS Virtualizado (VMware en Windows)** | **NO** | ⭐⭐⭐ Media | Gratis (DIY) |
| **Opción 4** | **Mac Física (MacBook / Mac Mini)** | **SÍ** | ⭐⭐⭐⭐ Compleja | Costo de Hardware |

---

### OPCIÓN 1: Servicios de Compilación en la Nube (Codemagic CI/CD) - [LA MÁS RECOMENDADA]

Esta es la opción más rápida, sencilla y profesional si trabaja en un entorno de desarrollo Windows, ya que **NO requiere comprar un equipo Mac ni instalar máquinas virtuales**.

1. **Paso 1**: Suba el repositorio de su código fuente a GitHub, GitLab o Bitbucket.
2. **Paso 2**: Cree una cuenta gratuita en [Codemagic.io](https://codemagic.io) (servicio de integración continua optimizado para Flutter).
3. **Paso 3**: Conecte su repositorio GitHub con Codemagic.
4. **Paso 4**: Seleccione el flujo **"Flutter App for iOS"**.
5. **Paso 5**: Haga clic en **"Start Build"**. Las máquinas Mac virtuales de Codemagic compilarán el proyecto automáticamente en la nube y le devolverán el archivo instalable de iOS (`.ipa`) o lo enviarán directamente a TestFlight de Apple.

---

### OPCIÓN 2: Alquiler de una Mac en la Nube (MacInCloud / MacStadium)

Ideal si necesita interactuar con la interfaz gráfica de Xcode desde Windows sin comprar un equipo Apple.

1. **Paso 1**: Contrate un servicio de Mac en la nube como [MacInCloud.com](https://www.macincloud.com) o MacStadium.
2. **Paso 2**: Conéctese a la Mac remota usando el **Escritorio Remoto de Windows** (RDP) o VNC.
3. **Paso 3**: Abra la terminal en la Mac remota, clone su proyecto de Flutter y ejecute `flutter build ios`.

---

### OPCIÓN 3: Entorno Virtualizado Local (macOS en VMware / VirtualBox)

Permite ejecutar macOS dentro de su computadora Windows actual.

- **Requisito**: Requiere una computadora Windows potente (procesador Intel/AMD con soporte de virtualización habilitado en BIOS y mínimo 16 GB de RAM).
1. **Paso 1**: Instale VMware Workstation o VirtualBox y configure una máquina virtual con una imagen de macOS (Sonoma / Sequoia).
2. **Paso 2**: Dentro del entorno macOS virtual, instale Xcode y el SDK de Flutter para compilar localmente.

---

### OPCIÓN 4: Compilación Nativa en una Mac Física (MacBook / Mac Mini)

Es el método tradicional si dispone de un equipo hardware de Apple.

1. **Paso 1**: Transfiera la carpeta del proyecto a la Mac.
2. **Paso 2**: Abra la consola de comandos en la Mac y navegue a la raíz del proyecto.
3. **Paso 3**: Ejecute `flutter pub get` para restaurar los paquetes.
4. **Paso 4**: Abra la carpeta de iOS en Xcode mediante el archivo: `ios/Runner.xcworkspace`.
5. **Paso 5**: Seleccione su equipo de desarrollo (Apple Developer Account) en **Signing & Capabilities**.
6. **Paso 6**: Ejecute el comando `flutter run -d ios` o compile la versión de producción con `flutter build ipa`.

---

## 2. Paso a Paso: Testeo en Simulador iOS y Dispositivo Físico (iPhone)

### 2.1 Ejecución en el Simulador de iOS

En el entorno macOS (físico, virtual o alquilado):

```bash
# Abrir el simulador de iPhone de Xcode
open -a Simulator

# Ejecutar la aplicación en el simulador de iOS
flutter run -d ios
```

### 2.2 Pruebas en Dispositivos Reales de Afiliados vía TestFlight

La forma estándar de probar la aplicación en iPhones de usuarios o afiliados antes de la publicación pública en App Store es mediante **TestFlight**:

1. Suba el archivo `.ipa` generado en Codemagic o Xcode a App Store Connect.
2. Inscriba las direcciones de correo electrónico de los testeadores o afiliados en la pestaña **TestFlight**.
3. Los usuarios recibirán una invitación por email para instalar la app directamente en su iPhone desde la app gratuita TestFlight de Apple.

---

## 3. Pasos Necesarios para Agregar las Páginas Web al Cascarón (Shell)

La integración web en iOS utiliza exactamente el mismo mecanismo centralizado que Android:

### Paso 1: Modificar `lib/config/app_config.dart`
Edite en su proyecto: [`lib/config/app_config.dart`](file:///c:/Users/Jonathan/Desktop/Pap%C3%A1%20academia/Antigravity%20Proyects/Gestion_de_credenciales_Andorid_IOS/lib/config/app_config.dart)

```dart
static const String webviewCredentialUrl = 'https://su-dominio.com/credencial-digital';
static const String webviewGroupUrl = 'https://su-dominio.com/grupo-familiar';
```

### Paso 2: Configuración de Transporte Seguro de Apple (ATS) en `ios/Runner/Info.plist`
iOS requiere obligatoriamente que los sitios web dentro de WebViews usen conexiones HTTPS seguras. Si durante las pruebas necesita conectar a una dirección HTTP local, agregue el siguiente bloque dentro de `ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

## 4. Protección de Capturas de Pantalla en iOS (Security Hook)

A diferencia de Android que utiliza `FLAG_SECURE`, en iOS la protección contra capturas de pantalla se gestiona a nivel nativo en Swift en `ios/Runner/AppDelegate.swift`:

```swift
// ios/Runner/AppDelegate.swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // El cascarón nativo de Flutter ya incluye la interfaz en SecurityService
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

---

## 5. Resumen y Recomendación Final para iOS

> 💡 **Recomendación Estratégica**:  
> Para el equipo de desarrollo trabajando desde entornos Windows, la recomendación óptima y de menor costo operativo es emplear la **Opción 1 (Codemagic CI/CD)**. Permite compilar tanto para Android como para iOS desde la misma consola sin cambiar de sistema operativo y genera los binarios `.apk` y `.ipa` listos para enviar a pruebas o tiendas.
