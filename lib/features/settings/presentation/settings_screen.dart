import 'package:flutter/material.dart';
import '../../../config/app_config.dart';

/// Pantalla de Configuración e Información del Sistema.
///
/// Pantalla simple preparada para futuras opciones configurables.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Sección Información de la Aplicación
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                'Información de la App',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Aplicación'),
                    subtitle: Text(AppConfig.appName),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.business_outlined),
                    title: Text('Institución'),
                    subtitle: Text(AppConfig.companyName),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.verified_outlined),
                    title: Text('Versión'),
                    subtitle: Text(AppConfig.appVersion),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sección Soporte
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                'Contacto y Soporte',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.email_outlined),
                    title: Text('Correo de Soporte'),
                    subtitle: Text(AppConfig.supportEmail),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.phone_outlined),
                    title: Text('Teléfono'),
                    subtitle: Text(AppConfig.supportPhone),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
