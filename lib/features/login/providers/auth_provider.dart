import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/storage_service.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

/// Provider del servicio de almacenamiento seguro
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Provider del repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Estado de la Autenticación
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier de Riverpod para gestionar el estado de sesión del afiliado
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkInitialSession();
    return const AuthState(isLoading: true);
  }

  /// Verifica si ya existe una sesión guardada en el dispositivo al abrir la app
  Future<void> _checkInitialSession() async {
    final storage = ref.read(storageServiceProvider);
    final isLoggedIn = await storage.isLoggedIn();
    if (isLoggedIn) {
      final dni = await storage.getDni();
      final fullName = await storage.getFullName();
      if (dni != null && fullName != null) {
        final affiliateNumber = await storage.getAffiliateNumber() ?? '';
        final establishment = await storage.getEstablishment() ?? '';
        final expirationRaw = await storage.getExpirationDate() ?? '';
        DateTime? expDate;
        if (expirationRaw.isNotEmpty) {
          expDate = DateTime.tryParse(expirationRaw);
        }
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: UserModel(
            dni: dni,
            fullName: fullName,
            affiliateNumber: affiliateNumber,
            establishment: establishment,
            expirationDate: expDate,
          ),
        );
        return;
      }
    }
    state = state.copyWith(isLoading: false, isAuthenticated: false);
  }

  /// Inicia sesión con DNI y Nombre y Apellido
  Future<bool> login(String dni, String fullName) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repository = ref.read(authRepositoryProvider);
      final storage = ref.read(storageServiceProvider);

      final user = await repository.login(
        dni: dni,
        fullName: fullName,
      );

      await storage.saveUserSession(
        dni: user.dni,
        fullName: user.fullName,
        affiliateNumber: user.affiliateNumber,
        establishment: user.establishment,
        expirationDate: user.expirationDate?.toIso8601String() ?? '',
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Cierra la sesión activa
  Future<void> logout() async {
    final storage = ref.read(storageServiceProvider);
    await storage.clearSession();
    state = const AuthState(isAuthenticated: false);
  }
}

/// Provider de Autenticación
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
