import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'product.dart';
import '../data/dummy_data.dart';

class Products with ChangeNotifier {

  List<Product> _items = DUMMY_PRODUCTS;

 // bool _showFavoriteOnly = false;

  List<Product> get items {
    return _items;
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  void addProduct(Product newProduct) {
    _items.add(Product(
      id: Random().nextDouble().toString(),
      title: newProduct.title, 
      description: newProduct.description, 
      price: newProduct.price, 
      imageUrl: newProduct.imageUrl
    ));
    // sempre que haver uma mudanças nos dados dentro dessa classe, eu preciso chamar esse metodo abaixo
    // para notificar "os interessados" sobre que a lista mudou
    notifyListeners();
  }

  void updateProduct(Product product) {
    if(product != null && product.id != null) {
      final index = _items.indexWhere((prod) => prod.id == product.id);

      if(index >= 0) {
        _items[index] = product;
        notifyListeners();
      }
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);

    if(index >= 0) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }

  int get productsCount {
    return _items.length;
  }
}