/// Servicio independiente para la verificación de vencimiento de credenciales.
///
/// Toda la lógica interna puede reemplazarse en el futuro por una consulta a API
/// sin modificar la arquitectura de la aplicación ni las vistas.
class ExpirationService {
  /// Comprueba si la credencial del afiliado está vencida.
  ///
  /// Retorna `true` si está vencida, `false` si está vigente.
  Future<bool> isCredentialExpired({
    required String dni,
    required String affiliateNumber,
  }) async {
    // Simulación de latencia de red si fuera una API
    await Future.delayed(const Duration(milliseconds: 200));

    // LÓGICA LOCAL TEMPORAL:
    // La credencial vence a fin del año actual o una fecha de ejemplo.
    // Cambiar `mockExpirationDate` o poner una fecha pasada para probar el estado vencido.
    final DateTime mockExpirationDate = DateTime(2026, 12, 31, 23, 59, 59);
    final DateTime now = DateTime.now();

    return now.isAfter(mockExpirationDate);
  }
}
