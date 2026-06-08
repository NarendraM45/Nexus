import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import 'app_providers.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthState {
  final bool isLoggedIn;
  final UserModel? user;
  final bool isLoading;
  final String? error;
  
  const AuthState({
    this.isLoggedIn = false,
    this.user,
    this.isLoading = false,
    this.error,
  });
  
  AuthState copyWith({
    bool? isLoggedIn,
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Can be set to null explicitly
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  
  AuthNotifier(this.ref) : super(const AuthState()) {
    _checkLoggedIn();
  }

  // ✅ Restore session on app start
  Future<void> _checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final name  = prefs.getString('user_name');
    final email = prefs.getString('user_email');
    if (isLoggedIn && name != null && email != null) {
      final u = UserModel(
        id: 'user_001',
        name: name,
        email: email,
        avatarUrl: 'https://i.pravatar.cc/150?u=$email',
        role: 'Pro Member', taskCount: 24, activeCount: 7, score: 92.5, streak: 14, isProMember: true,
      );
      state = state.copyWith(isLoggedIn: true, user: u);
      ref.read(userProvider.notifier).state = u;
    }
  }

  // ✅ SIGNUP
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(milliseconds: 1800)); // simulate API
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('user_password', password); // in real app: hash this
      await prefs.setBool('is_logged_in', true);
      
      final u = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        avatarUrl: 'https://i.pravatar.cc/150?u=$email',
        role: 'New Member', taskCount: 0, activeCount: 0, score: 0.0, streak: 0, isProMember: false,
      );
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        user: u,
      );
      ref.read(userProvider.notifier).state = u;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ✅ LOGIN
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      
      final prefs = await SharedPreferences.getInstance();
      final savedEmail    = prefs.getString('user_email') ?? '';
      final savedPassword = prefs.getString('user_password') ?? '';
      
      if (email == savedEmail && password == savedPassword) {
        final name = prefs.getString('user_name') ?? 'User';
        final u = UserModel(
          id: 'user_001',
          name: name,
          email: email,
          avatarUrl: 'https://i.pravatar.cc/150?u=$email',
          role: 'Pro Member', taskCount: 24, activeCount: 7, score: 92.5, streak: 14, isProMember: true,
        );
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          user: u,
        );
        await prefs.setBool('is_logged_in', true);
        ref.read(userProvider.notifier).state = u;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid email or password.',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ✅ LOGOUT — only called from drawer
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    state = const AuthState(isLoggedIn: false);
  }
}
