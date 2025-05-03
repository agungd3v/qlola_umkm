import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/database/database_helper.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:qlola_umkm/utils/printer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class CompleteOrederScreen extends StatefulWidget {
  const CompleteOrederScreen({super.key});

  @override
  State<CompleteOrederScreen> createState() => _CompleteOrederScreenState();
}

class _CompleteOrederScreenState extends State<CompleteOrederScreen> {
  CheckoutProvider? checkout_provider;
  AuthProvider? auth_provider;
  bool processBluetoothPrint = false;

  WidgetsToImageController widgetsToImageController = WidgetsToImageController();

  final databaseHelper = DatabaseHelper.instance;

  Future _printShare() async {
    List<int> bytes = [];
    final tempDir = await getTemporaryDirectory();

    bytes += (await widgetsToImageController.capture())!;
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(bytes);

    await Share.shareXFiles([XFile(file.path)], text: "Resi Pembelian");
  }

  Future _printBluetooth(BuildContext context) async {
    setState(() => processBluetoothPrint = true);

    final struck = await generateStruck(checkout_provider as CheckoutProvider, auth_provider as AuthProvider, "-");

    if (!struck["status"]) {
      Flushbar(
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 3),
        reverseAnimationCurve: Curves.fastOutSlowIn,
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text(
          "Bluetooth print",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 12
          )
        ),
        messageText: Text(
          struck["message"],
          style: TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 12
          )
        )
      ).show(context);

      setState(() => processBluetoothPrint = false);
    } else {
      Flushbar(
        backgroundColor: Color(0xff00880d),
        duration: Duration(seconds: 3),
        reverseAnimationCurve: Curves.fastOutSlowIn,
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text(
          "Bluetooth print",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 12
          )
        ),
        messageText: Text(
          "Struck sebentar lagi siap 🥣",
          style: TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 12
          )
        )
      ).show(context);

      setState(() => processBluetoothPrint = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkout_provider = Provider.of<CheckoutProvider>(context);
    auth_provider = Provider.of<AuthProvider>(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetsToImage(
                controller: widgetsToImageController,
                child: Container(
                  width: 218,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Column(
                    children: [
                      Text(
                        auth_provider!.user["outlet"]["business"]["business_name"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 12
                        )
                      ),
                      Text(
                        auth_provider!.user["outlet"]["outlet_name"],
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w500,
                          fontSize: 10
                        )
                      ),
                      const SizedBox(height: 25),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1)
                          )
                        )
                      ),
                      const SizedBox(height: 5),
                      for (var index = 0; index < checkout_provider!.carts.length; index++) Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  checkout_provider!.carts[index]["product_name"],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 10
                                  )
                                ),
                                Row(
                                  children: [
                                    Text(
                                      transformPrice(double.parse(checkout_provider!.carts[index]["product_price"].toString())),
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 10
                                      )
                                    ),
                                    Text(
                                      " x ${checkout_provider!.carts[index]["quantity"]}",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 10
                                      )
                                    )
                                  ]
                                )
                              ]
                            ),
                            Text(
                              transformPrice(
                                double.parse(checkout_provider!.carts[index]["product_price"].toString()) * checkout_provider!.carts[index]["quantity"]
                              ),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 10
                              )
                            )
                          ]
                        )
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1)
                          )
                        )
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12
                            )
                          ),
                          Text(
                            transformPrice(checkout_provider!.cart_total),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12
                            )
                          )
                        ]
                      ),
                      const SizedBox(height: 35),
                      Text(
                        "Terimakasih ^_^",
                        style: TextStyle(
                          fontFamily: "Poppins"
                        )
                      )
                    ]
                  )
                )
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: GestureDetector(
                        onTap: () => _printBluetooth(context),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // color: Theme.of(context).dividerColor,
                            border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Text(
                            "Bluetooth print",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              // color: Theme.of(context).primaryColorDark
                              color: Theme.of(context).primaryColorDark
                            )
                          )
                        )
                      )),
                      const SizedBox(width: 10),
                      Expanded(child: GestureDetector(
                        onTap: () => _printShare(),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Text(
                            "Share print",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Theme.of(context).primaryColorDark
                            )
                          )
                        )
                      ))
                    ]
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      context.go("/order");
                      checkout_provider?.reset();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: Text(
                        "Kembali memesan",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16
                        )
                      )
                    )
                  )
                ]
              )
            ]
          )
        )
      )
    );
  }
}