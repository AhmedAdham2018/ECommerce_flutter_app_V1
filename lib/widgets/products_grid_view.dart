import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../providers/products_provider.dart';

class ProductsGridView extends StatelessWidget {
  final favoriteProduct;
  ProductsGridView({this.favoriteProduct});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context,listen: true);
    final products =
        favoriteProduct ? productData.favoriteItems : productData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(),
          );
        });
  }
}
