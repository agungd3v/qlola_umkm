import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:localstorage/localstorage.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:qlola_umkm/utils/log.dart';
import 'package:qlola_umkm/utils/request_permission.dart';

Future<Map<String, dynamic>> testGenerateStruck() async {
  final bluetoothOn = await FlutterBluePlus.isOn;
  if (!bluetoothOn) {
    await GlobalLogger.logPrinter("error", "Bluetooth tidak aktif saat test print");
    return {"status": false, "message": "Bluetooth tidak aktif"};
  }

  final checkPermission = await checkPermissionBluetooth();
  if (!checkPermission["status"]) {
    await GlobalLogger.logPrinter("error", "Izin bluetooth ditolak saat test print");
    return {"status": false, "message": "Izin bluetooth ditolak"};
  }

  final macRaw = localStorage.getItem("printer_mac");
  final mac = macRaw?.toString() ?? "";
  if (mac.isEmpty) {
    await GlobalLogger.logPrinter("error", "MAC printer kosong saat test print");
    return {"status": false, "message": "Alamat MAC printer belum disimpan"};
  }

  final connected = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
  if (!connected) {
    await GlobalLogger.logPrinter("error", "Gagal connect ke printer saat test print: $mac");
    return {"status": false, "message": "Gagal menghubungkan ke printer"};
  }

  try {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    List<int> bytes = [];
    bytes += generator.text("TEST CETAK", styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text("Struk ini hanya untuk test", styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(3);
    bytes += generator.cut();

    final result = await PrintBluetoothThermal.writeBytes(bytes);
    await GlobalLogger.logPrinter("info", "Kirim byte awal (test): $result");

    if (!result) {
      await GlobalLogger.logPrinter("warning", "Gagal kirim byte test, coba reconnect");

      await PrintBluetoothThermal.disconnect;
      await Future.delayed(Duration(seconds: 2));

      final retry = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
      if (retry) {
        await PrintBluetoothThermal.writeBytes(bytes);
        await GlobalLogger.logPrinter("info", "Test print berhasil setelah reconnect");
      } else {
        await GlobalLogger.logPrinter("error", "Gagal reconnect saat test print");
        return {"status": false, "message": "Test print gagal setelah reconnect"};
      }
    }

    await PrintBluetoothThermal.disconnect;
    return {"status": true, "message": ""};

  } catch (e) {
    await PrintBluetoothThermal.disconnect;
    await GlobalLogger.logPrinter("exception", "Exception: $e");
    return {"status": false, "message": "Gagal test print: $e"};
  }
}

Future<Map<String, dynamic>> generateStruck(CheckoutProvider checkout_provider, AuthProvider auth_provider, String transaction_code) async {
  final bluetoothOn = await FlutterBluePlus.isOn;

  if (!bluetoothOn) {
    await GlobalLogger.logPrinter("error", "Bluetooth tidak aktif");
    return {"status": false, "message": "Bluetooth tidak aktif"};
  }

  final checkPermission = await checkPermissionBluetooth();
  if (!checkPermission["status"]) {
    await GlobalLogger.logPrinter("error", "Permission bluetooth ditolak");
    return {"status": false, "message": "Izin Bluetooth ditolak"};
  }

  final macRaw = localStorage.getItem("printer_mac");
  final mac = macRaw?.toString() ?? "";
  if (mac.isEmpty) {
    await GlobalLogger.logPrinter("error", "MAC Address printer kosong");
    return {"status": false, "message": "Alamat MAC printer tidak ditemukan"};
  }

  final isConnected = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
  if (!isConnected) {
    await GlobalLogger.logPrinter("error", "Gagal connect ke printer $mac");
    return {"status": false, "message": "Gagal menghubungkan ke printer"};
  }

  try {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    List<int> bytes = [];

    // Header
    bytes += generator.text(
      auth_provider.user["outlet"]["business"]["business_name"],
      styles: PosStyles(
        bold: true,
        align: PosAlign.center,
        width: PosTextSize.size1,
        height: PosTextSize.size2,
      ),
    );
    bytes += generator.text(
      auth_provider.user["outlet"]["outlet_name"],
      styles: PosStyles(align: PosAlign.center),
    );
    bytes += generator.feed(1);
    bytes += generator.text('----------------------------');

    // Info kasir
    bytes += generator.row([
      PosColumn(text: "Kasir", width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: auth_provider.user["name"], width: 8, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: "Waktu", width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: getDateTimeNow(), width: 8, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: "No. Struk", width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: transaction_code, width: 8, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: "Pembayaran", width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: "Tunai", width: 8, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.text('--------------------------------');

    // Daftar produk
    for (var item in checkout_provider.carts) {
      bytes += generator.row([
        PosColumn(text: item["product_name"], width: 12),
      ]);
      bytes += generator.row([
        PosColumn(
          text: "${transformPrice(double.parse(item["product_price"].toString()))} x ${item["quantity"]}",
          width: 6,
        ),
        PosColumn(
          text: transformPrice(double.parse(item["product_price"].toString()) * item["quantity"]),
          width: 6,
          styles: PosStyles(align: PosAlign.right),
        )
      ]);
    }

    bytes += generator.text('--------------------------------');

    bytes += generator.row([
      PosColumn(text: "Total", width: 6, styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
        text: transformPrice(checkout_provider.cart_total),
        width: 6,
        styles: PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += generator.feed(3);
    bytes += generator.text("Terimakasih ^_^", styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(1);
    bytes += generator.cut();

    final result = await PrintBluetoothThermal.writeBytes(bytes);
    await GlobalLogger.logPrinter("info", "Kirim byte awal: $result");

    if (!result) {
      await GlobalLogger.logPrinter("warning", "Kirim byte gagal, coba reconnect");

      await PrintBluetoothThermal.disconnect;
      await Future.delayed(Duration(seconds: 2));

      final retry = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
      if (retry) {
        await PrintBluetoothThermal.writeBytes(bytes);
        await GlobalLogger.logPrinter("info", "Berhasil print setelah reconnect");
      } else {
        await GlobalLogger.logPrinter("error", "Gagal reconnect setelah kirim data gagal");
        return {"status": false, "message": "Gagal print ulang setelah reconnect"};
      }
    }

    await PrintBluetoothThermal.disconnect;
    return {"status": true, "message": ""};

  } catch (e) {
    await PrintBluetoothThermal.disconnect;
    await GlobalLogger.logPrinter("exception", "Exception: $e");
    return {"status": false, "message": "Gagal mencetak: $e"};
  }
}
