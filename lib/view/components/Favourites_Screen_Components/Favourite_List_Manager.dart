import 'package:flutter/foundation.dart';
import 'package:product_app/model/Product_Model.dart';

class FavoriteManager extends ChangeNotifier {
  final List<Products> _favorites = [];

  List<Products> get favorites => List.unmodifiable(_favorites);

  void toggleFavorite(Products product) {
    if (isFavorite(product)) {
      print('Removed product id: ${product.id}');
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
       print('Added product id: ${product.id}');
    }
    notifyListeners();
  }

  bool isFavorite(Products product) {
    return _favorites.any((p) => p.id == product.id);
  }
}
