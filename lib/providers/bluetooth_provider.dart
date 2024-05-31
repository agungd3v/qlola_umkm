import 'package:flutter/material.dart';

class BluetoothProvider extends ChangeNotifier {
  bool _status = false;
  String _macAddress = "";

  bool get status => _status;
  String get macAddress => _macAddress;

  set set_status(bool param) {
    _status = param;

    notifyListeners();
  }

  set set_mac_address(String param) {
    _macAddress = param;

    notifyListeners();
  }
}