import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final double quantity;

  CartTile({this.id, this.productId, this.title, this.price, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Are you sure ? '),
                content: Text('Do you want to delete product item from cart ?'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  ),
                ],
              );
            });
      },
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FittedBox(child: Text(price.toStringAsFixed(2))),
              ),
            ),
            title: Text(title),
            subtitle: Text('TOTAL: \$ ${(quantity * price)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
      onDismissed: (_) =>
          Provider.of<Cart>(context, listen: false).removeItemCart(productId),
    );
  }
}
