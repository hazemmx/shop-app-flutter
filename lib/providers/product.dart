import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart%20';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
  Future<void> toggleFavouriteStatus() async {
    final urlString =
        'https://shop-app-test-315b9-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';
    Uri uri = Uri.parse(urlString);
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    try {
      final response =
          await http.patch(uri, body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }

    notifyListeners();
  }
}
