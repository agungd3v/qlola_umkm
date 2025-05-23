import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/routes/super/tab_index.dart';
import 'package:qlola_umkm/screens/add_employee.dart';
import 'package:qlola_umkm/screens/add_mitra.dart';
import 'package:qlola_umkm/screens/add_outlet.dart';
import 'package:qlola_umkm/screens/add_outlet_employee.dart';
import 'package:qlola_umkm/screens/add_outlet_product.dart';
import 'package:qlola_umkm/screens/add_product.dart';
import 'package:qlola_umkm/screens/delete_transaction.dart';
import 'package:qlola_umkm/screens/edit_product.dart';
import 'package:qlola_umkm/screens/employee.dart';
import 'package:qlola_umkm/screens/history_transaction.dart';
import 'package:qlola_umkm/screens/home.dart';
import 'package:qlola_umkm/screens/outlet.dart';
import 'package:qlola_umkm/screens/product.dart';
import 'package:qlola_umkm/screens/profile.dart';
import 'package:qlola_umkm/screens/report/report.dart';
import 'package:qlola_umkm/screens/transaction.dart';

class SuperRouter {
  SuperRouter._();

  static String initSuperRoute = '/home';
  static final _rootSuperNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootSuperNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _rootSuperNavigatorProduct =
      GlobalKey<NavigatorState>(debugLabel: 'shellProduct');
  static final _rootSuperNavigatorOutlet =
      GlobalKey<NavigatorState>(debugLabel: 'shellOutlet');
  static final _rootSuperNavigatorEmployee =
      GlobalKey<NavigatorState>(debugLabel: 'shellEmployee');
  static final _rootSuperNavigatorProfile =
      GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

  static final GoRouter router = GoRouter(
      initialLocation: initSuperRoute,
      navigatorKey: _rootSuperNavigatorKey,
      debugLogDiagnostics: true,
      routes: [
        StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return TabIndex(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(
                  navigatorKey: _rootSuperNavigatorHome,
                  routes: [
                    GoRoute(
                        path: '/home',
                        name: 'Home',
                        builder: (context, state) {
                          return HomeScreen(key: state.pageKey);
                        })
                  ]),
              StatefulShellBranch(
                  navigatorKey: _rootSuperNavigatorProduct,
                  routes: [
                    GoRoute(
                        path: '/product',
                        name: 'Product',
                        builder: (context, state) {
                          return ProductScreen(key: state.pageKey);
                        })
                  ]),
              StatefulShellBranch(
                  navigatorKey: _rootSuperNavigatorOutlet,
                  routes: [
                    GoRoute(
                        path: '/outlet',
                        name: 'Outlet',
                        builder: (context, state) {
                          return OutletScreen(key: state.pageKey);
                        })
                  ]),
              StatefulShellBranch(
                  navigatorKey: _rootSuperNavigatorEmployee,
                  routes: [
                    GoRoute(
                        path: '/employee',
                        name: 'Employee',
                        builder: (context, state) {
                          return EmployeeScreen(key: state.pageKey);
                        })
                  ]),
              StatefulShellBranch(
                  navigatorKey: _rootSuperNavigatorProfile,
                  routes: [
                    GoRoute(
                        path: '/profile',
                        name: 'Profile',
                        builder: (context, state) {
                          return ProfileScreen(key: state.pageKey);
                        })
                  ])
            ]),
        GoRoute(
            path: '/add_product',
            name: 'Add Product',
            parentNavigatorKey: _rootSuperNavigatorKey,
            builder: (context, state) {
              return AddProductScreen(key: state.pageKey);
            }),
        GoRoute(
            path: '/edit_product',
            name: 'Edit Product',
            parentNavigatorKey: _rootSuperNavigatorKey,
            builder: (context, state) {
              return EditProductScreen(key: state.pageKey);
            }),
        GoRoute(
            path: '/add_outlet',
            name: 'Add Outlet',
            parentNavigatorKey: _rootSuperNavigatorKey,
            builder: (context, state) {
              return AddOutletScreen(key: state.pageKey);
            }),
        GoRoute(
            path: '/add_outlet_employee',
            name: 'Add Outlet Employee',
            parentNavigatorKey: _rootSuperNavigatorKey,
            builder: (context, state) {
              final outlet = state.extra! as dynamic;

              return AddOutletEmployeeScreen(
                key: state.pageKey,
                outlet: outlet,
              );
            }),
        GoRoute(
            path: '/add_mitra',
            name: 'Add Mitra',
            parentNavigatorKey: _rootSuperNavigatorKey,
            builder: (context, state) {
              return AddMitra(key: state.pageKey);
            }),
        GoRoute(
            path: '/add_outlet_product',
            name: 'Add Outlet Product',
            parentNavigatorKey: _rootSuperNavigatorKey,
            builder: (context, state) {
              final outlet = state.extra! as dynamic;

              return AddOutletProductScreen(
                key: state.pageKey,
                outlet: outlet,
              );
            }),
        GoRoute(
            path: '/add_employee',
            name: 'Add Employee',
            parentNavigatorKey: _rootSuperNavigatorKey,
            builder: (context, state) {
              return AddEmployeeScreen(key: state.pageKey);
            }),
        GoRoute(
            path: '/history_transaction',
            name: 'HistoryTransaction',
            parentNavigatorKey: _rootSuperNavigatorKey,
            builder: (context, state) {
              return HistoryTransactionScreen(key: state.pageKey);
            }),
        GoRoute(
            path: '/delete_transaction',
            name: 'DeleteTransaction',
            parentNavigatorKey: _rootSuperNavigatorKey,
            builder: (context, state) {
              return DeleteTransactionScreen(key: state.pageKey);
            }),
        GoRoute(
            path: '/transaction',
            name: 'Transaction',
            parentNavigatorKey: _rootSuperNavigatorKey,
            builder: (context, state) {
              return TransactionScreen(key: state.pageKey);
            }),
        GoRoute(
            path: '/report',
            name: 'Report',
            parentNavigatorKey: _rootSuperNavigatorKey,
            builder: (context, state) {
              return ReportScreen(key: state.pageKey);
            })
      ]);
}
