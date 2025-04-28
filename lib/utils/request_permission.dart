import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

Future<bool> ensureBluetoothPermission() async {
  final bluetoothScan = await Permission.bluetoothScan.status;
  final bluetoothConnect = await Permission.bluetoothConnect.status;

  if (bluetoothScan.isGranted && bluetoothConnect.isGranted) {
    return true;
  }

  return false;
}

Future<bool> ensureLocationPermission() async {
  final location = await Permission.location.status;

  if (location.isGranted) {
    return true;
  }

  return false;
}

Future checkPermissionBluetooth() async {
  if (Platform.isAndroid) {
    final bluetoothPermission = await ensureBluetoothPermission();
    final locationPermission = await ensureLocationPermission();

    if (bluetoothPermission && locationPermission) { 
      final requestPermissions = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      if (
        requestPermissions[Permission.location]?.isGranted != true ||
        requestPermissions[Permission.bluetoothScan]?.isGranted != true ||
        requestPermissions[Permission.bluetoothConnect]?.isGranted != true
      ) {
        return <String, dynamic> {
          "status": false,
          "message": "Mohon untuk mengaktifkan semua permission yang di minta"
        };
      }

      return <String, dynamic> {
        "status": true,
        "message": ""
      };
    } else {
      return <String, dynamic> {
        "status": true,
        "message": ""
      };
    }

  } else {
    return <String, dynamic> {
      "status": false,
      "message": "Error, request permission"
    };
  }
}