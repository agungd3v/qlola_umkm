import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:qlola_umkm/utils/log.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';

class PrinterHelper {
  static Future<Map<String, dynamic>> sendToPrinter({required List<int> bytes, int delayWrite = 1, int delayRetry = 2, bool reconnect = true}) async {
    final macRaw = localStorage.getItem("printer_mac");
    final mac = macRaw?.toString() ?? "";

    if (mac.isEmpty) {
      await GlobalLogger.logPrinter("error", "MAC printer kosong (PrinterHelper)");
      return {"status": false, "message": "Alamat MAC printer belum disimpan"};
    }

    try {
      final connected = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
      if (!connected) {
        await GlobalLogger.logPrinter("error", "Gagal connect printer (PrinterHelper)");
        return {"status": false, "message": "Gagal menghubungkan ke printer"};
      }

      await Future.delayed(Duration(seconds: delayWrite));
      final result = await PrintBluetoothThermal.writeBytes(bytes);

      if (!result && reconnect) {
        await GlobalLogger.logPrinter("warning", "Gagal kirim byte, coba reconnect (PrinterHelper)");
        await PrintBluetoothThermal.disconnect;
        await Future.delayed(Duration(seconds: delayRetry));

        final retryConnect = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
        if (retryConnect) {
          final retryResult = await PrintBluetoothThermal.writeBytes(bytes);
          if (retryResult) {
            await GlobalLogger.logPrinter("info", "Berhasil kirim byte setelah reconnect (PrinterHelper)");
            return {"status": true, "message": ""};
          } else {
            await GlobalLogger.logPrinter("error", "Gagal kirim setelah reconnect (PrinterHelper)");
            return {"status": false, "message": "Gagal print ulang setelah reconnect"};
          }
        } else {
          await GlobalLogger.logPrinter("error", "Gagal reconnect ke printer (PrinterHelper)");
          return {"status": false, "message": "Gagal reconnect ke printer"};
        }
      }

      return {"status": result, "message": result ? "" : "Gagal mengirim data ke printer"};

    } catch (e) {
      await GlobalLogger.logPrinter("exception", "PrinterHelper exception: $e");
      return {"status": false, "message": "Error saat mencetak: $e"};
    } finally {
      await PrintBluetoothThermal.disconnect;
    }
  }
}
