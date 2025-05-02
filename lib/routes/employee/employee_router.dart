import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/routes/employee/tab_index.dart';
import 'package:qlola_umkm/screens/employee/complete_oreder.dart';
import 'package:qlola_umkm/screens/employee/employee_checkout.dart';
import 'package:qlola_umkm/screens/employee/employee_home.dart';
import 'package:qlola_umkm/screens/employee/employee_order.dart';
import 'package:qlola_umkm/screens/employee/employee_printers.dart';
import 'package:qlola_umkm/screens/employee/employee_profile.dart';
import 'package:qlola_umkm/screens/employee/employee_transaction.dart';

class EmployeeRouter {
  EmployeeRouter._();

  static final homeKey = GlobalKey<NavigatorState>(debugLabel: 'employeeHome');
  static final orderKey = GlobalKey<NavigatorState>(debugLabel: 'employeeOrder');
  static final transactionKey = GlobalKey<NavigatorState>(debugLabel: 'employeeTransaction');
  static final profileKey = GlobalKey<NavigatorState>(debugLabel: 'employeeProfile');

  static final List<RouteBase> routes = [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => TabIndex(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: homeKey,
          routes: [
            GoRoute(
              path: '/employee',
              name: "Employee Home",
              builder: (context, state) {
                return EmployeeHomeScreen(key: state.pageKey);
              }
            )
          ]
        ),
        StatefulShellBranch(
          navigatorKey: orderKey,
          routes: [
            GoRoute(
              path: '/employee/order',
              name: "Employee Order",
              builder: (context, state) {
                return EmployeeOrderScreen(key: state.pageKey);
              }
            )
          ]
        ),
        StatefulShellBranch(
          navigatorKey: transactionKey,
          routes: [
            GoRoute(
              path: '/employee/transaction',
              name: "Employee Transaction",
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
              path: '/employee/profile',
              name: "Employee Profile",
              builder: (context, state) {
                return EmployeeProfileScreen(key: state.pageKey);
              }
            )
          ]
        )
      ]
    ),
    GoRoute(
      path: '/employee/printers',
      name: "Employee Printer",
      builder: (context, state) {
        return EmployeePrintersScreen(key: state.pageKey);
      }
    ),
    GoRoute(
      path: '/employee/checkout',
      name: "Employee Checkout",
      builder: (context, state) {
        return EmployeeCheckoutScreen(key: state.pageKey);
      }
    ),
    GoRoute(
      path: '/employee/complete',
      name: "Employee Complete",
      builder: (context, state) {
        return CompleteOrederScreen(key: state.pageKey);
      }
    )
  ];
}
