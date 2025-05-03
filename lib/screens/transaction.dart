import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/components/history/transaction_daily.dart';
import 'package:qlola_umkm/components/history/transaction_monthly.dart';
import 'package:sizer/sizer.dart';

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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    width: 40,
                    child: Image.asset("assets/icons/arrow_back_white.png", width: 4.5.w, height: 4.5.w)
                  )
                ),
                Text(
                  "History transaksi hari ini & bulan ini",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 3.6.w
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
                      "Transaksi bulan ini",
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