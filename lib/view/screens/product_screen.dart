import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/view/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import 'package:product_app/model/Product_Model.dart';
import 'package:product_app/view/components/Favourites_Screen_Components/Favourite_List_Manager.dart';
import 'package:product_app/view/components/Product_Screen_Components/Product_Card_Widget.dart';
import 'package:product_app/view/components/Product_Screen_Components/Product_Detail_Screen.dart';
import 'package:product_app/view/screens/categories_screen.dart';
import 'package:product_app/view/screens/favorities_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _currentIndex = 0;
  late Future<List<Products>> productsFuture;

  List<Products> allProducts = [];
  List<Products> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productsFuture = fetchProducts();
  }

  Future<List<Products>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products?limit=100'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List productsJson = jsonData['products'];
      allProducts = productsJson.map((json) => Products.fromJson(json)).toList();
      filteredProducts = List.from(allProducts);
      return filteredProducts;
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _filterProducts(String query) {
    final results = allProducts.where((product) {
      final title = product.title?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      FutureBuilder<List<Products>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (filteredProducts.isEmpty && allProducts.isNotEmpty) {
            filteredProducts = List.from(allProducts);
          }

          return Column(
            children: [
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
              const SizedBox(height: 4),
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Text(
                          "No products found.",
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final p = filteredProducts[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(product: p),
                                  ),
                                );
                              },
                              child: ProductCardWidget(
                                thumbnail: p.thumbnail ?? '',
                                title: p.title ?? 'No Title',
                                brand: p.brand ?? 'Unknown Brand',
                                category: p.category ?? 'Uncategorized',
                                price: p.price?.toDouble() ?? 0.0,
                                rating: p.rating?.toDouble() ?? 0.0,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      const CategoriesScreen(),

      
      ChangeNotifierProvider.value(
        value: Provider.of<FavoriteManager>(context, listen: false),
        child: const FavoriteScreen(),
      ),

      const ProfileScreen(),

    ];

    String getAppBarTitle() {
      switch (_currentIndex) {
        case 0:
          return 'Products';
        case 1:
          return 'Categories';
        case 2:
          return 'Favourites';
        case 3:
          return "Harry's Account";
        default:
          return '';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          getAppBarTitle(),
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: SizedBox(
          height: 130,
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favourites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Harry',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
