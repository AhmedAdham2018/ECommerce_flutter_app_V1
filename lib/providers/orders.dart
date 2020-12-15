import 'package:flutter/foundation.dart';
import 'package:flutter_app/providers/cart.dart';

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> productItems;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.productItems, this.dateTime});
}

class Order with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        productItems: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
