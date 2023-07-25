import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryTime;
  late String _userID;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryTime != null &&
        _expiryTime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String pass, String urlSegment) async {
    final urlString =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDw08S6KM9kgDvqQzNCyyffCYz2gqblNk4";
    Uri uri = Uri.parse(urlString);
    try {
      final response = await http.post(uri,
          body: json.encode(
              {'email': email, 'password': pass, 'returnSecureToken': true}));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryTime = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUP(String email, String pass) async {
    return _authenticate(email, pass, 'signUp');
  }

  Future<void> Login(String email, String pass) async {
    return _authenticate(email, pass, 'signInWithPassword');
  }
}
