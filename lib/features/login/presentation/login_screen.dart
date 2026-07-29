import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/app_config.dart';
import '../providers/auth_provider.dart';

/// Pantalla de Login de Afiliados.
///
/// Diseño inspirado en la referencia visual proporcionada:
/// - Fondo oscuro azul marino
/// - Ola / arco azul superior con el logo del sindicato centrado
/// - Texto "Bienvenido" en blanco
/// - Campos pill-shaped blancos con íconos
/// - Botón dorado / amarillo redondeado
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dniController = TextEditingController();
  final _nameController = TextEditingController();

  // Colores extraídos de la referencia visual (Imagen 1)
  static const Color _bgDark = Color(0xFF0D1B2A);       // Fondo azul marino oscuro
  static const Color _wavBlue = Color(0xFF1565C0);       // Azul del arco/ola superior
  static const Color _goldenBtn = Color(0xFFFFC107);     // Amarillo/dorado del botón
  static const Color _fieldBg = Color(0xFFF5F5F5);       // Fondo casi blanco de los campos
  static const Color _hintColor = Color(0xFF9E9E9E);     // Color del hint text
  static const Color _iconColor = Color(0xFF616161);     // Color de los íconos en campos

  @override
  void dispose() {
    _dniController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      final success = await ref.read(authProvider.notifier).login(
            _dniController.text,
            _nameController.text,
          );
      if (!success && mounted) {
        final error = ref.read(authProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Error de autenticación.'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _bgDark,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Sección superior: Ola azul + Logo ───────────────────────
              _WaveLogoSection(screenWidth: size.width),

              // ─── Sección inferior: Formulario ─────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 32.0, 28.0, 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Texto "Bienvenido"
                    const Text(
                      'Bienvenido',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Campo DNI
                    _buildPillField(
                      controller: _dniController,
                      hint: 'Ingrese su DNI',
                      icon: Icons.login_rounded,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingrese su número de DNI';
                        }
                        if (value.trim().length < 6) {
                          return 'Ingrese un DNI válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo Nombre y Apellido
                    _buildPillField(
                      controller: _nameController,
                      hint: 'Nombre y Apellido',
                      icon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingrese su Nombre y Apellido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Botón Aceptar — dorado, pill-shaped
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _goldenBtn,
                          foregroundColor: Colors.black87,
                          disabledBackgroundColor: _goldenBtn.withAlpha(120),
                          elevation: 4,
                          shadowColor: _goldenBtn.withAlpha(100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        child: authState.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.black54,
                                ),
                              )
                            : const Text('Aceptar'),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Pie con soporte
                    Text(
                      '¿Necesita ayuda?\n${AppConfig.supportEmail}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withAlpha(100),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye un campo de texto tipo píldora (pill-shaped)
  Widget _buildPillField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required TextInputAction textInputAction,
    required String? Function(String?) validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(
        color: Color(0xFF212121),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: _hintColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, color: _iconColor, size: 22),
        filled: true,
        fillColor: _fieldBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: _wavBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        errorStyle: const TextStyle(color: Colors.orange, fontSize: 12),
      ),
      validator: validator,
    );
  }
}

/// Widget que pinta el área superior con el arco/ola azul y el logo centrado.
class _WaveLogoSection extends StatelessWidget {
  final double screenWidth;

  const _WaveLogoSection({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Ola / arco azul pintada con CustomPaint
          CustomPaint(
            size: Size(screenWidth, 300),
            painter: _WavePainter(),
          ),

          // Logo centrado sobre el arco azul
          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Sombra para destacar el logo sobre el arco
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(80),
                      blurRadius: 24,
                      spreadRadius: 4,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo_sindicato.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter que dibuja el arco/ola azul tipo curva de la Imagen 1.
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1565C0)
      ..style = PaintingStyle.fill;

    final path = Path();
    // Rectángulo superior con curva convexa en la parte inferior
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.60);
    // Curva cóncava hacia arriba (similar al arco redondeado de la imagen)
    path.quadraticBezierTo(
      size.width / 2, // punto de control X (centro)
      size.height * 1.05, // punto de control Y (ligeramente más abajo del límite)
      0,
      size.height * 0.60,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
