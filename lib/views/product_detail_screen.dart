import 'package:flutter/material.dart';

import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}