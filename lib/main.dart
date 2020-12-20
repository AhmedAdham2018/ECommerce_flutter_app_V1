import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import './screens/order_screen.dart';
import 'providers/orders_provider.dart';
import './providers/cart.dart';
import './providers/products_provider.dart';
import 'package:provider/provider.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/sign_in_out_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(),
          update: (context, authData, products) {
            return Products()
              ..update(authData, products.items == null ? [] : products.items);
          },
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
            create: (context) => Order(),
            update: (context, authData, ordersData) {
              return Order()..update(authData, ordersData.orders == null  ? [] : ordersData.orders);
            }),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Market Area',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Lato',
            ),
            home: authData.isAuth ? ProductOverviewScreen() : SignInOutScreen(),
            routes: {
              //ProductOverviewScreen.routeName: (context) => ProductOverviewScreen(),
              ProductDetailScreen.routeId: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
