import 'package:flutter/material.dart';

class CheckoutProvider extends ChangeNotifier {
  List _carts = [];
  num _cart_total = 0;

  List get carts => _carts;
  num get cart_total => _cart_total;

  set set_carts(Map<String, dynamic> param) {
    _cart_total = 0;

    if (_carts.any((item) => item["id"] == param["id"])) {
      param["quantity"] += _carts[_carts.indexWhere((item) => item["id"] == param["id"])]["quantity"];
      _carts[_carts.indexWhere((item) => item["id"] == param["id"])] = param;
    } else {
      _carts.add(param);
    }

    for (var index = 0; index < _carts.length; index++) {
      _cart_total += double.parse(_carts[index]["product_price"]) * _carts[index]["quantity"];
    }

    notifyListeners();
  }
}