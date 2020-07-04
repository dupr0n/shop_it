import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<Products>(
            builder: (context, productsData, div) {
              return ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, i) => Column(
                  children: <Widget>[
                    UserProductItem(
                      id: productsData.items[i].id,
                      title: productsData.items[i].title,
                      imageUrl: productsData.items[i].imageUrl,
                    ),
                    const Divider(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
