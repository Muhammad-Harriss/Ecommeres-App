import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/model/Catogories_Model.dart';
import 'package:product_app/view/components/Catogory_Screen_Components/Category_Card_Widget.dart';
import 'package:product_app/view/components/Catogory_Screen_Components/Product_By_Category_Screen.dart';
import 'dart:convert';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Catogories_Model> categories = [];
  List<Catogories_Model> filteredCategories = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse("https://dummyjson.com/products/categories");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        categories = data.map((json) => Catogories_Model.fromJson(json)).toList();
        filteredCategories = categories;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCategories = categories
          .where((cat) => (cat.name ?? '').toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  Search Bar
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Categories...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    //  Total Results
                    Text(
                      'Total Results: ${filteredCategories.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    //  Grid of Categories
                    Expanded(
                      child: GridView.builder(
                        itemCount: filteredCategories.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 3 / 2.5,
                        ),
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];
                          return CategoryCard(
                            title: category.name ?? '',
                            imageUrl: getCategoryImage(category.slug),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductByCategoryScreen(
                                    category: category.slug ?? '',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String getCategoryImage(String? slug) {
    const imageMap = {
      'beauty':
          'https://scontent.fisb2-2.fna.fbcdn.net/v/t39.30808-1/475118617_976353917713339_4858038541342790420_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=111&ccb=1-7&_nc_sid=1d2534&_nc_eui2=AeH-IU-7b4IZI_hc77Ai4TRzNKUU8QwUIuk0pRTxDBQi6RZ98mhCgGYm-dM-WCm-KYAcjmvqhsfbuhDS5MJV29bQ&_nc_ohc=dRntK0kAVlsQ7kNvwFpZNqF&_nc_oc=AdlVq72hhDnq1Rc1ZWTf2H_yc_NqQcnd0oVrxSzoPuj2cLvk07xAzhcDzh8dDRwTkrM&_nc_zt=24&_nc_ht=scontent.fisb2-2.fna&_nc_gid=Qx_oQLuR3SF4OUqxrVKyVg&oh=00_AfKhxoZH2GQQ4fRjhDysGxcC4fiaJhR9JwoZyzkM9PxmIQ&oe=683A58EF',
      'fragrances':
          'https://images.pexels.com/photos/1961795/pexels-photo-1961795.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'furniture':
          'https://images.pexels.com/photos/1866149/pexels-photo-1866149.jpeg',
      'groceries':
          'https://images.pexels.com/photos/13211457/pexels-photo-13211457.jpeg?auto=compress&cs=tinysrgb&w=600',
      'home-decoration':
          'https://images.pexels.com/photos/667838/pexels-photo-667838.jpeg?auto=compress&cs=tinysrgb&w=600',
      'kitchen-accessories':
          'https://cdn.pixabay.com/photo/2015/04/08/13/13/kitchen-712665_1280.jpg',
      'laptops': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
      'mens-shirts':
          'https://images.pexels.com/photos/9489155/pexels-photo-9489155.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'mens-shoes':
          'https://images.pexels.com/photos/298863/pexels-photo-298863.jpeg?auto=compress&cs=tinysrgb&w=600',
      'mens-watches':
          'https://images.pexels.com/photos/380782/pexels-photo-380782.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',

      'mobile-accessories':
          'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'motorcycle':
          'https://images.pexels.com/photos/2607554/pexels-photo-2607554.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'skin-care':
          'https://images.pexels.com/photos/3762454/pexels-photo-3762454.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'smartphones':
          'https://images.pexels.com/photos/2093322/pexels-photo-2093322.jpeg?auto=compress&cs=tinysrgb&w=600',
      'sports-accessories':
          'https://images.pexels.com/photos/32197485/pexels-photo-32197485/free-photo-of-motocross-rider-mid-air-jump-against-clear-sky.jpeg?auto=compress&cs=tinysrgb&w=600',
      'sunglasses':
          'https://images.pexels.com/photos/1689731/pexels-photo-1689731.jpeg?auto=compress&cs=tinysrgb&w=600',
      'tablets': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
      'tops':
          'https://images.pexels.com/photos/1152994/pexels-photo-1152994.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'vehicle': 'https://images.pexels.com/photos/712618/pexels-photo-712618.jpeg?auto=compress&cs=tinysrgb&w=400',
      'womens-bags':
          'https://images.pexels.com/photos/1039518/pexels-photo-1039518.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'womens-dresses':
          'https://images.pexels.com/photos/17891795/pexels-photo-17891795/free-photo-of-young-woman-in-a-white-blouse-and-black-polka-dot-skirt-on-a-sidewalk.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'womens-jewellery':
          'https://images.pexels.com/photos/32255725/pexels-photo-32255725/free-photo-of-stylish-woman-with-hibiscus-and-heart-glasses-outdoors.jpeg?auto=compress&cs=tinysrgb&w=600',
      'womens-shoes':
          'https://images.pexels.com/photos/2043590/pexels-photo-2043590.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'womens-watches':
          'https://images.pexels.com/photos/1374128/pexels-photo-1374128.jpeg?auto=compress&cs=tinysrgb&w=600',
    };

    return imageMap[slug?.toLowerCase() ?? ''] ??
        'https://dummyimage.com/600x400/cccccc/000000&text=${Uri.encodeComponent(slug ?? '')}';
  }
}
