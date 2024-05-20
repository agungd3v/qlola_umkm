import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:restart_app/restart_app.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final phone = TextEditingController();
  final password = TextEditingController();
  bool show_password = false;

  Future<void> _signin() async {
    final Map<String, dynamic> data = {
      "phone": "+62${phone.text}",
      "password": password.text
    };

    final httpRequest = await sign_in(data);
    if (httpRequest["status"] == 200) {
      localStorage.setItem("user", json.encode(httpRequest["user"]));
      localStorage.setItem("token", httpRequest["token"]);

      Restart.restartApp();
    }
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/signin_image.png", width: 200, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 12),
              Text(
                "SignIn",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  fontSize: 16
                )
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: Row(
                  children: [
                    Text(
                      "+62",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 12
                      )
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: "No. Handphone",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).disabledColor,
                          fontSize: 12
                        )
                      ),
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 12
                      ),
                      keyboardType: TextInputType.number,
                      cursorColor: Theme.of(context).focusColor,
                      controller: phone,
                    ))
                  ]
                )
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).disabledColor,
                          fontSize: 12
                        )
                      ),
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 12
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: !show_password,
                      cursorColor: Theme.of(context).focusColor,
                      controller: password,
                    )),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => show_password = !show_password),
                      child: !show_password ? Image.asset("assets/icons/show_password.png", width: 20, height: 20) : Image.asset("assets/icons/hide_password.png", width: 20, height: 20)
                    )
                  ]
                )
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _signin();
                  },
                  child: Container(
                    height: 38,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    child: Text(
                      "Masuk",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      )
                    )
                  )
                )
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: GestureDetector(
                  onTap: () => context.pushNamed("Sign Up"),
                  child: Container(
                    height: 38,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    child: Text(
                      "Daftar",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).primaryColor
                      )
                    )
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}