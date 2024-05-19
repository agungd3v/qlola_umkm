import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:qlola_umkm/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLocalStorage();
  await dotenv.load(fileName: '.env');

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        routerConfig: AppRouter.superRouter,
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          // DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate
        ]
      )
    );
  }
}
