import 'package:flutter/material.dart';
import '../providers/orders_provider.dart';
import 'package:flutter_app/widgets/cart_item_tile.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Order>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL',
                    style: TextStyle(fontSize: 22),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      cart.totalAmount.toStringAsFixed(2),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: cart.totalAmount <= 0
                        ? null
                        : () async {
                            await order.addOrder(
                                cart.items.values.toList(), cart.totalAmount);

                            cart.clearItems();

                            //Navigator.of(context).pushNamed(OrderScreen.routeName);
                          },
                    child: Text(
                      'ORDER NOW',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return CartTile(
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cart.items.values.toList()[index].title,
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
