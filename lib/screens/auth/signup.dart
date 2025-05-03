import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool proccess = false;

  Future<void> _signup() async {
    final Map<String, dynamic> data = {
      "name": name.text,
      "phone": "+62${phone.text}",
      "email": email.text,
      "password": password.text,
      "business_name": business.text
    };

    setState(() => proccess = true);
    final httpRequest = await sign_up(data);

    if (httpRequest["status"] == 200) {
      return Navigator.pop(context);
    }

    setState(() => proccess = false);

    Flushbar(
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      titleText: const Text(
        "Registrasi gagal",
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      messageText: Text(
        httpRequest["message"],
        style: const TextStyle(color: Colors.white),
      ),
    ).show(context);
  }

  Widget buildInputField({required IconData icon, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(child: child)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.business,
                      size: 80, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 20),
                  Text(
                    "Buat Akun",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Informasi Pemilik",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  buildInputField(
                    icon: Icons.person_outline,
                    child: TextField(
                      controller: name,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Nama Lengkap"),
                    ),
                  ),
                  buildInputField(
                    icon: Icons.phone,
                    child: Row(
                      children: [
                        const Text("+62"),
                        const SizedBox(width: 6),
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
                  buildInputField(
                    icon: Icons.email_outlined,
                    child: TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Alamat Email"),
                    ),
                  ),
                  buildInputField(
                    icon: Icons.lock_outline,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: password,
                            obscureText: !show_password,
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: "Password"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              setState(() => show_password = !show_password),
                          child: Icon(
                            show_password
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 20,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Informasi Usaha",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  buildInputField(
                    icon: Icons.storefront_outlined,
                    child: TextField(
                      controller: business,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Nama Usaha"),
                    ),
                  ),
                  const SizedBox(height: 30),
                  !proccess
                      ? ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _signup();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Daftar",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            )
                          )
                        )
                      : Container(
                          height: 48,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              const Text("Mendaftar...",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Sudah punya akun? Masuk",
                      style: GoogleFonts.roboto(
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
        ),
      ),
    );
  }
}
