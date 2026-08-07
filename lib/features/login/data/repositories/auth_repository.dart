import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../config/app_config.dart';
import '../models/user_model.dart';

/// Repositorio de autenticación desacoplado.
///
/// Valida DNI + NOMBRE Y APELLIDO contra el Google Sheet a través
/// del Google Apps Script configurado en `AppConfig.loginApiUrl`.
class AuthRepository {
  /// Realiza el login con DNI y Nombre completo.
  Future<UserModel> login({
    required String dni,
    required String fullName,
  }) async {
    if (dni.trim().isEmpty || fullName.trim().isEmpty) {
      throw Exception('Debe ingresar el DNI y el Nombre y Apellido.');
    }

    // ── Modo REAL: Google Apps Script está configurado ────────────────────
    if (AppConfig.loginApiUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(AppConfig.loginApiUrl).replace(
          queryParameters: {
            'dni': dni.trim(),
            'nombre': fullName.trim(),
          },
        );

        final response = await http.get(uri).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception(
            'No se pudo conectar con el servidor. Verifique su conexión.',
          ),
        );

        if (response.statusCode != 200) {
          throw Exception('Error del servidor (${response.statusCode}).');
        }

        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          // Parsear la fecha de vencimiento desde la respuesta
          DateTime? expDate;
          final vtoStr = data['vto'] as String?;
          if (vtoStr != null && vtoStr.isNotEmpty) {
            expDate = _parseDate(vtoStr);
          }

          String formattedVto = vtoStr ?? '';
          if (expDate != null) {
            final day = expDate.day.toString().padLeft(2, '0');
            final month = expDate.month.toString().padLeft(2, '0');
            final year = expDate.year.toString();
            formattedVto = '$day/$month/$year';
          }

          return UserModel(
            dni: dni.trim(),
            fullName: data['nombre'] as String? ?? fullName.trim(),
            affiliateNumber: data['nroAfiliado'] as String? ?? '',
            establishment: data['establecimiento'] as String? ?? '',
            expirationDate: expDate,
            vtoRaw: formattedVto,
          );
        } else {
          throw Exception(
            data['message'] as String? ?? 'DNI o Nombre y Apellido incorrectos.',
          );
        }
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Error de conexión: ${e.toString()}');
      }
    }

    // ── Modo SIMULACIÓN: Sin URL configurada (desarrollo local) ───────────
    debugPrint('[AuthRepository] Modo simulación — sin URL de API configurada.');
    await Future.delayed(const Duration(milliseconds: 600));

    return UserModel(
      dni: dni.trim(),
      fullName: fullName.trim(),
      affiliateNumber: '000001-00',
      establishment: 'Establecimiento de Prueba',
      expirationDate: DateTime(2026, 12, 31),
      vtoRaw: '31/12/2026',
    );
  }

  /// Convierte strings de fecha en formato "DD/MM/YYYY" o "YYYY-MM-DD" a DateTime.
  DateTime? _parseDate(String raw) {
    try {
      final cleaned = raw.replaceAll(RegExp(r'\s*\(.*?\)\s*'), '').trim();
      // Formato DD/MM/YYYY (Google Sheets)
      if (cleaned.contains('/')) {
        final parts = cleaned.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      }
      return DateTime.tryParse(cleaned);
    } catch (_) {
      return null;
    }
  }
}
