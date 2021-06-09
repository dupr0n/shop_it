import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_it/providers/cart.dart';

import '../providers/orders.dart';
import '../providers/cart.dart' show Cart; //imports only Cart from it
import '../widgets/cart_card.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final cartItems = cartData.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartData.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ),
                  SizedBox(width: 10),
                  OrderButton(cartData: cartData, cartItems: cartItems),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartData.items.length,
              itemBuilder: (_, i) => CartCard(
                id: cartItems[i].id,
                price: cartItems[i].price,
                quantity: cartItems[i].quantity,
                title: cartItems[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartData,
    @required this.cartItems,
  }) : super(key: key);

  final Cart cartData;
  final List<CartItem> cartItems;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 5,
      color: Colors.grey[350],
      child: _isLoading
          ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircularProgressIndicator(),
            )
          : Text(
              'Order Now',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
      onPressed: (widget.cartData.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() => _isLoading = true);
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cartItems,
                widget.cartData.totalAmount,
              );
              setState(() => _isLoading = false);
              widget.cartData.clear();
            },
    );
  }
}
