import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class CheckoutProvider extends ChangeNotifier {
  List _carts = [];
  String _macAddress = "";
  int _ordering = 1;

  List get carts => _carts;
  String get macAddress => _macAddress;
  int get ordering => _ordering;

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

  set set_mac_address(String param) {
    _macAddress = param;

    notifyListeners();
  }

  set set_ordering(int param) {
    _ordering = param;

    notifyListeners();
  }

  void reset() {
    _carts = [];
    notifyListeners();
  }

  CheckoutProvider() {
    final macRaw = localStorage.getItem("printer_mac");
    _macAddress = macRaw?.toString() ?? "";

    final nowDay = DateTime.now().day.toString();
    final isDate = localStorage.getItem("date_now");
    final isOrder = localStorage.getItem("ordering");

    if (isDate != null && isDate == nowDay) {
      _ordering = int.tryParse(isOrder ?? "1") ?? 1;
    } else {
      localStorage.setItem("date_now", nowDay);
      localStorage.setItem("ordering", "1");
      _ordering = 1;
    }

    notifyListeners();
  }
}