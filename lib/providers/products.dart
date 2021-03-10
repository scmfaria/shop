import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final String _baseUrl = 'https://flutter-coder-f6c87-default-rtdb.firebaseio.com/products';
  List<Product> _items = [];
  String _token;

  Products(this._token, this._items);

  List<Product> get items {
    return _items;
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get("$_baseUrl.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();
    
    if(data != null) {
      data.forEach((productId, productData) {
        _items.add(Product(
          id: productId,
          title: productData['title'], 
          description: productData['description'], 
          price: productData['price'], 
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ));
      });
      notifyListeners();
    }
    
    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      "$_baseUrl.json?auth=$_token", 
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    );

    json.decode(response.body);
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

  Future<void> updateProduct(Product product) async {
    if(product != null && product.id != null) {
      final index = _items.indexWhere((prod) => prod.id == product.id);

      if(index >= 0) {
        await http.patch(
          "$_baseUrl/${product.id}.json?auth=$_token",
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }),
        );

        _items[index] = product;
        notifyListeners();
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);

    if(index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete("$_baseUrl/${product.id}.json?auth=$_token");
      
      if(response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusao do produto');
      }
    }
  }

  int get productsCount {
    return _items.length;
  }
}