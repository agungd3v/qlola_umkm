import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/screens/auth/signin.dart';
import 'package:qlola_umkm/screens/auth/signup.dart';

class AuthRouter {
  AuthRouter._();

  static String initRoute = '/signin';
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: initRoute,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/signin',
        name: 'Sign In',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return SigninScreen(key: state.pageKey);
        }
      ),
      GoRoute(
        path: '/signup',
        name: 'Sign Up',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return SignupScreen(key: state.pageKey);
        }
      )
    ]
  );
}