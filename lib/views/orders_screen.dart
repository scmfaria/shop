import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/orders.dart';

import '../widgets/order_widget.dart';
import 'package:shop/widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if(snapshot.error != null) {
            return Center(child: Text('Ocorreu um erro!!'));
          } else {
            return Consumer<Orders>(
              builder: (ctx, orders, child) {
                return ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
              );
              },
            );
          }
        },
        future: Provider.of(context, listen: false).loadOrders(),
      ),
    );
  }
}