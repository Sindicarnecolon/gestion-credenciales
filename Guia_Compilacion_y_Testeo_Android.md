# Guía de Compilación, Testeo y Vinculación Web - Android

**Aplicación de Credencial Digital de Afiliados (Flutter Native Shell)**

> 📌 **Estado del Cascarón Nativo (Shell)**  
> El cascarón nativo Flutter ya se encuentra 100% construido y verificado en el proyecto (`dart analyze` limpio, `flutter test` exitoso). Esta guía contiene las instrucciones paso a paso para ejecutar la app en emuladores Android, integrar las páginas web finales y generar los archivos instalables APK/AAB.

---

## 1. Requisitos Previos del Entorno

Antes de comenzar con la compilación en Windows, asegúrese de contar con los siguientes elementos instalados y verificados:

- **Flutter SDK 3.44.7+**: Instalado en `C:\src\flutter` y verificado en la variable de entorno `PATH`.
- **Dart SDK 3.12.2+**: Incluido automáticamente con Flutter.
- **Android SDK**: Instalado con SDK Platform 36.1.0 y Build Tools.
- **Java Development Kit (JDK)**: JDK 21 incluido en Android Studio (configurado por defecto).
- **Verificación**: Ejecute en la consola `flutter doctor -v` para confirmar que todos los ítems estén en verde `[√]`.

---

## 2. Paso a Paso: Configuración y Ejecución en Emulador Android (AVD)

Existen dos alternativas para crear y ejecutar un emulador Android (Android Virtual Device - AVD):

### Opción A: Desde la Interfaz Gráfica de Android Studio (Recomendado)

1. Abre **Android Studio** desde el menú de inicio de Windows.
2. En la pantalla de bienvenida o menú superior, selecciona **Device Manager** (Gestor de dispositivos virtuales).
3. Haz clic en **Create Device** (Crear dispositivo).
4. Selecciona un modelo recomendado de teléfono, por ejemplo **Pixel 8** o **Pixel 7**, y presiona **Next**.
5. Selecciona la versión del sistema (por ejemplo **API 34** o **API 36**) y haz clic en **Download** si aún no está instalada.
6. Haz clic en **Finish**.
7. Inicia el emulador haciendo clic en el icono de reproducción ▶ (**Play**) junto al dispositivo creado.

### Opción B: Desde la Consola de Comandos (PowerShell / Antigravity CLI)

```powershell
# Listar los emuladores disponibles
flutter emulators

# Crear un emulador si no existe ningún AVD
flutter emulators --create --name pixel_emulator

# Iniciar el emulador por nombre
flutter emulators --launch pixel_emulator
```

---

## 3. Paso a Paso: Compilación y Ejecución de la App

### 3.1 Modo Desarrollo (Pruebas con Hot Reload)

Con el emulador Android encendido y visible en pantalla, ejecute el siguiente comando en la raíz del proyecto:

```powershell
flutter run -d android
```

Durante la ejecución en este modo:
- Presione `r` en la consola para realizar **Hot Reload** (recarga instantánea del código).
- Presione `R` para realizar **Hot Restart** (reiniciar el estado completo de la app).
- Presione `q` para detener la ejecución.

### 3.2 Compilación del APK de Pruebas (Debug APK)

Para generar un archivo instalable sin necesidad de tener el emulador conectado a la consola de desarrollo:

```powershell
flutter build apk --debug
```

- **Ubicación del APK generado**: `build\app\outputs\flutter-apk\app-debug.apk`

Puede instalar este APK directamente en el emulador arrastrando el archivo sobre la ventana del emulador o ejecutando:
```powershell
adb install build\app\outputs\flutter-apk\app-debug.apk
```

### 3.3 Compilación del APK de Producción (Release APK)

Para generar el instalable final optimizado para distribución directa a los afiliados:

```powershell
flutter build apk --release
```

- **Ubicación Release**: `build\app\outputs\flutter-apk\app-release.apk`

### 3.4 Compilación de App Bundle para Google Play Store (.aab)

Si desea publicar la aplicación en la tienda oficial Google Play Store, debe generar un archivo Android App Bundle (.aab):

```powershell
flutter build appbundle --release
```

- **Ubicación AAB**: `build\app\outputs\bundle\release\app-release.aab`

---

## 4. Pasos Necesarios para Agregar las Páginas Web al Cascarón (Shell)

Toda la infraestructura de la aplicación nativa se encuentra conectada al archivo de configuración centralizado. Para vincular la aplicación web real a los cascarones nativos (WebView), siga estos pasos exactamente:

### Paso 1: Abrir el archivo de configuración centralizado
Abra en su editor el archivo ubicado en:
[`lib/config/app_config.dart`](file:///c:/Users/Jonathan/Desktop/Pap%C3%A1%20academia/Antigravity%20Proyects/Gestion_de_credenciales_Andorid_IOS/lib/config/app_config.dart)

### Paso 2: Reemplazar las constantes de URLs
Localice las variables de URL y coloque la dirección HTTPS de producción o pruebas donde se encuentra alojada la web app de credenciales y grupo familiar:

```dart
class AppConfig {
  AppConfig._();

  // URLs de las WebViews reales
  static const String webviewCredentialUrl = 'https://su-dominio.com/credencial-digital';
  static const String webviewGroupUrl = 'https://su-dominio.com/grupo-familiar';

  // Endpoints de API futuros (Google Apps Script / Sheets)
  static const String loginApiUrl = 'https://script.google.com/macros/s/SU_SCRIPT_ID/exec';
  static const String newsApiUrl = 'https://api.su-dominio.com/novedades';

  // Marquesina superior
  static const String marqueeText = '📢 Presente su DNI junto a la credencial digital.';
}
```

### Paso 3: Guardar el archivo y probar en el emulador
Guarde el archivo `app_config.dart`. La aplicación detectará automáticamente las URLs no vacías e inicializará la WebView nativa con transporte seguro de inmediato.

> 💡 **Permisos de Red**: El permiso `android.permission.INTERNET` ya se encuentra configurado en `android/app/src/main/AndroidManifest.xml`.

---

## 5. Resolución de Problemas Frecuentes (Troubleshooting)

- **Error de Licencias de Android**: Ejecute `flutter doctor --android-licenses` en la consola y presione `y` para aceptar todas las licencias del SDK.
- **La WebView no carga la página web**: Asegúrese de que la URL empiece obligatoriamente por `https://`. Si usa HTTP inseguro durante pruebas locales, Android requiere configurar `android:usesCleartextTraffic="true"` en `AndroidManifest.xml`.
- **Error al compilar Gradle**: Ejecute `flutter clean`, luego `flutter pub get` y vuelva a compilar.
