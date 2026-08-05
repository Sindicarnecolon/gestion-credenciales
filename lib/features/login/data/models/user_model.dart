/// Modelo de datos del usuario afiliado.
/// Refleja las columnas del Google Sheet:
/// NOMBRE Y APELLIDO | DNI | NRO AFILIADO | ESTABLECIMIENTO | Vto
class UserModel {
  final String dni;
  final String fullName;
  final String affiliateNumber;
  final String establishment;
  final DateTime? expirationDate;
  /// Valor original del campo Vto tal como viene del Google Sheet (ej: "12/2026" o "31/12/2026").
  /// Se usa para mostrar en el HTML sin depender del parsing de fecha.
  final String vtoRaw;

  const UserModel({
    required this.dni,
    required this.fullName,
    this.affiliateNumber = '',
    this.establishment = '',
    this.expirationDate,
    this.vtoRaw = '',
  });

  /// Retorna true si la credencial está vencida
  bool get isExpired {
    if (expirationDate == null) return false;
    return DateTime.now().isAfter(expirationDate!);
  }

  Map<String, dynamic> toJson() => {
        'dni': dni,
        'fullName': fullName,
        'affiliateNumber': affiliateNumber,
        'establishment': establishment,
        'expirationDate': expirationDate?.toIso8601String(),
        'vtoRaw': vtoRaw,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        dni: json['dni'] as String? ?? '',
        fullName: json['fullName'] as String? ?? '',
        affiliateNumber: json['affiliateNumber'] as String? ?? '',
        establishment: json['establishment'] as String? ?? '',
        expirationDate: json['expirationDate'] != null
            ? DateTime.tryParse(json['expirationDate'] as String)
            : null,
        vtoRaw: json['vtoRaw'] as String? ?? '',
      );
}
