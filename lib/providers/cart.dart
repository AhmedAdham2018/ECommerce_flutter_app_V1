import 'package:flutter/foundation.dart';

class CartItem {
  String id;
  String title;
  double price;
  double quantity;

  CartItem(
      {@required this.id,
      @required this.price,
      @required this.title,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addCartItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      //change quantity..
      _items.update(
        id,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            price: existingCartItem.price,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
            id: DateTime.now().toString(),
            price: price,
            title: title,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItemCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItemCart(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            price: existingCartItem.price,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity - 1),
      );
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clearItems() {
    _items = {};
    notifyListeners();
  }
}
