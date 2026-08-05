import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/credential/presentation/credential_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/login/presentation/login_screen.dart';
import '../../features/login/providers/auth_provider.dart';
import '../../features/news/presentation/news_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

/// Notifier para refrescar GoRouter cuando cambia el estado de Autenticación
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authProvider,
      (previous, next) => notifyListeners(),
    );
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

/// Provider de la configuración del Router de la App
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      if (authState.isLoading) {
        return null; // Esperar a que determine la sesión inicial
      }

      final isLoggingIn = state.matchedLocation == '/login';

      if (!authState.isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/credential',
        builder: (context, state) => const CredentialScreen(),
      ),
      GoRoute(
        path: '/news',
        builder: (context, state) => const NewsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
