import 'package:flutter/material.dart';

DateTime dateNow = DateTime.now();

class OwnerProvider extends ChangeNotifier {
  List _employees = [];
  List _products = [];
  Map<String, String> _reportDate = {"id": "", "label": "Hari ini", "value": "${dateNow.toString().split(" ")[0]} - ${DateTime(dateNow.year, dateNow.month, dateNow.day + 1).toString().split(" ")[0]}"};
  Map<String, dynamic> _reportOutlet = {"label": "Semua Outlet", "value": null};
  dynamic _productEdit = null;

  List get employees => _employees;
  List get products => _products;
  Map<String, String> get reportDate => _reportDate;
  Map<String, dynamic> get reportOutlet => _reportOutlet;
  dynamic get productEdit => _productEdit;

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

  set set_report_outlet(Map<String, dynamic> param) {
    _reportOutlet = param;
    notifyListeners();
  }

  set set_product_edit(dynamic param) {
    _productEdit = param;
    notifyListeners();
  }

  void reset() {
    _employees = [];
    _products = [];
    _reportDate = {"label": "Hari ini", "value": "${dateNow.toString().split(" ")[0]} - ${DateTime(dateNow.year, dateNow.month, dateNow.day + 1).toString().split(" ")[0]}"};
    _reportOutlet = {"label": "Semua Outlet", "value": null};

    notifyListeners();
  }
}