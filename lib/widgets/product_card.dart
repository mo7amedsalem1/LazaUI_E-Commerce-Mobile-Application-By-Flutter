import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(product.images.isNotEmpty 
                      ? product.images.first 
                      : 'https://via.placeholder.com/150'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                       padding: const EdgeInsets.all(6),
                       decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                       child: const Icon(Icons.favorite_border, size: 18), 
                       // Note: Logic for favorite toggle in card is extra, keeping static for UI now or passing fav state
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 5),
          Text(
            "\$${product.price}", 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
