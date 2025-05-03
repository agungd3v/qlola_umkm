import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user == null) {
        context.go('/auth/signin');
        return;
      }

      final role = user['role'];
      final redirectMap = {
        'owner': '/owner',
        'karyawan': '/employee',
        'mitra': '/mitra',
      };

      final target = redirectMap[role] ?? '/auth/signin';
      context.go(target);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).primaryColor, // Warna latar belakang sesuai tema
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-qlola.png',
              width: 500,
              height: 500,
            ),
            const SizedBox(height: 20),
            // Text(
            //   'Qlola UMKM',
            //   style: TextStyle(
            //     fontFamily: 'Poppins',
            //     fontWeight: FontWeight.w700,
            //     fontSize: 24,
            //     color: Colors.white,
            //   ),
            // ),
            // const SizedBox(height: 10), // Spasi antara nama dan tagline
            // Tagline atau deskripsi
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Text(
            //     'Memberdayakan Usaha Kecil, Menengah, dan Besar',
            //     style: TextStyle(
            //       fontFamily: 'Poppins', // Menggunakan font keluarga aplikasi
            //       fontWeight: FontWeight.w500,
            //       fontSize: 14, // Ukuran font untuk tagline
            //       color: Colors.white.withOpacity(
            //           0.7), // Warna teks dengan opacity agar lebih kontras
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
