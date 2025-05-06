import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/components/button_sync_data.dart';
import 'package:qlola_umkm/components/employee_home/transaction_today.dart';
import 'package:qlola_umkm/notifiers/tab_notifer.dart';
import 'package:qlola_umkm/providers/bluetooth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/flush_message.dart';
import 'package:qlola_umkm/utils/printer.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  CheckoutProvider? checkout_provider;
  BluetoothProvider? bluetooth_provider;

  final inputMacAddress = TextEditingController();
  late VoidCallback listener;

  bool testPrint = false;
  bool showSyncPrompt = false;

  Future _testPrinter(BuildContext context) async {
    setState(() => testPrint = true);

    final generate = await testGenerateStruck();

    if (generate["status"] == false) {
      errorMessage(context, "Printer", generate["message"]);
    }

    setState(() => testPrint = false);
  }

  void bindMac() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      setState(() => inputMacAddress.text = checkout_provider!.macAddress);
    });
  }

  @override
  void initState() {
    super.initState();

    bindMac();
    listener = () {
      if (tabChangeNotifier.value == 0) {
        bindMac();
      }
    };

    tabChangeNotifier.addListener(listener);
  }

  @override
  void dispose() {
    tabChangeNotifier.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkout_provider = Provider.of<CheckoutProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56), // Adjust height as needed
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(
            "Home Karyawan",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
              fontSize: 18
            )
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light,
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
              Column(children: [
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
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16
                        )
                      ),
                      EmployeeTransactionToday()
                    ]
                  )
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Row(children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: "Printer mac address",
                            hintStyle: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).disabledColor,
                              fontSize: 14
                            ),
                            enabled: false
                          ),
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 14
                          ),
                          cursorColor: Theme.of(context).focusColor,
                          controller: inputMacAddress
                        )
                      ),
                      SizedBox(width: 8),
                      if (inputMacAddress.text != "") Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _testPrinter(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              )
                            ),
                            child: Text(
                              "Tes",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12
                              )
                            )
                          ),
                          SizedBox(width: 4),
                          ElevatedButton(
                            onPressed: () => context.pushNamed("Employee Printer"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColorDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              )
                            ),
                            child: Text(
                              "Ubah",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12
                              )
                            )
                          )
                        ]
                      ),
                      if (inputMacAddress.text == "") ElevatedButton(
                        onPressed: () => context.pushNamed("Employee Printer"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          )
                        ),
                        child: Text(
                          "Scan",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )
                        )
                      )
                    ]
                  )
                )
              ]),
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
