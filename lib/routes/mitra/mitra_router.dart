import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/routes/mitra/tab_index.dart';
import 'package:qlola_umkm/screens/employee/employee_home.dart';
import 'package:qlola_umkm/screens/employee/employee_profile.dart';
import 'package:qlola_umkm/screens/employee/employee_transaction.dart';

class MitraRouter {
  MitraRouter._();

  static String initRoute = '/home';
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _rootNavigatorTransaction =
      GlobalKey<NavigatorState>(debugLabel: 'shellTransaction');
  static final _rootNavigatorProfile =
      GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

  static final GoRouter router = GoRouter(
      initialLocation: initRoute,
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: [
        StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return TabIndex(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(navigatorKey: _rootNavigatorHome, routes: [
                GoRoute(
                    path: '/home',
                    name: 'Home',
                    builder: (context, state) {
                      return EmployeeHomeScreen(key: state.pageKey);
                    })
              ]),
              StatefulShellBranch(
                  navigatorKey: _rootNavigatorTransaction,
                  routes: [
                    GoRoute(
                        path: '/transaction',
                        name: 'Transaction',
                        builder: (context, state) {
                          return EmployeeTransactionScreen(key: state.pageKey);
                        })
                  ]),
              StatefulShellBranch(navigatorKey: _rootNavigatorProfile, routes: [
                GoRoute(
                    path: '/profile',
                    name: 'Profile',
                    builder: (context, state) {
                      return EmployeeProfileScreen(key: state.pageKey);
                    })
              ])
            ]),
      ]);
}
