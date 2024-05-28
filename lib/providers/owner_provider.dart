import 'package:flutter/material.dart';

class OwnerProvider extends ChangeNotifier {
  List _employees = [];
  List _products = [];
  Map<String, String> _reportDate = {"label": "Hari ini", "value": DateTime.now().toString().split(" ")[0]};

  List get employees => _employees;
  List get products => _products;
  Map<String, String> get reportDate => _reportDate;

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

  set set_report_date(Map<String, String> param) {
    _reportDate = param;
    notifyListeners();
  }

  void reset() {
    _employees = [];
    _products = [];
    _reportDate = {"label": "Hari ini", "value": DateTime.now().toString().split(" ")[0]};

    notifyListeners();
  }
}