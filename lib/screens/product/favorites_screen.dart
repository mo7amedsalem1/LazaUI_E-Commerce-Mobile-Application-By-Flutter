import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/product_card.dart';
import '../../models/product_model.dart';
import '../product/product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlist, child) {
          if (wishlist.wishlistItems.isEmpty) {
            return const Center(child: Text("No favorites yet", style: TextStyle(color: Colors.grey)));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: wishlist.wishlistItems.length,
            itemBuilder: (context, index) {
              final item = wishlist.wishlistItems[index];
              // Reconstruct Product from Map to reuse ProductCard
              // Ideally WishlistProvider should store List<Product> or we parse it here.
              // This is a bit hacker-y for MVP Restyle but works.
              final product = Product(
                id: item['id'],
                title: item['title'] ?? '',
                price: (item['price'] as num).toDouble(),
                description: '', // Not stored in fav mock usually
                images: [item['image'] ?? ''],
              );
              
              return ProductCard(
                product: product,
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
                },
              );
            },
          );
        },
      ),
    );
  }
}
