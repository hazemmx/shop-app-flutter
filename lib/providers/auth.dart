import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryTime;
  late String userID;

  Future<void> _authenticate(
      String email, String pass, String urlSegment) async {
    final urlString =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDw08S6KM9kgDvqQzNCyyffCYz2gqblNk4";
    Uri uri = Uri.parse(urlString);
    final response = await http.post(uri,
        body: json.encode(
            {'email': email, 'password': pass, 'returnSecureToken': true}));
    print(json.decode(response.body));
  }

  Future<void> signUP(String email, String pass) async {
    return _authenticate(email, pass, 'signUp');
  }

  Future<void> Login(String email, String pass) async {
    return _authenticate(email, pass, 'signInWithPassword');
  }
}
