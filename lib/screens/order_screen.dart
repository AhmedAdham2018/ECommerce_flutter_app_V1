import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/order_list_item.dart';
import '../widgets/drawer_widget.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).getAndSetOrders(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapShot.error != null) {
              return Center(
                child: Text('An error occured!!'),
              );
            } else {
              return Consumer<Order>(
                builder: (context, orderData, _) {
                  return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (context, index) => OrderListItem(
                      order: orderData.orders[index],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      drawer: MyDrawer(),
    );
  }
}
