import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/utils/global_function.dart';

class EmployeeTransactionScreen extends StatefulWidget {
  const EmployeeTransactionScreen({super.key});

  @override
  State<EmployeeTransactionScreen> createState() => _EmployeeTransactionScreenState();
}

class _EmployeeTransactionScreenState extends State<EmployeeTransactionScreen> {
  List transactions = [];

  Future getHistory() async {
    final httpRequest = await outlet_transaction();
    inspect(httpRequest);
    if (httpRequest["status"] == 200) {
      setState(() {
        transactions = httpRequest["transactions"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark
          )
        )
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor)
              )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transaksi",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark
                      )
                    ),
                    Text(
                      "Riwayat transaksi kamu hari ini.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).disabledColor,
                        fontSize: 11
                      )
                    )
                  ]
                ))
              ]
            )
          ),
          Expanded(child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  for(var index = 0; index < transactions.length; index++) Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset("assets/icons/transaction.png", width: 25, height: 25)
                            ),
                            const SizedBox(height: 5),
                            Text(
                              transformPrice(double.parse(transactions[index]["grand_total"])),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor,
                                fontSize: 10
                              )
                            )
                          ]
                        )
                      ),
                      Expanded(child: ExpansionTile(
                        dense: true,
                        shape: Border(),
                        title: Text(
                          transactions[index]["transaction_code"],
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColorDark
                          )
                        ),
                        subtitle: Text(
                          transformDate(transactions[index]["created_at"]),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).disabledColor
                          )
                        ),
                        children: [
                          for (var index2 = 0; index2 < transactions[index]["checkouts"].length; index2++) Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            color: Theme.of(context).dividerColor,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transactions[index]["checkouts"][index2]["product"]["product_name"],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 13
                                  )
                                ),
                                Row(
                                  children: [
                                    Text(
                                      transformPrice(double.parse(transactions[index]["checkouts"][index2]["total"])),
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12
                                      )
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "(x${transactions[index]["checkouts"][index2]["quantity"]})",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 10
                                      )
                                    ),
                                  ]
                                )
                              ]
                            )
                          )
                        ]
                      ))
                    ]
                  )
                ]
              )
            )
          ))
        ]
      )
    );
  }
}