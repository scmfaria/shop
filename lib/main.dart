import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';

import './views/products_overview_screen.dart';
import './views/product_detail_screen.dart';
import './utils/app_routes.dart';
import './providers/products.dart';
import './providers/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MultiProvider - para adicionar mais de um provider dentro de um mesmo ponto na aplicação
    // nesse caso estamos adicionando esses dois na raiz da aplicacao.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => new Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => new Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen()
        },
      ),
    );
  }
}
