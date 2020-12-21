import 'package:flutter/material.dart';
import 'package:flutter_app/providers/products_provider.dart';
import '../widgets/drawer_widget.dart';
import './cart_screen.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid_view.dart';
import '../widgets/badge.dart.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  //static const routeName = '/';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoriteProducts = false;
  //var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Products>(context, listen: false).getAndSetProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market Area'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Favorite only'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('All items'),
                  value: FilterOptions.All,
                ),
              ];
            },
            onSelected: (FilterOptions valueSelected) {
              setState(() {
                if (valueSelected == FilterOptions.Favorites) {
                  _showFavoriteProducts = true;
                } else {
                  _showFavoriteProducts = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (context, card, child) {
              return Badge(
                child: child,
                value: card.itemsCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        child: ProductsGridView(
          favoriteProduct: _showFavoriteProducts,
        ),
        color: Theme.of(context).primaryColor,
        inAsyncCall: _isLoading,
      ),
      drawer: MyDrawer(),
    );
  }
}
