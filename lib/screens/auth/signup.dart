import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/api/request.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final phone = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final business = TextEditingController();
  bool show_password = false;

  Future<void> _signup() async {
    // inspect(name.text);
    // inspect(phone.text);
    // inspect(email.text);
    // inspect(password.text);
    // inspect(business.text);
    final Map<String, dynamic> data = {
      "name" : name.text,
      "phone": "+62${phone.text}",
      "email": email.text,
      "password": password.text,
      "business_name": business.text
    };

    final httpRequest = await sign_up(data);
    if (httpRequest["status"] == 200) {
      Navigator.pop(context);
    }

    FocusScope.of(context).unfocus();
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
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SignUp",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  fontSize: 20
                )
              ),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                alignment: Alignment.topLeft,
                child: Text(
                  "Informasi Pemilik",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 13
                  )
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
                child: TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: "Nama Lengkap",
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
                  cursorColor: Theme.of(context).focusColor,
                  controller: name,
                )
              ),
              const SizedBox(height: 6),
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
              const SizedBox(height: 6),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: "Alamat Email",
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
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Theme.of(context).focusColor,
                  controller: email,
                )
              ),
              const SizedBox(height: 6),
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
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor)
                  )
                )
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                alignment: Alignment.topLeft,
                child: Text(
                  "Informasi Usaha",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 13
                  )
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
                child: TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: "Nama Usaha",
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
                  cursorColor: Theme.of(context).focusColor,
                  controller: business,
                )
              ),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: GestureDetector(
                  onTap: () => _signup(),
                  child: Container(
                    height: 38,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    child: Text(
                      "Daftar",
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
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 38,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    child: Text(
                      "Masuk",
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