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

  Future<void> toggleIsFavorite(String token, String userId) async {
    final url =
        'https://flutter-shop-it.firebaseio.com/userFavs/$userId/$id.json?auth=$token';
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await http.put(
        url,
        body: json.encode(isFavorite),
      );
    } catch (err) {
      print(err);
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
