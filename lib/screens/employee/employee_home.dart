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
import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity_plus

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  CheckoutProvider? checkout_provider;
  BluetoothProvider? bluetooth_provider;

  final inputMacAddress =
      TextEditingController(text: localStorage.getItem("printer_mac") ?? "");

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  bool testPrint = false;
  bool isConnectedToInternet = false; // Flag untuk mengecek koneksi internet
  late StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription; // Stream untuk mendengarkan perubahan koneksi
  String connectionType =
      "Tidak ada koneksi"; // Variabel untuk menampilkan jenis koneksi
  bool showSyncPrompt = false; // Flag untuk menampilkan prompt sync data
  bool hasShownNoConnectionPrompt =
      false; // Flag untuk mencegah flushbar berulang

  Future _scanPrinter() async {
    if (Platform.isAndroid) {
      final response = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect
      ].request();
      if (response[Permission.bluetoothScan]?.isGranted == true &&
          response[Permission.bluetoothConnect]?.isGranted == true) {
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
        titleText: Text("Autentikasi gagal",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 12)),
        messageText: Text(generate["message"],
            style: TextStyle(
                fontFamily: "Poppins", color: Colors.white, fontSize: 12)),
      ).show(context);
    }

    setState(() => testPrint = false);
  }

  // Fungsi untuk memeriksa koneksi internet
  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        isConnectedToInternet = true;
        connectionType = connectivityResult == ConnectivityResult.mobile
            ? "Jaringan Seluler"
            : "Wi-Fi";
        showSyncPrompt = true; // Set flag untuk menampilkan prompt sync
      } else {
        isConnectedToInternet = false;
        connectionType = "Tidak ada koneksi";
        showSyncPrompt = false; // Hide sync prompt jika tidak ada koneksi
      }
    });
  }

  void _showNoConnectionPrompt(BuildContext context) {
    if (!hasShownNoConnectionPrompt) {
      hasShownNoConnectionPrompt = true;
      Flushbar(
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 3),
        reverseAnimationCurve: Curves.fastOutSlowIn,
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text(
          "Tidak ada Koneksi",
          style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 12),
        ),
        messageText: Text(
          "Jika sudah ada koneksi internet, wajib klik tombol ini untuk sinkronkan data orderan.",
          style: TextStyle(
              fontFamily: "Poppins", color: Colors.white, fontSize: 12),
        ),
      ).show(context).then((_) {
        // Reset flag after the Flushbar has been dismissed
        hasShownNoConnectionPrompt = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      WidgetsBinding.instance.addPostFrameCallback((callback) {
        if (mounted) {
          _scanPrinter();
        } else {
          bluetooth_provider?.set_status = false;
        }
      });
    });

    checkInternetConnection(); // Cek koneksi internet saat halaman pertama kali dibuka

    // Menambahkan stream subscription untuk mendengarkan perubahan koneksi internet
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      setState(() {
        if (result.isNotEmpty) {
          if (result.first == ConnectivityResult.mobile ||
              result.first == ConnectivityResult.wifi) {
            isConnectedToInternet = true;
            connectionType = result.first == ConnectivityResult.mobile
                ? "Jaringan Seluler"
                : "Wi-Fi";
            showSyncPrompt = true; // Tampilkan prompt sync jika ada koneksi
          } else {
            isConnectedToInternet = false;
            connectionType = "Tidak ada koneksi";
            showSyncPrompt =
                false; // Sembunyikan prompt sync jika tidak ada koneksi
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    _connectivitySubscription
        .cancel(); // Jangan lupa untuk membatalkan subscription saat dispose
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
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            title: Text(
              "Home Karyawan",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 16.sp),
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).primaryColor,
              statusBarIconBrightness: Brightness.light,
            ),
          ),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Tampilkan jenis koneksi perangkat
                                  Text(
                                    isConnectedToInternet
                                        ? "Transaksi hari ini"
                                        : "($connectionType)",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 4.w),
                                  ),
                                  isConnectedToInternet
                                      ? EmployeeTransactionToday()
                                      : SizedBox
                                          .shrink(), // Menyembunyikan transaksi jika tidak ada internet
                                ])),
                        const SizedBox(height: 10),
                      ]),

                      // Kondisi jika terhubung dengan internet
                      // Inside the widget build method where the sync prompt is displayed

                      if (isConnectedToInternet)
                        Column(
                          children: [
                            // Shortened the text
                            if (showSyncPrompt)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // Make it white for better visibility
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(0.2), // Light shadow
                                        spreadRadius: 1, // Small spread
                                        blurRadius: 3, // Subtle blur
                                        offset: Offset(
                                            0, 2), // Slight vertical offset
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Klik tombol ini untuk sinkronkan data orderan jika koneksi internet sudah ada.',
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: const EdgeInsets.only(right: 10),
                              child: ButtonSyncData(
                                onPressed: () {
                                  if (!isConnectedToInternet) {
                                    // Tampilkan prompt jika tidak ada koneksi
                                    _showNoConnectionPrompt(context);
                                  } else {
                                    // Lakukan sync data
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                      // Jika tidak ada internet, tampilkan tombol untuk sinkronisasi
                      if (!isConnectedToInternet)
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(right: 10),
                          child: ButtonSyncData(
                            onPressed: () {
                              // Tampilkan prompt jika tidak ada koneksi
                              _showNoConnectionPrompt(context);
                            },
                          ),
                        ),
                    ]))));
  }
}
