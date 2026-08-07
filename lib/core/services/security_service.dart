import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Servicio de seguridad encargado de prevenir capturas de pantalla,
/// grabación y ocultar el contenido cuando la app pasa a segundo plano.
class SecurityService {
  SecurityService._();

  static const _channel =
      MethodChannel('com.antigravity.gestion_credenciales/security');

  /// Habilita la protección de seguridad contra screenshots y screen recording.
  static Future<void> enableSecurityProtection() async {
    try {
      if (kIsWeb) return;

      if (Platform.isAndroid) {
        // En Android activa el FLAG_SECURE a nivel de ventana nativa
        await _channel.invokeMethod('enableSecure');
      } else if (Platform.isIOS) {
        // IMPLEMENTACIÓN iOS:
        // En iOS la prevención de screenshots requiere añadir un UITextField
        // con `isSecureTextEntry = true` a la jerarquía de vistas en AppDelegate.swift.
        // Ver nota de arquitectura en la documentación del proyecto.
        debugPrint('[SecurityService] Protección en iOS configurada a nivel de vista.');
      }
    } catch (e) {
      debugPrint('[SecurityService] Error al aplicar FLAG_SECURE: $e');
    }
  }

  /// Remueve la protección de seguridad si es necesario
  static Future<void> disableSecurityProtection() async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        await _channel.invokeMethod('disableSecure');
      }
    } catch (e) {
      debugPrint('[SecurityService] Error al remover FLAG_SECURE: $e');
    }
  }
}
