import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class CheckoutProvider extends ChangeNotifier {
  List _carts = [];
  Map<String, dynamic> _printer = {"status": false, "name": "", "mac": ""};

  List get carts => _carts;
  Map<String, dynamic> get printer => _printer;

  num get cart_total {
    num total = 0;
    for (var index = 0; index < _carts.length; index++) {
      total += double.parse(_carts[index]["product_price"]) * _carts[index]["quantity"];
    }

    return total;
  }

  set set_carts(Map<String, dynamic> param) {
    if (_carts.any((item) => item["id"] == param["id"])) {
      param["quantity"] += _carts[_carts.indexWhere((item) => item["id"] == param["id"])]["quantity"];
      _carts[_carts.indexWhere((item) => item["id"] == param["id"])] = param;
    } else {
      _carts.add(param);
    }

    notifyListeners();
  }

  set set_printer(Map<String, dynamic> param) {
    _printer = param;

    notifyListeners();
  }

  CheckoutProvider() {
    final printerNameStorage = localStorage.getItem("printer_name");
    final printerMacStorage = localStorage.getItem("printer_mac");

    if (printerNameStorage != null && printerMacStorage != null) {
      _printer = {
        "status": true,
        "name": printerNameStorage,
        "mac": printerMacStorage
      };
    }

    notifyListeners();
  }

  void reset() {
    _carts = [];
    notifyListeners();
  }
}