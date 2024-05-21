import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:restart_app/restart_app.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> _signout() async {
    final httpRequest = await sign_out();
    if (httpRequest["status"] == 200) {
      localStorage.removeItem("user");
      localStorage.removeItem("token");

      Restart.restartApp();
    }
  }

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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GestureDetector(
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
        )
      )
    );
  }
}