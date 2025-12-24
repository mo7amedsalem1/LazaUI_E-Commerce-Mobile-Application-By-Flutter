import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';
import 'auth_provider.dart';

/// Provider for managing shopping cart state using Firestore
class CartProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>> _cartItems = [];
  
  /// List of items currently in the cart
  List<Map<String, dynamic>> get cartItems => _cartItems;

  /// Calculate total price of all items in cart
  double get subtotal =>
      _cartItems.fold(0, (sum, item) => sum + (item['totalPrice'] ?? 0));

  CartProvider(this.authProvider) {
    if (authProvider.isAuthenticated) {
      _listenToCart();
    }
  }

  /// Listen to real-time cart updates from Firestore
  void _listenToCart() {
    final uid = authProvider.user!.uid;
    _firestoreService.getCartStream(uid).listen((snapshot) {
      _cartItems = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      notifyListeners();
    });
  }

  /// Add product to cart
  Future<void> addToCart(Product product) async {
    if (authProvider.user == null) return;
    await _firestoreService.addToCart(authProvider.user!.uid, product);
  }

  /// Remove product from cart
  Future<void> removeFromCart(String productId) async {
    if (authProvider.user == null) return;
    await _firestoreService.removeFromCart(authProvider.user!.uid, productId);
  }

  /// Update quantity of an item
  Future<void> updateQuantity(
    String productId,
    int quantity,
    double price,
  ) async {
    if (authProvider.user == null) return;
    await _firestoreService.updateCartQuantity(
      authProvider.user!.uid,
      productId,
      quantity,
      price,
    );
  }

  /// Clear all items from cart
  Future<void> clearCart() async {
    if (authProvider.user == null) return;
    await _firestoreService.clearCart(authProvider.user!.uid);
  }
}
