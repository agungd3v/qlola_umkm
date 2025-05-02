import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class HistoryTransactionScreen extends StatefulWidget {
  const HistoryTransactionScreen({super.key});

  @override
  State<HistoryTransactionScreen> createState() => _HistoryTransactionScreenState();
}

class _HistoryTransactionScreenState extends State<HistoryTransactionScreen> {
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
          )
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
                  "History Transaksi",
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
          GestureDetector(
            onTap: () => context.pushNamed("Owner Transaction"),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor)
                )
              ),
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
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 12
                        )
                      ),
                      Text(
                        "history traansaksi bulan ini dan hari ini",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).primaryColorDark.withOpacity(0.6),
                          fontSize: 12
                        )
                      )
                    ]
                  ),
                  Image.asset("assets/icons/arrow_right_black.png", width: 13, height: 13)
                ]
              )
            )
          ),
          // GestureDetector(
          //   onTap: () => context.pushNamed("DeleteTransaction"),
          //   child: Container(
          //     width: double.infinity,
          //     padding: const EdgeInsets.symmetric(horizontal: 20),
          //     height: 50,
          //     decoration: BoxDecoration(
          //       border: Border(
          //         bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor)
          //       )
          //     ),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               "Hapus Transaksi",
          //               style: TextStyle(
          //                 fontFamily: "Poppins",
          //                 color: Theme.of(context).primaryColorDark,
          //                 fontWeight: FontWeight.w700,
          //                 fontSize: 12
          //               )
          //             ),
          //             Text(
          //               "hapus transaksi tertentu bila di perlukan",
          //               overflow: TextOverflow.ellipsis,
          //               style: TextStyle(
          //                 fontFamily: "Poppins",
          //                 color: Theme.of(context).primaryColorDark.withOpacity(0.6),
          //                 fontSize: 12
          //               )
          //             )
          //           ]
          //         ),
          //         Image.asset("assets/icons/arrow_right_black.png", width: 13, height: 13)
          //       ]
          //     )
          //   )
          // )
        ]
      )
    );
  }
}