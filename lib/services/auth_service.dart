import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Service class handling all Firebase Authentication operations
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Optional: Add Google Sign-In instance if needed later

  /// Stream of authentication state changes (User? or null)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Sign up a new user with email and password
  /// 
  /// Throws [FirebaseAuthException] on failure (e.g., weak-password, email-already-in-use)
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data in Firestore
      if (result.user != null) {
        await _createUserDocument(result.user!);
      }

      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("SignUp Error: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("SignUp General Error: $e");
      rethrow;
    }
  }

  /// Sign in an existing user with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
       debugPrint("SignIn Error: ${e.code} - ${e.message}");
       rethrow;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint("Password Reset Error: ${e.code} - ${e.message}");
      rethrow; 
    }
  }

  /// Helper to create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'uid': user.uid,
      });
    } catch (e) {
      debugPrint("Error creating user doc: $e");
      // Don't block auth flow if firestore write fails, but unlikely.
    }
  }
}
