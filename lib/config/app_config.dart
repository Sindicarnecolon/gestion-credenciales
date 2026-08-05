/// Configuración centralizada de la aplicación.
///
/// Todas las URLs, textos, datos de empresa y configuraciones globales
/// deben definirse únicamente en este archivo conforme a las directrices
/// del proyecto (Guia_de_desarrollo.md).
class AppConfig {
  AppConfig._(); // Clase utilitaria con constructor privado

  // ------------ Nombre e Identidad ------------
  static const String appName = 'Credencial Digital';
  static const String companyName = 'Mi Obra Social';
  static const String appVersion = '1.0.0';

  // ------------ URLs de WebViews ------------
  /// URL de la WebView de la Credencial. Si está vacía, se mostrará el mensaje correspondiente.
  static const String webviewCredentialUrl = 'https://sindicarnecolon.github.io/gestion-credenciales/';

  // ------------ APIs (Preparado para backend futuro) ------------
  /// Endpoint de autenticación (Google Apps Script / Sheets backend)
  static const String loginApiUrl =
      'https://script.google.com/macros/s/AKfycbzwlmFPZRNYVtnGzGegkwC6ozoyDu9OEc0kauSa-kCGUMuZieU9vN8k86l9NemhJsCZ/exec';

  /// Endpoint de novedades
  static const String newsApiUrl = '';

  // ------------ Marquesina ------------
  /// Texto deslizante continuo que se muestra sobre la WebView de la credencial
  static const String marqueeText =
      '📢 Recuerde presentar su DNI al momento de utilizar la credencial digital. ¡Mantenga sus datos actualizados!';

  // ------------ Datos de Contacto y Soporte ------------
  static const String supportEmail = 'soporte@obrasocial.com.ar';
  static const String supportPhone = '0800-555-1234';
  static const String supportWhatsapp = '+5491112345678';

  // ------------ Mensajes del sistema ------------
  static const String msgCredentialNotConfigured =
      'La credencial aún no fue configurada.';
  static const String msgCredentialExpired =
      'Su credencial se encuentra vencida.';
  static const String btnContactAdmin = 'Contactar Administración';
}
