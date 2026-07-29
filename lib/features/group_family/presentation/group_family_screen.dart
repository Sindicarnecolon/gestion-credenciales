import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../config/app_config.dart';
import '../../../core/widgets/empty_state_view.dart';

/// Pantalla de Grupo Familiar (Contenedor WebView).
///
/// La URL se obtiene desde `AppConfig.webviewGroupUrl`.
/// Si la URL está vacía, muestra el mensaje: "Formulario aún no configurado."
class GroupFamilyScreen extends StatefulWidget {
  const GroupFamilyScreen({super.key});

  @override
  State<GroupFamilyScreen> createState() => _GroupFamilyScreenState();
}

class _GroupFamilyScreenState extends State<GroupFamilyScreen> {
  WebViewController? _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (AppConfig.webviewGroupUrl.isNotEmpty) {
      _initWebView();
    }
  }

  void _initWebView() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
      ..loadRequest(Uri.parse(AppConfig.webviewGroupUrl));

    _webViewController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupo Familiar'),
      ),
      body: SafeArea(
        child: AppConfig.webviewGroupUrl.isEmpty
            ? const EmptyStateView(
                icon: Icons.family_restroom_outlined,
                title: 'Grupo Familiar',
                message: AppConfig.msgGroupNotConfigured,
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
    );
  }
}
