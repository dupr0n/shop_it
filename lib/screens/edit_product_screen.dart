import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_products_screen.dart';
import '../providers/products.dart';
import '../providers/product.dart';
import '../widgets/alert_card.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool _init = true;
  bool _isLoading = false;
  String productId;
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    price: null,
    description: null,
    id: null,
    imageUrl: null,
    title: null,
    isFavorite: null,
  );

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) setState(() {});
  }

  void _saveForm() => _form.currentState.save();

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      _init = false;
      productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false).findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            if (_form.currentState.validate()) {
              _form.currentState.save();
              setState(() => _isLoading = true);
              if (productId == null) {
                try {
                  await productData.addProduct(_editedProduct);
                } catch (error) {
                  alertCard(
                      'Something went wrong somewhere...', context, UserProductsScreen.routeName);
                }
              } else
                await productData.editProduct(id: productId, prd: _editedProduct);
              setState(() => _isLoading = false);
              Navigator.of(context).pop();
            } else
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Column(
                          children: <Widget>[
                            Icon(Icons.error, size: 75),
                            SizedBox(height: 20),
                            Text('You haven\'t filled out all fields! Exit anyway?'),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () => Navigator.of(context)
                                .popUntil(ModalRoute.withName(UserProductsScreen.routeName)),
                          ),
                          FlatButton(
                            child: Text('No'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ));
          },
        ),
        title: Text(_editedProduct.id == null ? 'Add Product' : 'Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _editedProduct.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),
                      validator: (value) =>
                          value.isEmpty ? '\'\' isn\'t exactly a great name for this' : null,
                      onSaved: (newValue) => _editedProduct = Product(
                        price: _editedProduct.price,
                        description: _editedProduct.description,
                        id: _editedProduct.description,
                        imageUrl: _editedProduct.description,
                        title: newValue,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                    ),
                    TextFormField(
                      initialValue:
                          _editedProduct.price == null ? null : _editedProduct.price.toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_descriptionFocusNode),
                      validator: (value) => (value.isEmpty || double.parse(value) < 0)
                          ? 'Won\'t want to sell this for free, right?'
                          : null,
                      onSaved: (newValue) => _editedProduct = Product(
                        price: double.parse(newValue),
                        description: _editedProduct.description,
                        id: _editedProduct.description,
                        imageUrl: _editedProduct.description,
                        title: _editedProduct.title,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                    ),
                    TextFormField(
                      initialValue: _editedProduct.description,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) =>
                          value.isEmpty ? 'You know you can\'t leave this empty...' : null,
                      onSaved: (newValue) => _editedProduct = Product(
                        price: _editedProduct.price,
                        description: newValue,
                        id: _editedProduct.description,
                        imageUrl: _editedProduct.description,
                        title: _editedProduct.title,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _editedProduct.imageUrl,
                            decoration: InputDecoration(labelText: 'Image URL'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm,
                            validator: (value) => (value.isEmpty || !value.startsWith('http'))
                                ? 'A man\'s gotta see a pic'
                                : null,
                            onSaved: (newValue) => _editedProduct = Product(
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              id: _editedProduct.description,
                              imageUrl: newValue,
                              title: _editedProduct.title,
                              isFavorite: _editedProduct.isFavorite,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
