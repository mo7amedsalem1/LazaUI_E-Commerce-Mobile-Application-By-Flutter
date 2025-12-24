import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';
import 'auth_provider.dart';

/// Provider for managing favorites/wishlist state using Firestore
class WishlistProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>> _wishlistItems = [];
  
  /// List of favorite items
  List<Map<String, dynamic>> get wishlistItems => _wishlistItems;

  WishlistProvider(this.authProvider) {
    if (authProvider.isAuthenticated) {
      _listenToWishlist();
    }
  }

  /// Listen to real-time favorites updates from Firestore
  void _listenToWishlist() {
    final uid = authProvider.user!.uid;
    _firestoreService.getFavoritesStream(uid).listen((snapshot) {
      _wishlistItems = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      notifyListeners();
    });
  }

  /// Toggle favorite status of a product
  Future<void> toggleFavorite(Product product) async {
    if (authProvider.user == null) return;
    final uid = authProvider.user!.uid;
    
    if (isFavorite(product.id.toString())) {
      await _firestoreService.removeFromFavorites(uid, product.id.toString());
    } else {
      await _firestoreService.addToFavorites(uid, product);
    }
  }

  /// Check if a product is in favorites
  bool isFavorite(String productId) {
    return _wishlistItems.any((item) => item['id'].toString() == productId);
  }
}
