import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_app/view/components/Favourites_Screen_Components/Favourite_List_Manager.dart';
import 'package:product_app/view/components/Product_Screen_Components/Product_detail_Screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteManager>().favorites;
    print("FavoriteScreen build, favorites count: ${favorites.length}");

    return Scaffold(
      backgroundColor: Colors.white,
      body: favorites.isEmpty
          ? const Center(child: Text("No favorites yet."))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  child: ListTile(
                    leading: Image.network(product.thumbnail ?? '', width: 50),
                    title: Text(product.title ?? 'No Title'),
                    subtitle: Text("\$${product.price}"),
                    trailing: const Icon(Icons.favorite, color: Colors.red),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
