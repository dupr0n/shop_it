import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.amount,
    @required this.dateTime,
    @required this.id,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  static const _url = 'https://flutter-shop-it.firebaseio.com/orders.json';
  List<OrderItem> _orders = [];
  List<OrderItem> get orders => [..._orders];

  Future<void> initialize() async {
    final res = await http.get(_url);
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    final List<OrderItem> finalOrders = [];
    extractedData.forEach((orderId, order) {
      finalOrders.add(
        OrderItem(
          amount: order['amount'],
          dateTime: DateTime.parse(order['dateTime']),
          id: orderId,
          products: (order['products'] as List<dynamic>)
              .map((cartItem) => CartItem(
                    id: cartItem['id'],
                    price: cartItem['price'],
                    quantity: cartItem['quantity'],
                    title: cartItem['title'],
                  ))
              .toList(),
        ),
      );
    });
    _orders = finalOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final res = await http.post(_url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItem(
        amount: total,
        dateTime: timeStamp,
        id: json.decode(res.body)['name'],
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
