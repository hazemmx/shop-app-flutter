import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryTime;
  late String userID;

  Future<void> signUP(String email, String pass) async {
    const urlString =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyDw08S6KM9kgDvqQzNCyyffCYz2gqblNk4";
    Uri uri = Uri.parse(urlString);
    final response = await http.post(uri,
        body: json.encode(
            {'email': email, 'password': pass, 'returnSecureToken': true}));
  }
}
