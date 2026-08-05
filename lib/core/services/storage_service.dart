import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servicio de almacenamiento seguro para persistir la sesión del usuario.
class StorageService {
  final FlutterSecureStorage _storage;

  StorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _keyDni = 'user_dni';
  static const String _keyFullName = 'user_full_name';
  static const String _keyAffiliateNumber = 'user_affiliate_number';
  static const String _keyEstablishment = 'user_establishment';
  static const String _keyExpirationDate = 'user_expiration_date';
  static const String _keyVtoRaw = 'user_vto_raw';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Guarda todos los datos de sesión del usuario
  Future<void> saveUserSession({
    required String dni,
    required String fullName,
    String affiliateNumber = '',
    String establishment = '',
    String expirationDate = '',
    String vtoRaw = '',
  }) async {
    await _storage.write(key: _keyDni, value: dni);
    await _storage.write(key: _keyFullName, value: fullName);
    await _storage.write(key: _keyAffiliateNumber, value: affiliateNumber);
    await _storage.write(key: _keyEstablishment, value: establishment);
    await _storage.write(key: _keyExpirationDate, value: expirationDate);
    await _storage.write(key: _keyVtoRaw, value: vtoRaw);
    await _storage.write(key: _keyIsLoggedIn, value: 'true');
  }

  Future<String?> getDni() async => _storage.read(key: _keyDni);
  Future<String?> getFullName() async => _storage.read(key: _keyFullName);
  Future<String?> getAffiliateNumber() async => _storage.read(key: _keyAffiliateNumber);
  Future<String?> getEstablishment() async => _storage.read(key: _keyEstablishment);
  Future<String?> getExpirationDate() async => _storage.read(key: _keyExpirationDate);
  Future<String?> getVtoRaw() async => _storage.read(key: _keyVtoRaw);

  /// Comprueba si hay una sesión activa
  Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: _keyIsLoggedIn);
    return value == 'true';
  }

  /// Elimina los datos de sesión (Cerrar sesión)
  Future<void> clearSession() async {
    await _storage.deleteAll();
  }
}
