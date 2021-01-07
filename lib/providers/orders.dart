import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop/providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    // esse operador ... cria uma copia da lista, e nao a mesma referencia
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void addOrder(List<CartItem> products, double total) {
    _items.insert(0, Order(
      id: Random().nextDouble().toString(),
      total: total,
      date: DateTime.now(),
      products: products,
    ));

    notifyListeners();
  }
}