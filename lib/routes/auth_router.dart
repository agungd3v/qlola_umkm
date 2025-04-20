import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/screens/auth/signin.dart';
import 'package:qlola_umkm/screens/auth/signup.dart';
import 'package:qlola_umkm/screens/splash_screen.dart';

class AuthRouter {
  AuthRouter._();

  static const String initialRoute =
      '/splash'; // Set splash screen as the initial route
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: initialRoute, // Splash screen route
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen route
      GoRoute(
        path: '/splash',
        name: 'Splash Screen',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return SplashScreen(key: state.pageKey); // Display SplashScreen
        },
      ),

      // SignIn Route
      GoRoute(
        path: '/signin',
        name: 'Sign In',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return SigninScreen(key: state.pageKey); // Navigate to SigninScreen
        },
      ),

      // SignUp Route
      GoRoute(
        path: '/signup',
        name: 'Sign Up',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return SignupScreen(key: state.pageKey); // Navigate to SignupScreen
        },
      ),
    ],
  );
}
