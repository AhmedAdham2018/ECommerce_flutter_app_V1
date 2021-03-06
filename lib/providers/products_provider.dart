import 'package:flutter/foundation.dart';
import 'package:flutter_app/model/http_exception.dart';
import './auth_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as https;

import './product.dart';

class Products with ChangeNotifier {
  String _tokenId;
  String _userId;

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  void update(Auth auth, List<Product> items) {
    _tokenId = auth.token;
    _items = items;
    _userId = auth.userId;
  }

  //function return only favorite items.

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> addItem(Product product) async {
    final url =
        'https://marketareaflutter-default-rtdb.firebaseio.com/products.json?auth=$_tokenId';
    try {
      final res = await https.post(
        url,
        body: json.encode({
          'creatorId': _userId,
          'productName': product.productName,
          'description': product.description,
          'price': product.price,
          'imgUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
          id: json.decode(res.body)['name'],
          productName: product.productName,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> getAndSetProducts([bool filterByUser = false]) async {
    final filterSegment = filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    
    var url =
        'https://marketareaflutter-default-rtdb.firebaseio.com/products.json?auth=$_tokenId&$filterSegment';

    try {
      final res = await https.get(url);
      final productsData = json.decode(res.body) as Map<String, dynamic>;

      if (productsData == null) {
        return;
      }

      url =
          'https://marketareaflutter-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_tokenId';

      final favoritesRes = await https.get(url);
      final favoritesData = json.decode(favoritesRes.body);

      final List<Product> loadedProducts = [];
      productsData.forEach((productId, productValue) {
        loadedProducts.add(
          Product(
              id: productId,
              productName: productValue['productName'],
              description: productValue['description'],
              price: productValue['price'],
              imageUrl: productValue['imgUrl'],
              isFavorite: favoritesData == null
                  ? false
                  : favoritesData[productId] ?? false),
        );
        _items = loadedProducts;
        notifyListeners();
      });

      notifyListeners();
      //print(productsData);
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product editedProduct) async {
    final index = _items.indexWhere((product) => product.id == id);

    if (index >= 0) {
      final url =
          'https://marketareaflutter-default-rtdb.firebaseio.com/products/$id.json?auth=$_tokenId';

      await https.patch(
        url,
        body: json.encode({
          'productName': editedProduct.productName,
          'description': editedProduct.description,
          'price': editedProduct.price,
          'imgUrl': editedProduct.imageUrl,
        }),
      );
      _items[index] = editedProduct;
      notifyListeners();
    } else {
      print('Can not update product..');
    }
  }

  Future<void> deleteProductItem(String id) async {
    final url =
        'https://marketareaflutter-default-rtdb.firebaseio.com/products/$id.json?auth=$_tokenId';

    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProductData = _items[existingProductIndex];

    _items.remove(existingProductData);
    notifyListeners();

    final res = await https.delete(url);

    if (res.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProductData);
      notifyListeners();
      throw HttpException(messageTitle: 'could not delete product item');
    }

    existingProductData = null;
  }
}

/*

    Product(
      id: 'p1',
      productName: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      productName: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      productName: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      productName: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
        id: 'p5',
        productName: 'Personal computer Laptop',
        description: 'HP laptop core i9-9874 with 16GB ram and 2GBU',
        price: 789,
        imageUrl:
            'https://png.pngtree.com/png-clipart/20191122/original/pngtree-laptop-icon-png-image_5184713.jpg'),
    Product(
        id: 'p6',
        productName: 'BMW Car',
        description: 'BMW car model 2015 with motor 2300 cc',
        price: 19500,
        imageUrl:
            'https://png.pngtree.com/png-clipart/20190705/original/pngtree-creative-elements-of-light-blue-handpainted-car-illustration-png-image_4236022.jpg'),
    Product(
        id: 'p7',
        productName: 'Mini bus',
        description: 'Mini bus model 2013',
        price: 87500,
        imageUrl:
            'https://png.pngtree.com/png-clipart/20190705/original/pngtree-yellow-handpainted-bus-urban-bus-png-image_4241860.jpg'),
    Product(
        id: 'p8',
        productName: 'T shirt',
        description: 'Polo shirt with coton matirial',
        price: 89.35,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1echiG6L2W9c-atGODP_RtZZGNlmdhaSzNg&usqp=CAU'),

*/
