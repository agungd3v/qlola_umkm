import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/components/history/transaction_daily.dart';
import 'package:qlola_umkm/components/history/transaction_monthly.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Column(
          children: [
            Container(
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
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 42, bottom: 12, left: 20, right: 14),
                      child: Image.asset("assets/icons/arrow_back_white.png", width: 16, height: 16)
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 42, bottom: 12),
                    child: Text(
                      "History transaksi hari ini & bulan ini",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 4.5.w
                      )
                    )
                  )
                ]
              )
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        onTap: (index) {
                          setState(() {
                            tabIndex = index;
                          });
                        },
                        tabs: [
                          Tab(
                            child: Text(
                              "Transaksi hari ini",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                color: tabIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
                                fontSize: 14,
                              )
                            )
                          ),
                          Tab(
                            child: Text(
                              "Transaksi bulan ini",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                color: tabIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
                                fontSize: 14,
                              )
                            )
                          )
                        ]
                      )
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          TransactionDaily(),
                          TransactionMonthly()
                        ]
                      )
                    )
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }
}