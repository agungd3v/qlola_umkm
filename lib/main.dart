import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/bluetooth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';
import 'package:qlola_umkm/routes/auth_router.dart';
import 'package:qlola_umkm/routes/employee/employee_router.dart';
import 'package:qlola_umkm/routes/mitra/mitra_router.dart';
import 'package:qlola_umkm/routes/super/super_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffc02a34),
      statusBarIconBrightness: Brightness.light));

  await initLocalStorage();
  await dotenv.load(fileName: '.env');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (create) => AuthProvider()),
      ChangeNotifierProvider(create: (create) => CheckoutProvider()),
      ChangeNotifierProvider(create: (create) => OwnerProvider()),
      ChangeNotifierProvider(create: (create) => BluetoothProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  late GoRouter router;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth_provider = Provider.of<AuthProvider>(context);

    // Initial route logic based on user state
    if (auth_provider.user == null) {
      router = AuthRouter.router; // No user logged in, show auth routes
    } else {
      if (auth_provider.user["role"] == "owner") {
        router = SuperRouter.router; // Owner role
      } else if (auth_provider.user["role"] == "karyawan") {
        router = EmployeeRouter.router; // Employee role
      } else if (auth_provider.user["role"] == 'mitra') {
        router = MitraRouter.router; // Mitra role
      }
    }

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Theme(
          data: ThemeData(
              primaryColor: Color(0xffc02a34),
              indicatorColor: Color(0xffc02a34),
              focusColor: Color(0xffc02a34),
              dividerColor: Color(0xffd6dfeb),
              disabledColor: Color(0xff6d7588),
              primaryColorDark: Color(0xff292929),
              scaffoldBackgroundColor: Colors.white),
          child: CupertinoApp.router(
            title: 'Qlola UMKM',
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale("en"), Locale("id")],
          ),
        );
      },
    );
  }
}
