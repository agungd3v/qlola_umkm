import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/utils/global_function.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic transaction;

  Future getHistory() async {
    final httpRequest = await owner_transaction();
    if (httpRequest["status"] == 200) {
      setState(() {
        transaction = httpRequest;
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
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light
          )
        )
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Penjualan Mei 2024",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        )
                      ),
                      if (transaction == null) Text(
                        transformPrice(0),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20
                        )
                      ),
                      if (transaction != null) Text(
                        transformPrice(double.parse(transaction["transaction_nominal_month"])),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20
                        )
                      )
                    ]
                  )
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Penjualan hari ini",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        )
                      ),
                      if (transaction == null) Text(
                        transformPrice(0),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20
                        )
                      ),
                      if (transaction != null) Text(
                        transformPrice(double.parse(transaction["transaction_nominal_today"])),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20
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