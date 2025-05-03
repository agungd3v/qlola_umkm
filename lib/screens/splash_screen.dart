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
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/splash_image.png", width: 320, height: 320, fit: BoxFit.cover),
          ]
        )
      )
    );
  }
}
