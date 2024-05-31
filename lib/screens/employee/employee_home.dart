import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/employee_home/transaction_today.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:restart_app/restart_app.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  CheckoutProvider? checkout_provider;

  bool proccess = false;
  bool _printerConnected = false;

  Future<void> _signout() async {
    setState(() => proccess = true);

    final httpRequest = await sign_out();
    if (httpRequest["status"] == 200) {
      localStorage.removeItem("user");
      localStorage.removeItem("token");

      Restart.restartApp();
    }

    setState(() => proccess = false);
  }

  Future<void> _scanPrinter() async {
    if (Platform.isAndroid) {
      final response = await [Permission.bluetoothScan, Permission.bluetoothConnect].request();

      if (response[Permission.bluetoothScan]?.isGranted == true && response[Permission.bluetoothConnect]?.isGranted == true) {
        final devices = await PrintBluetoothThermal.pairedBluetooths;
        for (var index = 0; index < devices.length; index++) {
          if (devices[index].name == "RPP02N") {
            checkout_provider!.set_printer = {
              "status": true,
              "name": devices[index].name,
              "mac": devices[index].macAdress
            };

            localStorage.setItem("printer_name", devices[index].name);
            localStorage.setItem("printer_mac", devices[index].macAdress);

            setState(() => _printerConnected = true);
          }
        }
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      setState(() {
        _printerConnected = checkout_provider!.printer["status"];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkout_provider = Provider.of<CheckoutProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light
          )
        )
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transaksi hari ini",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        )
                      ),
                      EmployeeTransactionToday()
                    ]
                  )
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Printer Status: ",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 12
                          )
                        ),
                        Text(
                          _printerConnected ? "Connected" : "Not Connected",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: _printerConnected ? Color(0xff00880d) : Colors.orangeAccent,
                            fontSize: 12
                          )
                        )
                      ]
                    ),
                    GestureDetector(
                      onTap: () => _scanPrinter(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(4))
                        ),
                        child: Text(
                          "TEST PRINTER",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 10
                          )
                        )
                      )
                    )
                  ]
                )
              ]
            ),
            if (!proccess) GestureDetector(
              onTap: () {
                _signout();
              },
              child: Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: Text(
                  "Keluar",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  )
                )
              )
            ),
            if (proccess) Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(6))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Keluar...",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}