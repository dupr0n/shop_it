import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product prd = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: FadeInImage.assetNetwork(
          placeholder: 'lib/assets/images/shop.png',
          image: prd.imageUrl,
          fit: BoxFit.cover,
          fadeInCurve: Curves.fastLinearToSlowEaseIn,
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, prd, _) => IconButton(
              icon:
                  Icon(prd.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: prd.toggleIsFavorite,
            ),
          ),
          backgroundColor: Colors.black54,
          title: Text(prd.title),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(
                price: prd.price,
                productId: prd.id,
                title: prd.title,
              );
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added ${prd.title} to Cart',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Theme.of(context).primaryColorLight,
                    onPressed: () {
                      cart.removeSingle(prd.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
