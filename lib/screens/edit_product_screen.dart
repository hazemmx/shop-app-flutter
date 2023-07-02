import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _imageURLfocusnode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: "", title: "", description: "", price: 0, imageUrl: "");
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void dispose() {
    // TODO: implement dispose
    _imageURLfocusnode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _imageURLfocusnode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageURLfocusnode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _imageURLfocusnode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productID = ModalRoute.of(context)!.settings.arguments as String?;
      if (productID != null && productID.isNotEmpty) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findbyID(productID);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageURLController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    if (_editedProduct.id != "") {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addproduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initValues['title'],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide a proper title. ";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: newValue.toString(),
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Price"),
                  initialValue: _initValues['price'],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    // double x = double.parse(value.toString());
                    if (value!.isEmpty) {
                      return "Please provide a price. ";
                    }
                    if (double.tryParse(value.toString()) == null) {
                      return "Please enter a vaild number .";
                    }
                    if (double.parse(value.toString()) <= 0) {
                      return "Insert a number bigger than 0";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(newValue.toString()),
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  initialValue: _initValues['description'],
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: _editedProduct.title,
                        description: newValue.toString(),
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide a proper description. ";
                    }
                    if (value.toString().length < 10) {
                      return "Minimum 10 Characters are required. ";
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: _imageURLController.text.isEmpty
                            ? const Text("Enter a URL")
                            : FittedBox(
                                child: Image.network(_imageURLController.text),
                                fit: BoxFit.cover,
                              )),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: "ImageURL"),
                        // initialValue: _imageURLController.text,
                        keyboardType: TextInputType.url,
                        controller: _imageURLController,
                        textInputAction: TextInputAction.done,
                        focusNode: _imageURLfocusnode,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: newValue.toString());
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please provide a proper URL. ";
                          }
                          if (!_imageURLController.text.startsWith("https") &&
                              !_imageURLController.text.startsWith("http")) {
                            return "Please provide a proper URL start. ";
                          }
                          if (!_imageURLController.text.endsWith("png") &&
                              !_imageURLController.text.endsWith("jpg") &&
                              !_imageURLController.text.endsWith("jpeg")) {
                            return "Please provide a proper URL end. ";
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
