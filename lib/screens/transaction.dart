import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/components/history/transaction_daily.dart';
import 'package:qlola_umkm/components/history/transaction_monthly.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                  "History Transaksi",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  )
                ),
              ]
            )
          ),
          Expanded(child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: Colors.white,
                bottom: TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) {
                    setState(() {
                      tabIndex = index;
                    });
                  },
                  tabs: [
                    Tab(child: Text(
                      "Transaksi hari ini",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: tabIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
                        fontSize: 12
                      )
                    )),
                    Tab(child: Text(
                      "Semua Transaksi",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: tabIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
                        fontSize: 12
                      )
                    ))
                  ]
                )
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  TransactionDaily(),
                  TransactionMonthly()
                ]
              )
            )
          ))
        ]
      ),
    );
  }
}