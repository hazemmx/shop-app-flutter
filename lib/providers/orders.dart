import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSet() async {
    const urlstring =
        'https://shop-app-test-315b9-default-rtdb.europe-west1.firebasedatabase.app/orders.json';
    Uri uri = Uri.parse(urlstring);
    final response = await http.get(uri);

    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      // Handle the case where there are no orders yet
      return;
    }

    extractedData.forEach((orderID, orderData) {
      // Convert the list of products from JSON to a List<CartItem>
      final List<CartItem> cartProducts =
          (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList();

      loadedOrders.add(OrderItem(
        id: orderID,
        amount: orderData['amount'],
        products: cartProducts,
        dateTime: DateTime.parse(orderData['dateTime']),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    const urlstring =
        'https://shop-app-test-315b9-default-rtdb.europe-west1.firebasedatabase.app/orders.json';
    Uri uri = Uri.parse(urlstring);
    // final List productNamesOrIds =
    //   cartProducts.map((cartItem) => cartItem.getProductNameID()).toList();
    final List<Map<String, dynamic>> cartProductData =
        cartProducts.map((cp) => cp.toJson()).toList();

    final response = await http.post(uri,
        body: json.encode({
          'amount': total,
          'products': cartProductData,
          'dateTime': timestamp.toIso8601String(),
        }));

    final newOrder = OrderItem(
      id: json.decode(response.body)['name'],
      amount: total,
      dateTime: timestamp,
      products: cartProducts,
    );
    _orders.insert(0, newOrder);

    notifyListeners();
  }
}
