import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text('Cart checkout feature is coming soon! Stay tuned.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    _showComingSoonDialog(context);
                  },
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _sampleProducts.length,
        itemBuilder: (context, index) {
          return _ProductCard(product: _sampleProducts[index]);
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isInCart = cartProvider.isInCart(product.id);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.medical_services,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color(0xFF1977CC),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isInCart) {
                        cartProvider.removeFromCart(product);
                      } else {
                        cartProvider.addToCart(product);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInCart ? Colors.red : const Color(0xFF1977CC),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      isInCart ? 'Remove' : 'Add to Cart',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Sample products
final List<ProductModel> _sampleProducts = [
  ProductModel(
    id: '1',
    name: 'Paracetamol 500mg',
    description: 'Pain relief and fever reducer',
    price: 50,
    imageUrl: '',
    category: 'Medicine',
    rating: 4.5,
    reviews: 120,
  ),
  ProductModel(
    id: '2',
    name: 'Vitamin C Tablets',
    description: 'Immunity booster',
    price: 150,
    imageUrl: '',
    category: 'Supplements',
    rating: 4.7,
    reviews: 85,
  ),
  ProductModel(
    id: '3',
    name: 'Hand Sanitizer',
    description: '500ml antibacterial',
    price: 80,
    imageUrl: '',
    category: 'Hygiene',
    rating: 4.3,
    reviews: 200,
  ),
  ProductModel(
    id: '4',
    name: 'Digital Thermometer',
    description: 'Fast and accurate',
    price: 250,
    imageUrl: '',
    category: 'Devices',
    rating: 4.6,
    reviews: 95,
  ),
  ProductModel(
    id: '5',
    name: 'Face Mask (Pack of 50)',
    description: '3-layer protection',
    price: 300,
    imageUrl: '',
    category: 'Safety',
    rating: 4.4,
    reviews: 150,
  ),
  ProductModel(
    id: '6',
    name: 'Blood Pressure Monitor',
    description: 'Digital BP machine',
    price: 1200,
    imageUrl: '',
    category: 'Devices',
    rating: 4.8,
    reviews: 75,
  ),
];
