import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authToken, userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items => [..._items];

  List<Product> get favItems =>
      [..._items.where((prd) => prd.isFavorite == true)];

  Product findById(String id) => items.firstWhere((prd) => prd.id == id);

  Future<void> initialize([bool filterById = false]) async {
    try {
      final stringExt =
          filterById ? '&orderBy="creatorId"&equalTo="$userId"' : '';
      String url =
          'https://flutter-shop-it.firebaseio.com/products.json?auth=$authToken' +
              stringExt;
      final res = await http.get(url);
      url =
          'https://flutter-shop-it.firebaseio.com/userFavs/$userId.json?auth=$authToken';
      final favRes = await http.get(url);
      final favData = json.decode(favRes.body);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      final List<Product> processedData = [];
      extractedData.forEach((prdId, prdData) => processedData.add(
            Product(
              price: prdData['price'],
              description: prdData['description'],
              id: prdId,
              imageUrl: prdData['imageUrl'],
              title: prdData['title'],
              isFavorite: favData == null ? false : favData[prdId],
            ),
          ));
      _items = processedData;
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> addProduct(Product prd) async {
    try {
      final String _url =
          'https://flutter-shop-it.firebaseio.com/products.json?auth=$authToken';
      final res = await http.post(
        _url,
        body: json.encode({
          'title': prd.title,
          'description': prd.description,
          'price': prd.price,
          'imageUrl': prd.imageUrl,
          'creatorId': userId,
        }),
      );
      var pro = Product(
        price: prd.price,
        description: prd.description,
        id: json.decode(res.body)['name'],
        imageUrl: prd.imageUrl,
        title: prd.title,
      );
      _items.add(pro);
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> removeWithId(String id) async {
    final url =
        'https://flutter-shop-it.firebaseio.com/products/$id.json?auth=$authToken';
    final existingPrdIndex = _items.indexWhere((prd) => prd.id == id);
    Product existingPrd = _items[existingPrdIndex];
    _items.remove(existingPrd);
    notifyListeners();
    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(existingPrdIndex, existingPrd);
      print('Error ${res.statusCode} while deleting product');
      notifyListeners();
    } else
      existingPrd = null;
  }

  Future<void> editProduct({Product prd, String id}) async {
    final index = _items.indexOf(_items.firstWhere((ele) => ele.id == id));
    if (index >= 0) {
      final url =
          'https://flutter-shop-it.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'title': prd.title,
          'description': prd.description,
          'price': prd.price,
          'imageUrl': prd.imageUrl,
        }),
      );
      _items[index] = prd;
      notifyListeners();
    } else
      print('Edit Products error');
  }
}
