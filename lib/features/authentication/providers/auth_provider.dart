import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Provider for managing authentication state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Authentication State class to manage authentication status
class AuthState {
  final bool isAuthenticated;
  final String? userId;

  AuthState({
    required this.isAuthenticated,
    this.userId,
  });

  // Utility method to create a new AuthState
  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
    );
  }
}

// AuthNotifier for managing authentication
class AuthNotifier extends StateNotifier<AuthState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthNotifier() : super(AuthState(isAuthenticated: false)) {
    checkAuth();
  }

  // Check if there is an auth token to determine if the user is logged in
  Future<void> checkAuth() async {
    String? token = await _storage.read(key: 'auth_token');
    String? userId = await _storage.read(key: 'user_id');
    if (token != null) {
      state = state.copyWith(isAuthenticated: true, userId: userId);
    }
  }

  // Method to log in the user and save the token
  Future<void> login(String token, String userId) async {
    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'user_id', value: userId);
    state = state.copyWith(isAuthenticated: true, userId: userId);
  }

  // Method to log out the user and remove the token
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_id');
    state = state.copyWith(isAuthenticated: false, userId: '');
  }
}
