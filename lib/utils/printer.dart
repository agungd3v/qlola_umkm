import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:qlola_umkm/helpers/helper_printer.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
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

  try {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    List<int> bytes = [];
    bytes += generator.text("TEST CETAK", styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text("Struk ini hanya untuk tes", styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(3);
    bytes += generator.cut();

    final result = await PrinterHelper.sendToPrinter(bytes: bytes);
    return result;
  } catch (e) {
    await GlobalLogger.logPrinter("exception", "PrinterUtils exception: $e");
    return {"status": false, "message": "Gagal test print: $e"};
  }
}

Future<Map<String, dynamic>> generateStruck(dynamic checkout, AuthProvider auth_provider, String transaction_code) async {
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
    bytes += generator.text('--------------------------------');

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

    // Produk
    for (var item in checkout["checkouts"]) {
      bytes += generator.row([
        PosColumn(text: item["product"]["product_name"], width: 12),
      ]);
      bytes += generator.row([
        PosColumn(
          text: "${transformPrice(double.parse(item["product"]["product_price"].toString()))} x${item["quantity"]}",
          width: 6,
        ),
        PosColumn(
          text: transformPrice(double.parse(item["product"]["product_price"].toString()) * item["quantity"]),
          width: 6,
          styles: PosStyles(align: PosAlign.right),
        )
      ]);
    }
    // Produk
    for (var item in checkout["others"]) {
      bytes += generator.row([
        PosColumn(text: item["product_name"], width: 12),
      ]);
      bytes += generator.row([
        PosColumn(
          text: "${transformPrice(double.parse(item["product_price"].toString()))} x${item["quantity"]}",
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
        text: transformPrice(checkout["grand_total"]),
        width: 6,
        styles: PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += generator.feed(3);
    bytes += generator.text("Terimakasih ^_^", styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(1);
    bytes += generator.cut();

    final result = await PrinterHelper.sendToPrinter(bytes: bytes);
    return result;
  } catch (e) {
    await GlobalLogger.logPrinter("exception", "Exception saat generate print: $e");
    return {"status": false, "message": "Gagal mencetak: $e"};
  }
}

Future<Map<String, dynamic>> generateStruckKichen(dynamic checkout, AuthProvider auth_provider, String transaction_code) async {
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

  try {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    List<int> bytes = [];

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
      PosColumn(text: checkout["transaction_code"], width: 8, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.text('--------------------------------');
    bytes += generator.feed(1);

    bytes += generator.text(
      "Pesanan",
      styles: PosStyles(
        bold: true,
        align: PosAlign.center,
        width: PosTextSize.size1,
        height: PosTextSize.size2,
      ),
    );

    bytes += generator.feed(1);

    // Produk
    for (var item in checkout["checkouts"]) {
      bytes += generator.row([
        PosColumn(
          text: "${item["product"]["product_name"]} x${item["quantity"]}",
          width: 12
        ),
      ]);
    }
    // Produk Others
    for (var item in checkout["others"]) {
      bytes += generator.row([
        PosColumn(
          text: "${item["product_name"]} x${item["quantity"]}",
          width: 12
        ),
      ]);
    }

    bytes += generator.cut();

    final result = await PrinterHelper.sendToPrinter(bytes: bytes);
    return result;
  } catch (e) {
    await GlobalLogger.logPrinter("exception", "Exception saat generate print: $e");
    return {"status": false, "message": "Gagal mencetak: $e"};
  }
}
