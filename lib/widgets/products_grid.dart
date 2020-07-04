import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../models/filter_enum.dart';
import '../providers/products.dart';
import '../screens/product_detail_screen.dart';

class ProductsGrid extends StatelessWidget {
  final FilterOptions filter;
  ProductsGrid(this.filter);
  @override
  Widget build(BuildContext context) {
    final products = filter == FilterOptions.All
        ? Provider.of<Products>(context).items
        : Provider.of<Products>(context).favItems;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          ProductDetailScreen.routeName,
          arguments: products[i].id,
        ),
        child: ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        ),
      ),
    );
  }
}
