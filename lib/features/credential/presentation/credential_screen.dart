import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_config.dart';
import '../../../core/services/expiration_service.dart';
import '../../../core/services/security_service.dart';
import '../../../core/widgets/custom_marquee.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../login/providers/auth_provider.dart';

/// Pantalla de Credencial Digital.
///
/// Integra:
/// - Bloqueo de capturas/screenshots vía SecurityService
/// - Verificación de vencimiento vía ExpirationService
/// - Marquesina continua nativa superior
/// - WebView parametrizada desde `AppConfig.webviewCredentialUrl`
class CredentialScreen extends ConsumerStatefulWidget {
  const CredentialScreen({super.key});

  @override
  ConsumerState<CredentialScreen> createState() => _CredentialScreenState();
}

class _CredentialScreenState extends ConsumerState<CredentialScreen> {
  final ExpirationService _expirationService = ExpirationService();
  WebViewController? _webViewController;
  bool _isLoading = true;
  bool _isExpired = false;
  bool _isCheckingExpiration = true;

  @override
  void initState() {
    super.initState();
    // 1. Activar protección de seguridad (FLAG_SECURE)
    SecurityService.enableSecurityProtection();

    // 2. Verificar vencimiento de credencial
    _checkExpiration();
  }

  Future<void> _checkExpiration() async {
    final user = ref.read(authProvider).user;
    if (user != null) {
      final expired = await _expirationService.isCredentialExpired(
        dni: user.dni,
        affiliateNumber: user.affiliateNumber,
      );
      if (mounted) {
        setState(() {
          _isExpired = expired;
          _isCheckingExpiration = false;
        });

        if (!expired && AppConfig.webviewCredentialUrl.isNotEmpty) {
          _initWebView();
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isCheckingExpiration = false;
        });
      }
    }
  }

  void _initWebView() {
    final user = ref.read(authProvider).user;
    String url = AppConfig.webviewCredentialUrl;
    if (user != null && url.isNotEmpty) {
      final uri = Uri.parse(url).replace(
        queryParameters: {
          'dni': user.dni,
          'nombre': user.fullName,
          'nro': user.affiliateNumber,
          'estab': user.establishment,
          'vto': user.vtoRaw,
          'status': user.isExpired ? 'vencido' : 'activo',
        },
      );
      url = uri.toString();
    }

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final action = message.message;
          if (action == 'logout') {
            _showLogoutConfirmation();
          } else if (action == 'news') {
            context.push('/news');
          } else if (action == 'credential') {
            _webViewController?.loadRequest(Uri.parse(url));
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    setState(() {
      _webViewController = controller;
    });
  }

  Future<void> _showLogoutConfirmation() async {
    final theme = Theme.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Está seguro que desea salir de su cuenta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              minimumSize: const Size(100, 44),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ref.read(authProvider.notifier).logout();
    }
  }

  void _contactAdmin() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contacto de Administración',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Correo electrónico'),
              subtitle: const Text(AppConfig.supportEmail),
            ),
            ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: const Text('Línea de Atención'),
              subtitle: const Text(AppConfig.supportPhone),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credencial Digital'),
      ),
      body: SafeArea(
        child: _isCheckingExpiration
            ? const Center(child: CircularProgressIndicator())
            : _isExpired
                ? _buildExpiredView(theme)
                : Column(
                    children: [
                      // Marquesina fija superior sobre la WebView
                      if (AppConfig.marqueeText.isNotEmpty)
                        const CustomMarquee(
                          text: AppConfig.marqueeText,
                        ),

                      // WebView o Estado Vacío si la URL está sin configurar
                      Expanded(
                        child: AppConfig.webviewCredentialUrl.isEmpty
                            ? const EmptyStateView(
                                icon: Icons.badge_outlined,
                                title: 'Credencial Digital',
                                message: AppConfig.msgCredentialNotConfigured,
                              )
                            : Stack(
                                children: [
                                  if (_webViewController != null)
                                    WebViewWidget(controller: _webViewController!),
                                  if (_isLoading)
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                ],
                              ),
                      ),
                    ],
                  ),
      ),
    );
  }

  /// Vista cuando la credencial está vencida conforme a la especificación
  Widget _buildExpiredView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.gpp_bad_outlined,
                size: 72,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppConfig.msgCredentialExpired,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Su credencial ha superado la fecha de vigencia establecida. Por favor, póngase en contacto con administración para regularizar su situación.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _contactAdmin,
              icon: const Icon(Icons.support_agent),
              label: const Text(AppConfig.btnContactAdmin),
            ),
          ],
        ),
      ),
    );
  }
}
