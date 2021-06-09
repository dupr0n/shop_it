import 'package:flutter/foundation.dart';

class CartItem {
  final String id, title;
  final int quantity;
  final double price;
  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => {..._items};
  int get numberOfItems => _items.length;
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String id) {
    if (_items.containsKey(id)) {
      _items.remove(id);
      notifyListeners();
    } else
      print('Product of id: $id not found');
  }

  void addItem({String productId, double price, String title}) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (oldCartItem) => CartItem(
          id: oldCartItem.id,
          price: oldCartItem.price,
          quantity: oldCartItem.quantity + 1,
          title: oldCartItem.title,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          price: price,
          quantity: 1,
          title: title,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingle(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id].quantity > 1)
      _items.update(
        id,
        (old) => CartItem(
          id: old.id,
          price: old.price,
          quantity: old.quantity - 1,
          title: old.title,
        ),
      );
    else
      _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
