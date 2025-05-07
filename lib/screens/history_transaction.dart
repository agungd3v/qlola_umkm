import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryTransactionScreen extends StatefulWidget {
  const HistoryTransactionScreen({super.key});

  @override
  State<HistoryTransactionScreen> createState() => _HistoryTransactionScreenState();
}

class _HistoryTransactionScreenState extends State<HistoryTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: false,
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
                      "History Transaksi",
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
            GestureDetector(
              onTap: () => context.pushNamed("Owner Transaction"),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "History Transaksi",
                          style: GoogleFonts.roboto(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          )
                        ),
                        Text(
                          "history traansaksi bulan ini dan hari ini",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            color: Theme.of(context).primaryColorDark.withOpacity(0.6),
                            fontSize: 14
                          )
                        )
                      ]
                    ),
                    Image.asset("assets/icons/arrow_right_black.png", width: 17, height: 17)
                  ]
                )
              )
            ),
            Container(
              height: 1,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Theme.of(context).dividerColor)
              )
            )
          ]
        )
      )
    );
  }
}