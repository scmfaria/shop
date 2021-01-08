import 'dart:math';

import 'package:flutter/foundation.dart';
import './product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.productId,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get item {
    return { ..._items };
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  void addItem(Product product) {
    if(_items.containsKey(product.id)) {
      _items.update(product.id, (existingItem) => 
        CartItem(
          id: existingItem.id, 
          title: existingItem.title, 
          quantity: existingItem.quantity + 1, 
          price: existingItem.price,
          productId: product.id
        ),
      );
    } else {
      _items.putIfAbsent(product.id, () => CartItem(
        id: Random().nextDouble().toString(), 
        title: product.title, 
        quantity: 1, 
        price: product.price,
        productId: product.id
      ),
     );
    }

    notifyListeners();
  } 

  void removeSingleItem(String productId) {
    if(!_items.containsKey(productId)) {
      return;
    }

    if(_items[productId].quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(productId, (existingItem) => 
        CartItem(
          id: existingItem.id, 
          title: existingItem.title, 
          quantity: existingItem.quantity - 1, 
          price: existingItem.price,
          productId: productId
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}