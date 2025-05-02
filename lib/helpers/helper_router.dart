import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/routes/auth_router.dart';
import 'package:qlola_umkm/routes/employee/employee_router.dart';
import 'package:qlola_umkm/routes/mitra/mitra_router.dart';
import 'package:qlola_umkm/routes/super/super_router.dart';
import 'package:qlola_umkm/screens/splash_screen.dart';

GoRouter buildRouter(AuthProvider authProvider) {
  final user = authProvider.user;

  final allowedRootPaths = {
    'owner': '/owner',
    'karyawan': '/employee',
    'mitra': '/mitra',
  };

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),
      ...AuthRouter.routes,
      ...SuperRouter.routes,
      ...EmployeeRouter.routes,
      ...MitraRouter.routes,
    ],
    redirect: (context, state) {
      return null;
      // if (user == null) {
      //   return '/auth/signin';
      // }

      // final role = user['role'];
      // final fullPath = state.fullPath ?? '';

      // if (allowedRootPaths.containsKey(role) && fullPath.startsWith(allowedRootPaths[role]!)) {
      //   return null;
      // }

      // return allowedRootPaths[role] ?? '/auth/signin';
    }
  );
}
