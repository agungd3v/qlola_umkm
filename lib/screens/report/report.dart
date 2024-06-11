import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
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
  List transactions = [];
  String avgTime = "-";

  bool loading = false;

  Future _getReport() async {
    setState(() {
      loading = true;
      transactions = [];
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

            setState(() => transactions.add(checkout["product"]));
          }
        }
      }
    }

    if (transactions.isNotEmpty) {
      final values = <String, dynamic>{};
      List trxTime = [];

      for (var index = 0; index < transactions.length; index++) {
        final item = transactions[index];
        final itemId = item["id"].toString();
        final itemQuantity = int.parse(item["quantity"]);

        int preValue = 0;

        if (values.containsKey(itemId)) {
          preValue = values[itemId];
        }
        preValue = preValue + itemQuantity;
        values[itemId] = preValue;

        final getTime = transactions[index]["created_at"].split(" ")[1];
        final splited = getTime.toString().split(":");
        trxTime.add(int.parse("${splited[0]}${splited[1]}${splited[2]}"));
      }

      final results = values.values.toList();
      List newTransactions = [];

      for (var key in values.keys) {
        final trx = transactions.where((data) => data["id"].toString() == key);
        newTransactions.add(trx.first);
      }

      for (var index = 0; index < results.length; index++) {
        newTransactions[index]["quantity"] = results[index];
      }

      var avg = trxTime.map((m) => m).reduce((a, b) => a + b) / trxTime.length;

      setState(() {
        transactions = newTransactions;
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
          if (!loading && report != null) Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
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
                        "${report!["product_sales"]}",
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
                if (transactions.isNotEmpty) Container(
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
                      for (var index = 0; index < transactions.length; index++) Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transactions[index]["product_name"],
                              style: TextStyle(
                                fontFamily: "Poppins"
                              )
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  transactions[index]["quantity"].toString() + "pcs",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 12
                                  )
                                ),
                                Text(
                                  transformPrice(
                                    transactions[index]["quantity"] * double.parse(transactions[index]["product_price"]),
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
                )
              ]
            )
          )
        ]
      )
    );
  }
}