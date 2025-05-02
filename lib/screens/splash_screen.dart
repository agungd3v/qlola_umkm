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

    // Delay 3 detik sebelum navigasi
    Future.delayed(const Duration(seconds: 3), () {
      final auth_provider = Provider.of<AuthProvider>(context, listen: false);

      if (auth_provider.user == null) {
        // Arahkan ke rute Auth jika tidak ada user yang login
        context.go('/signin');
      } else {
        // Arahkan ke rute yang sesuai berdasarkan role user
        if (auth_provider.user["role"] == "owner") {
          context.go('/super');
        } else if (auth_provider.user["role"] == "karyawan") {
          context.go('/employee');
        } else if (auth_provider.user["role"] == "mitra") {
          context.go('/mitra');
        }
      }
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
            // Ikon terkait bisnis
            Icon(
              Icons.business, // Anda bisa mengganti ikon ini jika diperlukan
              size: 150, // Ukuran ikon
              color: Colors.white, // Warna ikon (putih agar kontras)
            ),
            const SizedBox(height: 20), // Spasi antara ikon dan teks
            // Nama Aplikasi atau Tagline
            Text(
              'Qlola UMKM',
              style: TextStyle(
                fontFamily: 'Poppins', // Menggunakan font keluarga aplikasi
                fontWeight: FontWeight.w700,
                fontSize: 24, // Ukuran font
                color: Colors.white, // Warna teks (putih untuk kontras)
              ),
            ),
            const SizedBox(height: 10), // Spasi antara nama dan tagline
            // Tagline atau deskripsi
            Text(
              'Memberdayakan Usaha Kecil, Menengah, dan Besar',
              style: TextStyle(
                fontFamily: 'Poppins', // Menggunakan font keluarga aplikasi
                fontWeight: FontWeight.w500,
                fontSize: 14, // Ukuran font untuk tagline
                color: Colors.white.withOpacity(
                    0.7), // Warna teks dengan opacity agar lebih kontras
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
