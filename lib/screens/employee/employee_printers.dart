import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/request_permission.dart';

class EmployeePrintersScreen extends StatefulWidget {
  const EmployeePrintersScreen({super.key});

  @override
  State<EmployeePrintersScreen> createState() => _EmployeePrintersScreenState();
}

class _EmployeePrintersScreenState extends State<EmployeePrintersScreen> {
  List<ScanResult> scanResults = [];
  bool scanning = true;
  bool bluetoothOn = true;

  void startScan() async {
    final isBluetoothOn = await FlutterBluePlus.isOn;
    if (isBluetoothOn) {
      final checkPermission = await checkPermissionBluetooth();

      if (checkPermission["status"]) {
        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

        FlutterBluePlus.scanResults.listen((results) {
          if (!mounted) return;
          setState(() => scanResults = results);
        });

        Future.delayed(Duration(seconds: 5), () {
          if (!mounted) return;

          List<ScanResult> results = [];

          for (var r in scanResults) {
            if (r.device.name != "") {
              results.add(r);
            }
          }

          setState(() {
            scanning = false;
            scanResults = results;
          });

          FlutterBluePlus.stopScan();
        });
      } else {
        Flushbar(
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 3),
          reverseAnimationCurve: Curves.fastOutSlowIn,
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text(
            "Bluetooth connection",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 12
            )
          ),
          messageText: Text(
            "Mohon untuk mengaktifkan semua permission yang di minta.",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontSize: 12
            )
          )
        ).show(context);
      }
    } else {
      setState(() {
        bluetoothOn = false;
        scanning = false;
      });
    }
  }

  void connectToDevice(String mac, BuildContext context) async {
    try {
      if (mac != "") {
        final checkoutProvider = Provider.of<CheckoutProvider>(context);

        checkoutProvider.set_mac_address = mac;
        localStorage.setItem("printer_mac", mac);
        context.pop();
      } else {
        Flushbar(
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 3),
          reverseAnimationCurve: Curves.fastOutSlowIn,
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text(
            "Koneksi printer gagal",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 12
            )
          ),
          messageText: Text(
            "Terjadi kesalahan saat mengkoneksikan printer",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontSize: 12
            )
          ),
        ).show(context);
      }
    } catch (e) {
      debugPrint('Connection failed: $e');
    }
  }

  @override
  void initState() {
    startScan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(
            "Scan Printers",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 16
            )
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light,
          )
        )
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              if (!scanning && !bluetoothOn) Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Text(
                      "Bluetooth tidak aktif 🤨",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor
                      )
                    ),
                  ]
                )
              ),
              if (scanning) Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Text(
                      "Scanning printers...",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor
                      )
                    ),
                    SizedBox(height: 10),
                    LoadingAnimationWidget.fourRotatingDots(
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ]
                )
              ),
              if (!scanning && bluetoothOn && scanResults.isEmpty) Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Text(
                      "Printer tidak ditemukan",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor
                      )
                    ),
                  ]
                )
              ),
              if (!scanning && scanResults.isNotEmpty) Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (var index = 0; index < scanResults.length; index++) if (scanResults[index].device.name != "") GestureDetector(
                      onTap: () => {},
                      child: Row(
                        children: [
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scanResults[index].device.name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor
                                ),
                              ),
                              Text(
                                scanResults[index].device.id.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Theme.of(context).primaryColorDark
                                )
                              )
                            ]
                          )),
                          ElevatedButton(
                          onPressed: () => connectToDevice(scanResults[index].device.id.toString(), context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              "Gunakan",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10
                              )
                            )
                          )
                        ]
                      )
                    )
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}