import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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
  final String _baseUrl = 'https://flutter-coder-f6c87-default-rtdb.firebaseio.com/orders';
  List<Order> _items = [];

  List<Order> get items {
    // esse operador ... cria uma copia da lista, e nao a mesma referencia
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final date = DateTime.now();
    final response = await http.post(
      "$_baseUrl.json",
      body: json.encode({
        'total': total,
        'date': date.toIso8601String(),
        'products': products.map((item) => {
          'id': item.id,
          'productId': item.productId,
          'title': item.title,
          'quantity': item.quantity,
          'price': item.price,        
        }).toList()
      }),
    );

    _items.insert(0, Order(
      id: json.decode(response.body)['name'],
      total: total,
      date: date,
      products: products,
    ));

    notifyListeners();
  }
}