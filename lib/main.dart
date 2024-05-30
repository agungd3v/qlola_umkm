import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';
import 'package:qlola_umkm/routes/auth_router.dart';
import 'package:qlola_umkm/routes/employee/employee_router.dart';
import 'package:qlola_umkm/routes/super/super_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xffc02a34),
    statusBarIconBrightness: Brightness.light
  ));

  await initLocalStorage();
  await dotenv.load(fileName: '.env');
  // await PrintBluetoothThermal.pairedBluetooths;

  final httpRequest = await check_user();
  if (httpRequest["status"] == 401) {
    localStorage.removeItem("user");
    localStorage.removeItem("token");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (create) => AuthProvider()),
        ChangeNotifierProvider(create: (create) => CheckoutProvider()),
        ChangeNotifierProvider(create: (create) => OwnerProvider())
      ],
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  late GoRouter router;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth_provider = Provider.of<AuthProvider>(context);

    if (auth_provider.user == null) {
      router = AuthRouter.router;
    } else {
      if (auth_provider.user["role"] == "owner") {
        router = SuperRouter.router;
      }
      if (auth_provider.user["role"] == "karyawan") {
        router = EmployeeRouter.router;
      }
    }

    return Theme(
      data: ThemeData(
        primaryColor: Color(0xffc02a34),
        indicatorColor: Color(0xffc02a34),
        focusColor: Color(0xffc02a34),
        dividerColor: Color(0xffd6dfeb),
        disabledColor: Color(0xff6d7588),
        primaryColorDark: Color(0xff292929),
        scaffoldBackgroundColor: Colors.white
      ),
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
        supportedLocales: [
          Locale("en"),
          Locale("id")
        ],
      )
    );
  }
}
