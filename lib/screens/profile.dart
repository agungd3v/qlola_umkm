import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:restart_app/restart_app.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthProvider? auth_provider;
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
    auth_provider = Provider.of<AuthProvider>(context);

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
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor)
                    )
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Theme.of(context).primaryColor)
                        ),
                        child: Center(
                          child: Image.asset("assets/icons/profile.png", width: 35, height: 35)
                        )
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth_provider!.user["name"],
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 14
                            )
                          ),
                          Text(
                            "Owner Bisnis",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).disabledColor,
                              fontSize: 12
                            )
                          )
                        ]
                      ))
                    ]
                  )
                ),
                GestureDetector(
                  onTap: () => context.pushNamed("Transaction"),
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
                      children: [
                        Expanded(child: Text(
                          "History Transaksi Hari & Bulan ini",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 12
                          )
                        )),
                        Image.asset("assets/icons/arrow_right_black.png", width: 13, height: 13)
                      ]
                    )
                  )
                ),
                GestureDetector(
                  onTap: () => context.pushNamed("Report"),
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
                      children: [
                        Expanded(child: Text(
                          "Laporan",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 12
                          )
                        )),
                        Image.asset("assets/icons/arrow_right_black.png", width: 13, height: 13)
                      ]
                    )
                  )
                )
              ]
            )
          )),
          if (!proccess) Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: GestureDetector(
              onTap: () => _signout(),
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
          ),
          if (proccess) Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(6))
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 5),
                Text(
                  "Keluar",
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
    );
  }
}