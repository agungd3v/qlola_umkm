import 'dart:async';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/components/button_sync_data.dart';
import 'package:qlola_umkm/components/employee_home/transaction_today.dart';
import 'package:qlola_umkm/providers/bluetooth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/printer.dart';
import 'package:sizer/sizer.dart';

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

  bool testPrint = false;

  Future _scanPrinter() async {
    if (Platform.isAndroid) {
      final response = await [Permission.bluetoothScan, Permission.bluetoothConnect].request();
      if (response[Permission.bluetoothScan]?.isGranted == true && response[Permission.bluetoothConnect]?.isGranted == true) {
        bluetooth_provider?.set_status = true;
      }
    }
  }

  Future _testPrinter(BuildContext context) async {
    setState(() => testPrint = true);

    localStorage.setItem("printer_mac", inputMacAddress.text);
    final generate = await testGenerateStruck();

    if (generate != null && generate["status"] == false) {
      Flushbar(
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 3),
        reverseAnimationCurve: Curves.fastOutSlowIn,
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text(
          "Autentikasi gagal",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 12
          )
        ),
        messageText: Text(
          generate["message"],
          style: TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 12
          )
        ),
      ).show(context);
    }

    setState(() => testPrint = false);
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

    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (_adapterState == BluetoothAdapterState.on) {
        _scanPrinter();
      } else {
        bluetooth_provider?.set_status = false;
      }
    });

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
                            color: Colors.white,
                            fontSize: 4.w
                          )
                        ),
                        EmployeeTransactionToday()
                      ]
                    )
                  ),
                  const SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Bluetooth Status: ",
                  //       style: TextStyle(
                  //         fontFamily: "Poppins",
                  //         color: Theme.of(context).primaryColorDark,
                  //         fontSize: 12
                  //       )
                  //     ),
                  //     Text(
                  //       bluetooth_provider!.status ? "Connected" : "Not Connected",
                  //       style: TextStyle(
                  //         fontFamily: "Poppins",
                  //         fontWeight: FontWeight.w700,
                  //         color: bluetooth_provider!.status ? Color(0xff00880d) : Colors.orangeAccent,
                  //         fontSize: 12
                  //       )
                  //     )
                  //   ]
                  // ),
                  // const SizedBox(height: 10),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                  //     borderRadius: BorderRadius.all(Radius.circular(6))
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: TextField(
                  //           decoration: InputDecoration(
                  //             isDense: true,
                  //             border: InputBorder.none,
                  //             hintText: "Masukan printer mac address",
                  //             hintStyle: TextStyle(
                  //               fontFamily: "Poppins",
                  //               fontWeight: FontWeight.w400,
                  //               color: Theme.of(context).disabledColor,
                  //               fontSize: 12
                  //             )
                  //           ),
                  //           style: TextStyle(
                  //             fontFamily: "Poppins",
                  //             fontWeight: FontWeight.w400,
                  //             color: Theme.of(context).primaryColorDark,
                  //             fontSize: 12
                  //           ),
                  //           cursorColor: Theme.of(context).focusColor,
                  //           textCapitalization: TextCapitalization.sentences,
                  //           controller: inputMacAddress,
                  //         )
                  //       ),
                  //       const SizedBox(width: 10),
                  //       if (!testPrint) GestureDetector(
                  //         onTap: () => _testPrinter(),
                  //         child: Container(
                  //           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  //           decoration: BoxDecoration(
                  //             color: Theme.of(context).primaryColor,
                  //             borderRadius: BorderRadius.all(Radius.circular(4))
                  //           ),
                  //           child: Text(
                  //             "TEST PRINTER",
                  //             style: TextStyle(
                  //               fontFamily: "Poppins",
                  //               fontWeight: FontWeight.w700,
                  //               color: Colors.white,
                  //               fontSize: 10
                  //             )
                  //           )
                  //         )
                  //       ),
                  //       if (testPrint) Container(
                  //         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  //         decoration: BoxDecoration(
                  //           color: Theme.of(context).primaryColor,
                  //           borderRadius: BorderRadius.all(Radius.circular(4))
                  //         ),
                  //         child: Row(
                  //           children: [
                  //             LoadingAnimationWidget.fourRotatingDots(
                  //               color: Colors.white,
                  //               size: 14,
                  //             ),
                  //             const SizedBox(width: 5),
                  //             Text(
                  //               "TEST PRINTER",
                  //               style: TextStyle(
                  //                 fontFamily: "Poppins",
                  //                 fontWeight: FontWeight.w700,
                  //                 color: Colors.white,
                  //                 fontSize: 10
                  //               )
                  //             )
                  //           ]
                  //         )
                  //       )
                  //     ]
                  //   )
                  // )
                ]
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: 10),
                child: ButtonSyncData() 
              )
            ]
          )
        )
      )
    );
  }
}