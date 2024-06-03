import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/routes/employee/tab_index.dart';
import 'package:qlola_umkm/screens/employee/complete_oreder.dart';
import 'package:qlola_umkm/screens/employee/employee_checkout.dart';
import 'package:qlola_umkm/screens/employee/employee_home.dart';
import 'package:qlola_umkm/screens/employee/employee_order.dart';
import 'package:qlola_umkm/screens/employee/employee_transaction.dart';

class EmployeeRouter {
  EmployeeRouter._();

  static String initRoute = '/home';
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _rootNavigatorOrder = GlobalKey<NavigatorState>(debugLabel: 'shellOrder');
  static final _rootNavigatorTransaction = GlobalKey<NavigatorState>(debugLabel: 'shellTransaction');

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
          StatefulShellBranch(
            navigatorKey: _rootNavigatorHome,
            routes: [
              GoRoute(
                path: '/home',
                name: 'Home',
                builder: (context, state) {
                  return EmployeeHomeScreen(key: state.pageKey);
                }
              )
            ]
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorOrder,
            routes: [
              GoRoute(
                path: '/order',
                name: 'Order',
                builder: (context, state) {
                  return EmployeeOrderScreen(key: state.pageKey);
                }
              )
            ]
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorTransaction,
            routes: [
              GoRoute(
                path: '/transaction',
                name: 'Transaction',
                builder: (context, state) {
                  return EmployeeTransactionScreen(key: state.pageKey);
                }
              )
            ]
          )
        ]
      ),
      GoRoute(
        path: '/checkout',
        name: 'Checkout',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return EmployeeCheckoutScreen(key: state.pageKey);
        }
      ),
      GoRoute(
        path: '/complete',
        name: 'Complete',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return CompleteOrederScreen(key: state.pageKey);
        }
      )
    ]
  );
}