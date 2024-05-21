import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/routes/auth_router.dart';
import 'package:qlola_umkm/routes/employee/employee_router.dart';
import 'package:qlola_umkm/routes/super/super_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLocalStorage();
  await dotenv.load(fileName: '.env');

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (create) => AuthProvider())
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
          // DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate
        ]
      )
    );
  }
}
