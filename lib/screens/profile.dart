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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(80), // Disesuaikan dengan height header
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          title: Padding(
            padding: const EdgeInsets.only(
                top: 20.0), // Memberikan padding untuk judul
            child: Text(
              "Profil", // Menjaga konsistensi nama pada halaman Profile
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 22, // Ukuran font konsisten dengan halaman lain
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    border: Border(
                      bottom: BorderSide(
                          width: 1, color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Profile Picture
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2, color: Theme.of(context).primaryColor),
                        ),
                        child: Center(
                          child: Image.asset("assets/icons/profile.png",
                              width: 35, height: 35),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth_provider!.user["name"],
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Owner Bisnis",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).disabledColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                // History Transaction
                GestureDetector(
                  onTap: () => context.pushNamed("HistoryTransaction"),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 1, color: Theme.of(context).dividerColor),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "History Transaksi",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Image.asset("assets/icons/arrow_right_black.png",
                            width: 13, height: 13),
                      ],
                    ),
                  ),
                ),
                // Report Section
                GestureDetector(
                  onTap: () => context.pushNamed("Report"),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 1, color: Theme.of(context).dividerColor),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Laporan",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Image.asset("assets/icons/arrow_right_black.png",
                            width: 13, height: 13),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
          // Signout Section without gradient
          if (!proccess)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () => _signout(),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .primaryColor, // Flat color for the button
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 20, // Set icon size
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Keluar",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Loading State for Signout
          if (proccess)
            Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(6)),
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
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
