import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/utils/global_function.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light
          )
        )
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Laporan",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 14
                  )
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Penjualan Mei 2024",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 11
                        )
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transformPrice(0),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 12
                        )
                      )
                    ]
                  )
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Penjualan hari ini",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 11
                        )
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transformPrice(0),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 12
                        )
                      )
                    ]
                  )
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Saldo Wallet",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 11
                        )
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transformPrice(0),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 12
                        )
                      )
                    ]
                  )
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pengeluaran hari ini",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 11
                        )
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transformPrice(0),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 12
                        )
                      )
                    ]
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}