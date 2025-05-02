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

  static final homeKey = GlobalKey<NavigatorState>(debugLabel: 'ownerHome');
  static final productKey = GlobalKey<NavigatorState>(debugLabel: 'ownerProduct');
  static final outletKey = GlobalKey<NavigatorState>(debugLabel: 'ownerKey');
  static final employeeKey = GlobalKey<NavigatorState>(debugLabel: 'ownerEmployee');
  static final profileKey = GlobalKey<NavigatorState>(debugLabel: 'ownerProfile');

  static final List<RouteBase> routes = [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => TabIndex(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: homeKey,
          routes: [
            GoRoute(
              path: "/owner",
              name: "Owner Home",
              builder: (context, state) {
                return HomeScreen(key: state.pageKey);
              }
            )
          ]
        ),
        StatefulShellBranch(
          navigatorKey: productKey,
          routes: [
            GoRoute(
              path: '/owner/product',
              name: "Owner Product",
              builder: (context, state) {
                return ProductScreen(key: state.pageKey);
              }
            )
          ]
        ),
        StatefulShellBranch(
          navigatorKey: outletKey,
          routes: [
            GoRoute(
              path: '/owner/outlet',
              name: "Owner Outlet",
              builder: (context, state) {
                return OutletScreen(key: state.pageKey);
              }
            )
          ]
        ),
        StatefulShellBranch(
          navigatorKey: employeeKey,
          routes: [
            GoRoute(
              path: '/owner/employee',
              name: "Owner Employee",
              builder: (context, state) {
                return EmployeeScreen(key: state.pageKey);
              }
            )
          ]
        ),
        StatefulShellBranch(
          navigatorKey: profileKey,
          routes: [
            GoRoute(
              path: '/owner/profile',
              name: "Owner Profile",
              builder: (context, state) {
                return ProfileScreen(key: state.pageKey);
              }
            )
          ]
        )
      ]
    ),
    GoRoute(
      path: '/owner/add_product',
      name: "Owner Add Product",
      builder: (context, state) {
        return AddProductScreen(key: state.pageKey);
      }
    ),
    GoRoute(
      path: '/owner/edit_product',
      name: "Owner Edit Product",
      builder: (context, state) {
        return EditProductScreen(key: state.pageKey);
      }
    ),
    GoRoute(
      path: '/owner/add_outlet',
      name: "Owner Add Outlet",
      builder: (context, state) {
        return AddOutletScreen(key: state.pageKey);
      }
    ),
    GoRoute(
      path: '/owner/add_outlet_employee',
      name: "Owner Outlet Employee",
      builder: (context, state) {
        final outlet = state.extra! as dynamic;
        return AddOutletEmployeeScreen(key: state.pageKey, outlet: outlet);
      }
    ),
    GoRoute(
      path: '/owner/add_mitra',
      name: "Owner Add Mitra",
      builder: (context, state) {
        return AddMitra(key: state.pageKey);
      }
    ),
    GoRoute(
      path: '/owner/add_outlet_product',
      name: "Owner Add Outlet Product",
      builder: (context, state) {
        final outlet = state.extra! as dynamic;
        return AddOutletProductScreen(key: state.pageKey, outlet: outlet);
      }
    ),
    GoRoute(
      path: '/owner/add_employee',
      name: "Owner Add Employee",
      builder: (context, state) {
        return AddEmployeeScreen(key: state.pageKey);
      }
    ),
    GoRoute(
      path: '/owner/history_transaction',
      name: "Owner History Transaction",
      builder: (context, state) {
        return HistoryTransactionScreen(key: state.pageKey);
      }
    ),
    GoRoute(
      path: '/owner/delete_transaction',
      name: "Owner Delete Transaction",
      builder: (context, state) {
        return DeleteTransactionScreen(key: state.pageKey);
      }
    ),
    GoRoute(
      path: '/owner/transaction',
      name: "Owner Transaction",
      builder: (context, state) {
        return TransactionScreen(key: state.pageKey);
      }
    ),
    GoRoute(
      path: '/owner/report',
      name: "Owner Report",
      builder: (context, state) {
        return ReportScreen(key: state.pageKey);
      }
    )
  ];
}
