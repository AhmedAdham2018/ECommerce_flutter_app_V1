import 'package:flutter/foundation.dart';
import './cart.dart';

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> productItems;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.productItems, this.dateTime});
}