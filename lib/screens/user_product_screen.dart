import 'package:flutter/material.dart';
import './edit_product_screen.dart';
import '../widgets/drawer_widget.dart';
import 'package:provider/provider.dart';
import '../widgets/user_product_item_listTile.dart';
import '../providers/products_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                UserProductItemTile(
                  id: productsData.items[index].id,
                  title: productsData.items[index].productName,
                  imgUrl: productsData.items[index].imageUrl,
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
