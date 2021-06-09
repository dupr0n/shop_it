import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_it/widgets/app_drawer.dart';

import '../providers/orders.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).initialize(),
          builder: (ctx, dataSnap) {
            switch (dataSnap.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return Consumer<Orders>(
                  builder: (ctx, orderData, _) {
                    return ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (_, i) => OrderCard(orderData.orders[i]),
                    );
                  },
                );
              default:
                print('Error in Orders Screen: ${dataSnap.error}');
                return Text('Error in Orders Screen');
            }
          },
        )
        // ?
        );
  }
}
