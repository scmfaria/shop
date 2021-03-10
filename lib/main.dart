import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/orders_screen.dart';
import 'package:shop/views/product_form_screen.dart';
import 'package:shop/views/products_screen.dart';

import './views/products_overview_screen.dart';
import './views/product_detail_screen.dart';
import './views/cart_screen.dart';
import './views/auth_screen.dart';
import 'views/auth_home_screen.dart';

import './utils/app_routes.dart';

import './providers/products.dart';
import './providers/cart.dart';
import 'providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MultiProvider - para adicionar mais de um provider dentro de um mesmo ponto na aplicação
    // nesse caso estamos adicionando esses dois na raiz da aplicacao.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(null, []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token, 
            previousProducts.items
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),

        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(null, []),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token, 
            previousOrders.items
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
      //  home: ProductOverviewScreen(),
        routes: {
          AppRoutes.AUTH: (ctx) => AuthOrHomeScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrderScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
