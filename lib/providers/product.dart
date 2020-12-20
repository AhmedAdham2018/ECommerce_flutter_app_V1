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

  Future<void> toggleFavorite(String token, String userId) async {
    final url =
        'https://marketareaflutter-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    var oldFavorite = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();
    try {
      var res = await https.put(
        url,
        body: json.encode(
          isFavorite,
        ),
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
