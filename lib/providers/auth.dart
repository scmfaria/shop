import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/firebase_exception.dart';


class Auth with ChangeNotifier {
  DateTime _expireDate;
  String _token;
  String _userId;

  String get token {
    if(_token != null && _expireDate != null && _expireDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  String get userId {
    return isAuth ? _userId : null;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDkmJwNuu7FJ5xU2kmuGvn2z8Bv-RyV-1s';

    final response = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      })
    );

    final responseBody = json.decode(response.body);

    if(responseBody['error'] != null) {
      throw FirebaseException(responseBody['error']['message']);
    } else {
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}