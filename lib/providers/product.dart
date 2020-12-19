import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as https;

class Product with ChangeNotifier {
  final String id;
  final String productName;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.productName,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite() async {
    final url =
        'https://marketareaflutter-default-rtdb.firebaseio.com/products/$id.json';
    var oldFavorite = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();
    try {
      var res = await https.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      if (res.statusCode >= 400) {
        isFavorite = oldFavorite;
        notifyListeners();
      }
    } catch (err) {
      isFavorite = oldFavorite;
      notifyListeners();
    }
  }
}
