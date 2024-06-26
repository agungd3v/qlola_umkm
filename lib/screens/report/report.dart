import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/charts/pie/line_chart.dart';
import 'package:qlola_umkm/components/charts/pie/pie_chart.dart';
import 'package:qlola_umkm/components/report/sheet_date.dart';
import 'package:qlola_umkm/components/report/sheet_outlet.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';
import 'package:qlola_umkm/utils/global_function.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  OwnerProvider? owner_provider;

  Map<String, dynamic>? report;
  List products = [];
  List other_products = [];
  String avgTime = "-";

  bool loading = false;

  Future _getReport() async {
    setState(() {
      loading = true;
      products = [];
      other_products = [];
      avgTime = "-";
    });

    Map<String, dynamic> data = {
      "outlet": owner_provider!.reportOutlet["value"],
      "date": owner_provider!.reportDate["value"]
    };

    final httpRequest = await get_report_owner(data);
    if (httpRequest["status"] == 200) {
      setState(() => report = httpRequest["data"]);

      if (httpRequest["data"]["transactions"].isNotEmpty) {
        List trx = httpRequest["data"]["transactions"];
        for (var index = 0; index < trx.length; index++) {
          for (var index2 = 0; index2 < trx[index]["checkouts"].length; index2++) {
            Map<String, dynamic> checkout = trx[index]["checkouts"][index2];
            checkout["product"]["quantity"] = checkout["quantity"];

            setState(() => products.add(checkout["product"]));
          }
          for (var index3 = 0; index3 < trx[index]["others"].length; index3++) {
            setState(() => other_products.add(trx[index]["others"][index3]));
          }
        }
      }
    }

    if (products.isNotEmpty) {
      final values = <String, dynamic>{};
      List trxTime = [];

      for (var index = 0; index < products.length; index++) {
        final item = products[index];
        final itemId = item["id"].toString();
        final itemQuantity = int.parse(item["quantity"].toString());

        int preValue = 0;

        if (values.containsKey(itemId)) {
          preValue = values[itemId];
        }
        preValue = preValue + itemQuantity;
        values[itemId] = preValue;

        final getTime = products[index]["created_at"].split(" ")[1];
        final splited = getTime.toString().split(":");
        trxTime.add(int.parse("${splited[0]}${splited[1]}${splited[2]}"));
      }

      final results = values.values.toList();
      List newProducts = [];

      for (var key in values.keys) {
        final trx = products.where((data) => data["id"].toString() == key);
        newProducts.add(trx.first);
      }

      for (var index = 0; index < results.length; index++) {
        newProducts[index]["quantity"] = results[index];
      }

      var avg = trxTime.map((m) => m).reduce((a, b) => a + b) / trxTime.length;

      setState(() {
        products = newProducts;
        avgTime = splitByLength(int.parse(avg.toStringAsFixed(0)).toString(), 2).join(":");
      });
    }

    setState(() => loading = false);
  }

  void _showSelectDate() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => SheetDate()
    );
  }

  void _showSelectOutlet() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        content: SheetOutlet()
      )
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _getReport();
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      owner_provider!.reset();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    owner_provider = Provider.of<OwnerProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light
          ),
        )
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border(
                bottom: BorderSide(width: 1, color: Theme.of(context).primaryColor)
              )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset("assets/icons/arrow_back_white.png", width: 16, height: 16)
                  )
                ),
                Text(
                  "Laporan Penjualan",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  )
                ),
              ]
            )
          ),
          GestureDetector(
            onTap: () => _showSelectOutlet(),
            child: Container(
              width: double.infinity,
              height: 40,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Image.asset("assets/icons/outlet.png", width: 20, height: 20),
                  const SizedBox(width: 10),
                  Text(
                    owner_provider!.reportOutlet["label"].toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 12
                    )
                  ),
                  const SizedBox(width: 15)
                ]
              )
            )
          ),
          GestureDetector(
            onTap: () => _showSelectDate(),
            child: Container(
              width: double.infinity,
              height: 40,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Image.asset("assets/icons/calendar.png", width: 20, height: 20),
                  const SizedBox(width: 10),
                  Text(
                    owner_provider!.reportDate["label"].toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 12
                    )
                  ),
                  const SizedBox(width: 15)
                ]
              )
            )
          ),
          GestureDetector(
            onTap: () => _getReport(),
            child: Container(
              width: 100,
              height: 35,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child:Text(
                "Terapkan",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 12
                )
              )
            )
          ),
          if (loading) Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Loading...",
              style: TextStyle(
                fontFamily: "Poppins",
                color: Theme.of(context).primaryColorDark
              )
            ),
          ),
          if (!loading && report != null && report!["transactions"].isNotEmpty) Expanded(child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // if (products.isNotEmpty) PieChartComponent(
                  //   products: [...products, ...other_products],
                  // ),
                  if (products.isNotEmpty) LineChartComponent(report: report!),
                  Container(
                    width: double.infinity,
                    height: 65,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).dividerColor,
                          spreadRadius: 0.1,
                          blurRadius: 7,
                          offset: Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Penjualan",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 12
                          )
                        ),
                        const SizedBox(height: 2),
                        Text(
                          transformPrice(report!["sales"]),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                          )
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 65,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).dividerColor,
                          spreadRadius: 0.1,
                          blurRadius: 7,
                          offset: Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Transaksi",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 12
                          )
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${report!["count"]}",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                          )
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 65,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).dividerColor,
                          spreadRadius: 0.1,
                          blurRadius: 7,
                          offset: Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Produk Terjual",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 12
                          )
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${report!["product_sales"] + report!["product_other_sales"]}",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                          )
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 65,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).dividerColor,
                          spreadRadius: 0.1,
                          blurRadius: 7,
                          offset: Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Rata-rata Waktu Produk Terjual",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 12
                          )
                        ),
                        const SizedBox(height: 2),
                        Text(
                          avgTime,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                          )
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 12),
                  if (products.isNotEmpty) Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).dividerColor,
                          spreadRadius: 0.1,
                          blurRadius: 7,
                          offset: Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detail Produk Terjual",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                          )
                        ),
                        const SizedBox(height: 20),
                        for (var index = 0; index < products.length; index++) Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index]["product_name"],
                                style: TextStyle(
                                  fontFamily: "Poppins"
                                )
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    products[index]["quantity"].toString() + "pcs",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12
                                    )
                                  ),
                                  Text(
                                    transformPrice(
                                      int.parse(products[index]["quantity"].toString()) * double.parse(products[index]["product_price"].toString()),
                                    ),
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                    )
                                  )
                                ]
                              )
                            ]
                          )
                        ),
                        for (var index = 0; index < other_products.length; index++) Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                other_products[index]["product_name"],
                                style: TextStyle(
                                  fontFamily: "Poppins"
                                )
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    other_products[index]["quantity"].toString() + "pcs",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12
                                    )
                                  ),
                                  Text(
                                    transformPrice(
                                      int.parse(other_products[index]["quantity"].toString()) * double.parse(other_products[index]["product_price"].toString()),
                                    ),
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                    )
                                  )
                                ]
                              )
                            ]
                          )
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 20),
                ]
              )
            )
          ))
        ]
      )
    );
  }
}