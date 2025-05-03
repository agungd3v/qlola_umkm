import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/helpers/helper_router.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/bluetooth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = Provider.of<AuthProvider>(context);
    _router = buildRouter(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Theme(
          data: ThemeData(
            primaryColor: Color(0xFF18CB96),
            indicatorColor: Color(0xFF18CB96),
            focusColor: Color(0xFF18CB96),
            dividerColor: Color(0xffd6dfeb),
            disabledColor: Color(0xff6d7588),
            primaryColorDark: Color(0xff292929),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: Colors.white,
            )
          ),
          child: CupertinoApp.router(
            title: 'Qlola UMKM',
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale("en"), Locale("id")],
          )
        );
      }
    );
  }
}
