import 'dart:developer';
import 'dart:io';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/global_function.dart';

Future<bool> generateStruck(CheckoutProvider checkout_provider, AuthProvider auth_provider, String transaction_code) async {
  List<int> bytes = [];

  if (Platform.isAndroid) {
      final response = await [Permission.bluetoothScan, Permission.bluetoothConnect].request();

      if (response[Permission.bluetoothScan]?.isGranted == true && response[Permission.bluetoothConnect]?.isGranted == true) {
      final checkConnect = await PrintBluetoothThermal.connect(macPrinterAddress: "66:32:13:C1:9E:2A");
      if (checkConnect) {
        try {
          final profile = await CapabilityProfile.load();
          final generator = Generator(PaperSize.mm58, profile);

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
          bytes += generator.text('--------------------------------');

          bytes += generator.row([
            PosColumn(
              text: "Kasir",
              width: 6,
              styles: PosStyles(
                align: PosAlign.left
              )
            ),
            PosColumn(
              text: auth_provider.user["name"],
              width: 6,
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
              width: 6,
              styles: PosStyles(
                align: PosAlign.left
              )
            ),
            PosColumn(
              text: transaction_code,
              width: 6,
              styles: PosStyles(
                align: PosAlign.right
              )
            )
          ]);
          bytes += generator.row([
            PosColumn(
              text: "Pembayaran",
              width: 6,
              styles: PosStyles(
                align: PosAlign.left
              )
            ),
            PosColumn(
              text: "Tunai",
              width: 6,
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
              text: "${transformPrice(double.parse(checkout_provider.carts[index]["product_price"]))} x ${checkout_provider.carts[index]["quantity"]}",
              width: 6,
              styles: PosStyles(
                align: PosAlign.left
              )
            ),
            PosColumn(
              text: transformPrice(double.parse(checkout_provider.carts[index]["product_price"]) * checkout_provider.carts[index]["quantity"]),
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

          return true;
        } catch (e) {
          inspect(e);

          await PrintBluetoothThermal.disconnect;
          return true;
        }
      }

      await PrintBluetoothThermal.disconnect;
      return true;
    }
  }

  await PrintBluetoothThermal.disconnect;
  return true;
}