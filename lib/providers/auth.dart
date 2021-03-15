import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/firebase_exception.dart';


class Auth with ChangeNotifier {
  DateTime _expireDate;
  String _token;
  String _userId;
  Timer _logoutTimer;

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

      Store.saveMap('userData', {
        "token": _token,
        "userId": _userId,
        "expiryDate": _expireDate.toIso8601String(),
      });

      _autoLogout();
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

  Future<void> tryAutoLogin() async {
    if(isAuth) {
      return Future.value();
    }

    final userData = await Store.getMap('userData');
    if(userData == null) {
      return Future.value();
    }

    final expiryDate = DateTime.parse(userData["expiryDate"]);

    if(expiryDate.isBefore(DateTime.now())) {
      return Future.value();
    }

    _token = userData['token'];
    _userId = userData['userId'];
    _expireDate = expiryDate;

    _autoLogout();
    notifyListeners();
    return Future.value();
  }

  void logout() {
    _token = null;
    _userId = null;
    _expireDate = null;

    if(_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }

    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if(_logoutTimer != null) {
      _logoutTimer.cancel();
    }

    final timeToLogout = _expireDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }
}