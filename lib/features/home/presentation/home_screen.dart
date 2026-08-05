import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_config.dart';
import '../../login/providers/auth_provider.dart';

/// Pantalla Home Principal (Dashboard de Afiliado).
///
/// Ofrece acceso nativo a:
/// - Credencial Digital
/// - Grupo Familiar
/// - Novedades
/// - Configuración
/// - Cerrar sesión
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
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
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta de bienvenida del Afiliado
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: theme.colorScheme.primary.withAlpha(30),
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'Afiliado',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'DNI: ${user?.dni ?? '-'}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              'N° Afiliado: ${user?.affiliateNumber ?? '-'}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Servicios',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Grid / Lista de accesos directos nativos
              _HomeMenuCard(
                title: 'Credencial Digital',
                subtitle: 'Visualizar su credencial nativa',
                icon: Icons.badge_outlined,
                color: theme.colorScheme.primary,
                onTap: () => context.push('/credential'),
              ),
              const SizedBox(height: 12),

              _HomeMenuCard(
                title: 'Novedades y Anuncios',
                subtitle: 'Últimas noticias y comunicaciones',
                icon: Icons.newspaper_outlined,
                color: const Color(0xFFF57C00),
                onTap: () => context.push('/news'),
              ),
              const SizedBox(height: 12),

              _HomeMenuCard(
                title: 'Configuración',
                subtitle: 'Ajustes e información de soporte',
                icon: Icons.settings_outlined,
                color: const Color(0xFF5E35B1),
                onTap: () => context.push('/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HomeMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
