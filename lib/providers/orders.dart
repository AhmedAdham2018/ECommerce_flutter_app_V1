import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/providers/cart.dart';
import 'package:http/http.dart' as https;

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

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://marketareaflutter-default-rtdb.firebaseio.com/orders.json';

    final timeStamp = DateTime.now();

    try {
      https.Response res = await https.post(
        url,
        body: json.encode({
          'amount': total,
          'productItems': cartProducts.map((cartProduct) {
            return {
              'id': cartProduct.id,
              'title': cartProduct.title,
              'price': cartProduct.price,
              'quantity': cartProduct.quantity,
            };
          }).toList(),
          'dateTime': timeStamp.toIso8601String(),
        }),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(res.body)['name'],
          amount: total,
          productItems: cartProducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (err) {}
  }

  Future<void> getAndSetOrders() async {
    final url =
        'https://marketareaflutter-default-rtdb.firebaseio.com/orders.json';

    try {
      https.Response res = await https.get(url);

      final ordersData = json.decode(res.body) as Map<String, dynamic>;

      if (ordersData == null) {
        return;
      }

      ordersData.forEach((orderKey, ordervalue) {
        _orders.insert(
          0,
          OrderItem(
            id: orderKey,
            amount: ordervalue['amount'],
            dateTime: DateTime.parse(ordervalue['dateTime']),
            productItems: (ordervalue['productItems'] as List<dynamic>)
                .map((productItem) {
              return CartItem(
                  id: productItem['id'],
                  price: productItem['price'],
                  title: productItem['title'],
                  quantity: productItem['quantity']);
            }).toList(),
          ),
        );
      });

      notifyListeners();
      print(ordersData);
    } catch (err) {}
  }
}
