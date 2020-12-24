import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_data.dart';

class Products with ChangeNotifier {

  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [ ..._items ];

  void addProduct(Product product) {
    _items.add(product);
    // sempre que haver uma mudanças nos dados dentro dessa classe, eu preciso chamar esse metodo abaixo
    // para notificar "os interessados" sobre que a lista mudou
    notifyListeners();
  }
}