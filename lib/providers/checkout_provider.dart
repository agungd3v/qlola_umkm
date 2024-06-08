import 'package:flutter/material.dart';

class CheckoutProvider extends ChangeNotifier {
  List _carts = [];

  List get carts => _carts;

  num get cart_total {
    num total = 0;
    for (var index = 0; index < _carts.length; index++) {
      total += double.parse(_carts[index]["product_price"].toString()) * _carts[index]["quantity"];
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

  set remove_item_carts(dynamic param) {
    _carts.removeWhere((item) => item["id"] == param);

    notifyListeners();
  }

  void reset() {
    _carts = [];
    notifyListeners();
  }
}