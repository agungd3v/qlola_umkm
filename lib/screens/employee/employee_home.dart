import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/employee_home/transaction_today.dart';
import 'package:qlola_umkm/providers/bluetooth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/printer.dart';
import 'package:restart_app/restart_app.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  CheckoutProvider? checkout_provider;
  BluetoothProvider? bluetooth_provider;

  final inputMacAddress = TextEditingController(text: localStorage.getItem("printer_mac") ?? "");

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  bool proccess = false;
  bool testPrint = false;

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

  Future _scanPrinter() async {
    if (Platform.isAndroid) {
      final response = await [Permission.bluetoothScan, Permission.bluetoothConnect].request();
      if (response[Permission.bluetoothScan]?.isGranted == true && response[Permission.bluetoothConnect]?.isGranted == true) {
        bluetooth_provider?.set_status = true;
      }
    }
  }

  Future _testPrinter() async {
    setState(() => testPrint = true);

    localStorage.setItem("printer_mac", inputMacAddress.text);
    final generate = await testGenerateStruck();

    if (generate) {
      setState(() => testPrint = false);
    }
  }

  @override
  void initState() {
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      WidgetsBinding.instance.addPostFrameCallback((callback) {
        if (mounted) {
          _scanPrinter();
        } else {
          bluetooth_provider?.set_status = false;
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkout_provider = Provider.of<CheckoutProvider>(context);
    bluetooth_provider = Provider.of<BluetoothProvider>(context);

    // WidgetsBinding.instance.addPostFrameCallback((callback) {
    //   if (_adapterState == BluetoothAdapterState.on) {
    //     _scanPrinter();
    //   } else {
    //     bluetooth_provider?.set_status = false;
    //   }
    // });

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
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
                        bluetooth_provider!.status ? "Connected" : "Not Connected",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: bluetooth_provider!.status ? Color(0xff00880d) : Colors.orangeAccent,
                          fontSize: 12
                        )
                      )
                    ]
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Masukan printer mac address",
                              hintStyle: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).disabledColor,
                                fontSize: 12
                              )
                            ),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 12
                            ),
                            cursorColor: Theme.of(context).focusColor,
                            controller: inputMacAddress,
                          )
                        ),
                        const SizedBox(width: 10),
                        if (!testPrint) GestureDetector(
                          onTap: () => _testPrinter(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
                        ),
                        if (testPrint) Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Row(
                            children: [
                              LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "TEST PRINTER",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 10
                                )
                              )
                            ]
                          )
                        )
                      ]
                    )
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
      )
    );
  }
}