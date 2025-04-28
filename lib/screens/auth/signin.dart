import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:localstorage/localstorage.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/utils/flush_message.dart';
import 'package:restart_app/restart_app.dart';
import 'dart:convert';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final phone = TextEditingController(text: "81283134032");
  final password = TextEditingController(text: "12345678");
  bool showPassword = false;
  bool proccess = false;

  Future<void> _signin() async {
    final data = {
      "phone": "+62${phone.text}",
      "password": password.text,
    };

    setState(() => proccess = true);

    final response = await sign_in(data);
    if (response["status"] == 200) {
      localStorage.setItem("user", json.encode(response["user"]));
      localStorage.setItem("token", response["token"]);
      Restart.restartApp();
    } else {
      setState(() => proccess = false);
      errorMessage(context, "Autentikasi", response["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon center sebagai logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 80,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                "Masuk ke Akunmu",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Pantau dan kelola keuangan bisnismu",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              // Input No HP dengan +62 tetap terlihat
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "+62",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: phone,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: "No Handphone",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Input Password
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: TextField(
                  controller: password,
                  obscureText: !showPassword,
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded,
                        color: theme.primaryColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () =>
                          setState(() => showPassword = !showPassword),
                    ),
                    border: InputBorder.none,
                    hintText: "Password",
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Tombol Masuk
              proccess
                  ? Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.fourRotatingDots(
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Masuk...",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _signin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Masuk",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

              const SizedBox(height: 16),

              // Tombol daftar
              TextButton(
                onPressed: () => context.pushNamed("Sign Up"),
                child: Text(
                  "Belum punya akun? Daftar di sini",
                  style: GoogleFonts.poppins(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
