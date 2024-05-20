import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class AuthProvider extends ChangeNotifier {
  dynamic _user = null;
  String _token = "";

  dynamic get user => _user;
  String get token => _token;

  set set_user(dynamic param) {
    _user = param;
    notifyListeners();
  }

  set set_token(String param) {
    _token = param;
    notifyListeners();
  }

  AuthProvider() {
    final userStorage = localStorage.getItem("user");
    final tokenStorage = localStorage.getItem("token");
    _user = jsonDecode(userStorage.toString());
    _token = tokenStorage.toString();

    notifyListeners();
  }
}