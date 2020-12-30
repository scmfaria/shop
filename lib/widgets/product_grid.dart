import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/products.dart';

class ProductGrid extends StatelessWidget {

  final bool showFavoriteOnly;

  ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products = showFavoriteOnly ? productsProvider.favoriteItems : productsProvider.items;
    
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      // aqui estou pegando o provider ja criado no metodo main (por isso o uso do .value)
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      // esse SliverGridDelegateWithFixedCrossAxisCount é para definir que vamos ter uma qtd fixa de elementos na linha do grid.
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}