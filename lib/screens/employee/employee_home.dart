import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:localstorage/localstorage.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/employee_home/transaction_today.dart';
import 'package:restart_app/restart_app.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  bool proccess = false;

  Future<void> _signout() async {
    setState(() => proccess = true);

    final httpRequest = await sign_out();
    if (httpRequest["status"] == 200) {
      localStorage.removeItem("user");
      localStorage.removeItem("token");

      Restart.restartApp();
    }

    setState(() => proccess = false);
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
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    "Transaksi hari ini",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    )
                  ),
                  EmployeeTransactionToday()
                ]
              )
            ),
            if (!proccess) GestureDetector(
              onTap: () {
                _signout();
              },
              child: Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: Text(
                  "Keluar",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  )
                )
              )
            ),
            if (proccess) Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(6))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Keluar...",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}