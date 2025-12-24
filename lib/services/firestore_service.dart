import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

/// Service class handling all Firestore database operations
/// for Cart and Favorites management.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Cart Operations ---

  /// Get real-time stream of cart items for a user
  Stream<QuerySnapshot> getCartStream(String uid) {
    return _db
        .collection('carts')
        .doc(uid)
        .collection('items')
        .snapshots();
  }

  /// Add a product to the user's cart
  Future<void> addToCart(String uid, Product product) async {
    final cartRef = _db.collection('carts').doc(uid).collection('items').doc(product.id.toString());
    
    final doc = await cartRef.get();
    if (doc.exists) {
      // If item exists, increment quantity
      final currentQty = doc.data()?['quantity'] ?? 0;
      await cartRef.update({
        'quantity': currentQty + 1,
        'totalPrice': (currentQty + 1) * product.price,
      });
    } else {
      // Add new item
      await cartRef.set({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.images.isNotEmpty ? product.images[0] : '',
        'quantity': 1,
        'totalPrice': product.price,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Remove a product from the cart
  Future<void> removeFromCart(String uid, String productId) async {
    await _db
        .collection('carts')
        .doc(uid)
        .collection('items')
        .doc(productId)
        .delete();
  }

  /// Update quantity of a cart item
  Future<void> updateCartQuantity(String uid, String productId, int quantity, double price) async {
    if (quantity <= 0) {
      await removeFromCart(uid, productId);
      return;
    }
    
    await _db
        .collection('carts')
        .doc(uid)
        .collection('items')
        .doc(productId)
        .update({
          'quantity': quantity,
          'totalPrice': quantity * price,
        });
  }

  /// Clear the entire cart for a user
  Future<void> clearCart(String uid) async {
    final batch = _db.batch();
    final snapshot = await _db.collection('carts').doc(uid).collection('items').get();
    
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }

  // --- Favorites Operations ---

  /// Get real-time stream of favorite items
  Stream<QuerySnapshot> getFavoritesStream(String uid) {
    return _db
        .collection('favorites')
        .doc(uid)
        .collection('items')
        .snapshots();
  }

  /// Add a product to favorites
  Future<void> addToFavorites(String uid, Product product) async {
    await _db
        .collection('favorites')
        .doc(uid)
        .collection('items')
        .doc(product.id.toString())
        .set({
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'image': product.images.isNotEmpty ? product.images[0] : '',
          'addedAt': FieldValue.serverTimestamp(),
        });
  }

  /// Remove a product from favorites
  Future<void> removeFromFavorites(String uid, String productId) async {
    await _db
        .collection('favorites')
        .doc(uid)
        .collection('items')
        .doc(productId)
        .delete();
  }
}
