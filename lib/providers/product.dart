import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id, title, description, imageUrl;
  final double price;
  bool isFavorite;
  Product({
    @required this.price,
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    @required this.title,
    this.isFavorite = false,
  });
  void toggleIsFavorite() {
    final url = 'https://flutter-shop-it.firebaseio.com/products/$id.json';
    http
        .patch(
      url,
      body: json.encode({'isFavorite': !isFavorite}),
    )
        .catchError((err) {
      print('$err\n On toggling favorite');
    });
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
