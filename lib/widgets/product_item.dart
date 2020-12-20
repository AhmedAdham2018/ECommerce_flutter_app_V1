import 'package:flutter/material.dart';
import 'package:flutter_app/providers/cart.dart';
import '../providers/auth_provider.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context,listen: false);
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeId, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(product.productName),
          leading: Consumer<Product>(
            builder: (context, product, _) {
              return IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    product.toggleFavorite(auth.token,auth.userId);
                  });
            },
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cart.addCartItem(product.id, product.productName, product.price);
              final snackBar = SnackBar(
                content: Text('Added product to your cart!'),
                action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItemCart(product.id);
                    }),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
          ),
        ),
      ),
    );
  }
}
