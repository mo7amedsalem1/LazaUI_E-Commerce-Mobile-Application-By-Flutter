import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// Provider for managing authentication state
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  AuthProvider() {
    _init();
  }

  void _init() {
    try {
      _authService.authStateChanges.listen((User? user) {
        _user = user;
        notifyListeners();
      });
    } catch (e) {
      debugPrint("Auth Listener Error: $e");
    }
  }

  /// Current authenticated user (Firebase User)
  User? get user => _user;

  /// Returns true if user is currently logged in
  bool get isAuthenticated => _user != null;

  /// Sign up with email and password
  Future<void> signUp(String email, String password) async {
     await _authService.signUp(email, password);
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
  }

  /// Sign out
  Future<void> signOut() async {
    await _authService.signOut();
  }
  
  /// Send password reset email
  Future<void> resetPassword(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }
}
