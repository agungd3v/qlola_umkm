import 'dart:io';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:qlola_umkm/utils/request_permission.dart';

Future testGenerateStruck() async {
  final mac = localStorage.getItem("printer_mac");
  List<int> bytes = [];

  if (Platform.isAndroid) {
    final response = await [Permission.bluetoothScan, Permission.bluetoothConnect].request();

    if (response[Permission.bluetoothScan]?.isGranted == true && response[Permission.bluetoothConnect]?.isGranted == true) {
      final checkConnect = await PrintBluetoothThermal.connect(macPrinterAddress: mac ?? "");
      if (checkConnect) {
        try {
          final profile = await CapabilityProfile.load();
          final generator = Generator(PaperSize.mm58, profile);

          bytes += generator.feed(10);
          bytes += generator.cut();

          await PrintBluetoothThermal.writeBytes(bytes);
          await PrintBluetoothThermal.disconnect;

          return {
            "status": true,
            "message": "Testing print berhasil"
          };
        } catch (e) {
          await PrintBluetoothThermal.disconnect;

          return {
            "status": false,
            "message": e.toString()
          };
        }
      } else {
        await PrintBluetoothThermal.disconnect;

        return {
          "status": false,
          "message": "MAC Address tidak ditemukan, cek kembali mac address yang ditulis!"
        };
      }
    }
  }
}

Future generateStruck(CheckoutProvider checkout_provider, AuthProvider auth_provider, String transaction_code) async {
  final bluetoothOn = await FlutterBluePlus.isOn;

  if (bluetoothOn) {
    final checkPermission = await checkPermissionBluetooth();

    if (checkPermission["status"]) {
      final macRaw = localStorage.getItem("printer_mac");
      final mac = macRaw?.toString() ?? "";

      if (mac.isEmpty) {
        return <String, dynamic> {
          "status": false,
          "message": "Alamat MAC printer tidak ditemukan. Silahkan pilih printer terlebih dahulu."
        };
      }

      final checkConnect = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
      if (!checkConnect) {
        return {
          "status": false,
          "message": "Gagal menghubungkan ke printer. Pastikan printer menyala dan dalam jangkauan."
        };
      }

      try {
        final profile = await CapabilityProfile.load();
        final generator = Generator(PaperSize.mm58, profile);

        List<int> bytes = [];

        bytes += generator.text(
          auth_provider.user["outlet"]["business"]["business_name"],
          styles: PosStyles(
            bold: true,
            align: PosAlign.center,
            width: PosTextSize.size1,
            height: PosTextSize.size2
          )
        );
        bytes += generator.text(
          auth_provider.user["outlet"]["outlet_name"],
          styles: PosStyles(
            align: PosAlign.center
          )
        );

        bytes += generator.feed(1);
        bytes += generator.text('----------------------------');

        bytes += generator.row([
          PosColumn(
            text: "Kasir",
            width: 4,
            styles: PosStyles(
              align: PosAlign.left
            )
          ),
          PosColumn(
            text: auth_provider.user["name"],
            width: 8,
            styles: PosStyles(
              align: PosAlign.right
            )
          )
        ]);
        bytes += generator.row([
          PosColumn(
            text: "Waktu",
            width: 4,
            styles: PosStyles(
              align: PosAlign.left
            )
          ),
          PosColumn(
            text: getDateTimeNow(),
            width: 8,
            styles: PosStyles(
              align: PosAlign.right
            )
          )
        ]);
        bytes += generator.row([
          PosColumn(
            text: "No. Struk",
            width: 4,
            styles: PosStyles(
              align: PosAlign.left
            )
          ),
          PosColumn(
            text: transaction_code,
            width: 8,
            styles: PosStyles(
              align: PosAlign.right
            )
          )
        ]);
        bytes += generator.row([
          PosColumn(
            text: "Pembayaran",
            width: 4,
            styles: PosStyles(
              align: PosAlign.left
            )
          ),
          PosColumn(
            text: "Tunai",
            width: 8,
            styles: PosStyles(
              align: PosAlign.right
            )
          )
        ]);

        bytes += generator.text('--------------------------------');

        for (var index = 0; index < checkout_provider.carts.length; index++) {
          bytes += generator.row([
            PosColumn(
              text: checkout_provider.carts[index]["product_name"],
              width: 12,
              styles: PosStyles(
                align: PosAlign.left
              )
            )
          ]);
          bytes += generator.row([
            PosColumn(
              text: "${transformPrice(double.parse(checkout_provider.carts[index]["product_price"].toString()))} x ${checkout_provider.carts[index]["quantity"]}",
              width: 6,
              styles: PosStyles(
                align: PosAlign.left
              )
            ),
            PosColumn(
              text: transformPrice(double.parse(checkout_provider.carts[index]["product_price"].toString()) * checkout_provider.carts[index]["quantity"]),
              width: 6,
              styles: PosStyles(
                align: PosAlign.right
              )
            )
          ]);
        }

        bytes += generator.text('--------------------------------');

        bytes += generator.row([
          PosColumn(
            text: "Total",
            width: 6,
            styles: PosStyles(
              align: PosAlign.left,
              bold: true
            )
          ),
          PosColumn(
            text: transformPrice(checkout_provider.cart_total),
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              bold: true
            )
          )
        ]);

        bytes += generator.feed(3);

        bytes += generator.text(
          "Terimakasih ^_^",
          styles: PosStyles(
            align: PosAlign.center
          )
        );

        bytes += generator.feed(1);
        bytes += generator.cut();

        await PrintBluetoothThermal.writeBytes(bytes);
        await PrintBluetoothThermal.disconnect;

        return <String, dynamic> {
          "status": true,
          "message": ""
        };
      } catch (e) {
        await PrintBluetoothThermal.disconnect;

        return <String, dynamic> {
          "status": false,
          "message": "Gagal, $e"
        };
      }
    }
  }

  return <String, dynamic> {
    "status": false,
    "message": "Gagal, pastikan bluetooth kamu menyala."
  };
}