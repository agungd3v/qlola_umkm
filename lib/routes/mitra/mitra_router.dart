import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/routes/mitra/tab_index.dart';
import 'package:qlola_umkm/screens/employee/employee_home.dart';
import 'package:qlola_umkm/screens/employee/employee_profile.dart';
import 'package:qlola_umkm/screens/employee/employee_transaction.dart';

class MitraRouter {
  MitraRouter._();

  static final homeKey = GlobalKey<NavigatorState>(debugLabel: 'mitraHome');
  static final transactionKey = GlobalKey<NavigatorState>(debugLabel: 'mitraTransaction');
  static final profileKey = GlobalKey<NavigatorState>(debugLabel: 'mitraProfile');

  static final List<RouteBase> routes = [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => TabIndex(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: homeKey,
          routes: [
            GoRoute(
              path: '/mitra',
              name: "Mitra Home",
              builder: (context, state) {
                return EmployeeHomeScreen(key: state.pageKey);
              }
            )
          ]
        ),
        StatefulShellBranch(
          navigatorKey: transactionKey,
          routes: [
            GoRoute(
              path: '/mitra/transaction',
              name: "Mitra Transaction",
              builder: (context, state) {
                return EmployeeTransactionScreen(key: state.pageKey);
              }
            )
          ]
        ),
        StatefulShellBranch(
          navigatorKey: profileKey,
          routes: [
            GoRoute(
              path: '/mitra/profile',
              name: "Mitra Profile",
              builder: (context, state) {
                return EmployeeProfileScreen(key: state.pageKey);
              }
            )
          ]
        )
      ]
    )
  ];
}
