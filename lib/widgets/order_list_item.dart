import 'package:flutter/material.dart';
import '../providers/orders.dart';

import 'package:intl/intl.dart';

class OrderListItem extends StatefulWidget {
  final OrderItem order;
  OrderListItem({this.order});

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.order.amount.toStringAsFixed(3),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat('dd-MM-yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.all(10),
              height: 120,
              child: ListView(
                children: widget.order.productItems.map((product) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('${product.quantity}x \$ ${product.price}'),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
