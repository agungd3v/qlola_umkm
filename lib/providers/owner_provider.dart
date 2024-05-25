import 'package:flutter/material.dart';

class OwnerProvider extends ChangeNotifier {
  List _employees = [];
  List _products = [];

  List get employees => _employees;
  List get products => _products;

  set init_employee(List param) {
    _employees = param;
    notifyListeners();
  }

  set add_employee(dynamic param) {
    _employees.add(param);
    notifyListeners();
  }

  set remove_employee(Map<String, dynamic> param) {
    _employees.removeWhere((data) => data["id"] == param["id"]);
    notifyListeners();
  }

  set init_product(List param) {
    _products = param;
    notifyListeners();
  }

  set add_product(dynamic param) {
    _products.add(param);
    notifyListeners();
  }

  set remove_product(Map<String, dynamic> param) {
    _products.removeWhere((data) => data["id"] == param["id"]);
    notifyListeners();
  }

  void reset() {
    _employees = [];
    _products = [];

    notifyListeners();
  }
}