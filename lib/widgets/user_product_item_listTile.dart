import 'package:flutter/material.dart';
import 'package:flutter_app/model/http_exception.dart';
import '../providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductItemTile extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;
  UserProductItemTile({this.id, this.imgUrl, this.title});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProductItem(id);
                  } catch (err) {
                    final snackbar = SnackBar(
                      content: Text(err.toString()),
                    );
                    scaffold.showSnackBar(snackbar);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
