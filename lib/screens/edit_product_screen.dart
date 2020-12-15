import 'package:flutter/material.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _imageUrlFocusNode = FocusNode();
  final TextEditingController _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var _editedProductData = Product(
      id: null, productName: '', description: '', price: 0.0, imageUrl: '');

  //.....

  var _isInit = true;

  var _initValues = {
    'id': '',
    'productName': '',
    'price': '',
    'description': '',
    'imgUrl': '',
  };

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProductData = Provider.of<Products>(context, listen: false)
            .findProductById(productId);

        _initValues = {
          'id': _editedProductData.id,
          'productName': _editedProductData.productName,
          'price': _editedProductData.price.toString(),
          'description': _editedProductData.description,
          'imgUrl': '',
        };
        _imageUrlController.text = _editedProductData.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _saveForm() {

    var isValidate = _formKey.currentState.validate();

    if (!isValidate) {
      return;
    }
    _formKey.currentState.save();
    //print(_editedProductData.productName);

    if (_editedProductData.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProductData.id, _editedProductData);
    } else {
      Provider.of<Products>(context, listen: false).addItem(_editedProductData);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['productName'],
                onSaved: (titleValue) {
                  _editedProductData = Product(
                      id: _editedProductData.id,
                      productName: titleValue,
                      description: _editedProductData.description,
                      price: _editedProductData.price,
                      imageUrl: _editedProductData.imageUrl,
                      isFavorite: _editedProductData.isFavorite);
                },
                decoration: InputDecoration(
                  labelText: 'Product name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocusNode),
                validator: (titleValue) {
                  if (titleValue.isEmpty) {
                    return 'Please enter product name.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                  initialValue: _initValues['price'],
                  onSaved: (titleValue) {
                    _editedProductData = Product(
                        id: _editedProductData.id,
                        productName: _editedProductData.productName,
                        description: _editedProductData.description,
                        price: double.parse(titleValue),
                        imageUrl: _editedProductData.imageUrl,
                        isFavorite: _editedProductData.isFavorite);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Product Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) => FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode),
                  validator: (titleValue) {
                    if (titleValue.isEmpty) {
                      return 'Please enter product price.';
                    }
                    if (double.tryParse(titleValue) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (double.parse(titleValue) <= 0) {
                      return 'Please enter a number greater than zero.';
                    }
                    return null;
                  }),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                  initialValue: _initValues['description'],
                  onSaved: (titleValue) {
                    _editedProductData = Product(
                        id: _editedProductData.id,
                        productName: _editedProductData.productName,
                        description: titleValue,
                        price: _editedProductData.price,
                        imageUrl: _editedProductData.imageUrl,
                        isFavorite: _editedProductData.isFavorite);
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Product Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  focusNode: _descriptionFocusNode,
                  validator: (titleValue) {
                    if (titleValue.isEmpty) {
                      return 'Please enter product description.';
                    }
                    if (titleValue.length < 10) {
                      return 'Should be at least 10 characters long.';
                    }
                    return null;
                  }),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      onSaved: (titleValue) {
                        _editedProductData = Product(
                            id: _editedProductData.id,
                            productName: _editedProductData.productName,
                            description: _editedProductData.description,
                            price: _editedProductData.price,
                            isFavorite: _editedProductData.isFavorite,
                            imageUrl: titleValue);
                      },
                      decoration:
                          InputDecoration(labelText: 'Product Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      validator: (titleValue) {
                        if (titleValue.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!titleValue.startsWith('http') &&
                            !titleValue.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!titleValue.endsWith('.png') &&
                            !titleValue.endsWith('.jpg') &&
                            !titleValue.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
