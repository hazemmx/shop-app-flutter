import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';

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

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please provide a proper value. ";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: "",
                        title: newValue.toString(),
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Price"),
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
                        id: "",
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(newValue.toString()),
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: "",
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
                        margin: EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: _imageURLController.text.isEmpty
                            ? Text("Enter a URL")
                            : FittedBox(
                                child: Image.network(_imageURLController.text),
                                fit: BoxFit.cover,
                              )),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "ImageURL"),
                        keyboardType: TextInputType.url,
                        controller: _imageURLController,
                        textInputAction: TextInputAction.done,
                        focusNode: _imageURLfocusnode,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: "",
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
