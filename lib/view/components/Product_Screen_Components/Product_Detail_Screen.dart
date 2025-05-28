import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_app/model/Product_Model.dart';
import 'package:product_app/view/components/Favourites_Screen_Components/Favourite_List_Manager.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Products product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final images = product.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: GoogleFonts.playfairDisplay(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product_${product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.thumbnail ?? '',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image)),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Product Details:",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Consumer<FavoriteManager>(
                  builder: (context, favManager, child) {
                    final isFavorite = favManager.isFavorite(product);
                    return IconButton(
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 28,
                      ),
                      onPressed: () {
                        favManager.toggleFavorite(product);
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Name:  ${product.title ?? 'N/A'}",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Price:   \$${product.price}",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Category:  ${product.category ?? 'N/A'}",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Brand:  ${product.brand ?? 'N/A'}",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Row(
              children: [
                Text("Rating: ${product.rating}",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const Icon(Icons.star, color: Colors.orange, size: 16),
              ],
            ),
            const SizedBox(height: 5),
            Text("Stock: ${product.stock}",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Description:",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            SelectableText(product.description ?? '',
                style: GoogleFonts.poppins()),
            const SizedBox(height: 12),
            Text("Product Gallery:",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      images[index],
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
