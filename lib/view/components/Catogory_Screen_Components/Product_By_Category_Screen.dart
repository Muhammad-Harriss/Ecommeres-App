import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:product_app/model/Product_Model.dart';
import 'package:product_app/view/components/Product_Screen_Components/Product_detail_Screen.dart';
import 'package:product_app/view/components/Product_Screen_Components/product_card_widget.dart';

class ProductByCategoryScreen extends StatefulWidget {
  final String category;

  const ProductByCategoryScreen({super.key, required this.category});

  @override
  State<ProductByCategoryScreen> createState() =>
      _ProductByCategoryScreenState();
}

class _ProductByCategoryScreenState extends State<ProductByCategoryScreen> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
  }

  Future<void> fetchProductsByCategory() async {
    final url = Uri.parse(
      "https://dummyjson.com/products/category/${widget.category}",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = data['products'];
        filteredProducts = List.from(products);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void _filterProducts(String query) {
    final results =
        products.where((product) {
          final title = (product['title'] ?? '').toString().toLowerCase();
          return title.contains(query.toLowerCase());
        }).toList();

    setState(() {
      filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.toUpperCase(),
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: _filterProducts,
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        hintStyle: GoogleFonts.poppins(),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // Result count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${filteredProducts.length} results found",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Product list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];

                        return InkWell(
                          onTap: () {
                            // Convert product map to Products model
                            final model = Products.fromJson(product);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        ProductDetailScreen(product: model),
                              ),
                            );
                          },
                          child: ProductCardWidget(
                            thumbnail: product['thumbnail'] ?? '',
                            title: product['title'] ?? 'No Title',
                            brand: product['brand'] ?? 'Unknown Brand',
                            category: product['category'] ?? 'Uncategorized',
                            rating:
                                (product['rating'] as num?)?.toDouble() ?? 0.0,
                            price:
                                (product['price'] as num?)?.toDouble() ?? 0.0,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
