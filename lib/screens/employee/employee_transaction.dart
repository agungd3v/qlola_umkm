import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/history/employee_transaction_daily.dart';
import 'package:sizer/sizer.dart';

class EmployeeTransactionScreen extends StatefulWidget {
  const EmployeeTransactionScreen({super.key});

  @override
  State<EmployeeTransactionScreen> createState() => _EmployeeTransactionScreenState();
}

class _EmployeeTransactionScreenState extends State<EmployeeTransactionScreen> {
  List transactions = [];

  Future getHistory() async {
    final httpRequest = await outlet_transaction();
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
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 3.5.w
                      )
                    ),
                    Text(
                      "Riwayat transaksi kamu hari ini.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).disabledColor,
                        fontSize: 3.w
                      )
                    )
                  ]
                ))
              ]
            )
          ),
          Expanded(child: LayoutBuilder(builder: (context, constraints) => RefreshIndicator(
            color: Theme.of(context).indicatorColor,
            onRefresh: () => Future.delayed(Duration(seconds: 1), () => getHistory()),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: transactions.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
                    children: [
                      if (transactions.isNotEmpty) for(var index = 0; index < transactions.length; index++) EmployeeTransactionDaily(
                        item: transactions[index]
                      ),
                      if (transactions.isEmpty) Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/icons/transaction_empty.png", width: 300.w, height: 50.w, fit: BoxFit.contain),
                          Column(
                            children: [
                              const SizedBox(height: 12),
                              Text(
                                "Belum ada Transaksi",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 3.5.w
                                )
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: 320,
                                child: Text(
                                  'Oops... belum ada transaksi di hari ini',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 3.w
                                  )
                                )
                              )
                            ]
                          )
                        ]
                      )
                    ]
                  )
                )
              )
            )
          )))
        ]
      )
    );
  }
}