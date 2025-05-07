import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/components/home/transaction_info.dart';
import 'package:google_fonts/google_fonts.dart';

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
        preferredSize: const Size.fromHeight(56), // Adjust height as needed
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(
            "Home",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
              fontSize: 20
            )
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light,
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
                TransactionInfo() // Komponen transaksi tetap dipertahankan
              ]
            )
          )
        )
      )
    );
  }
}
