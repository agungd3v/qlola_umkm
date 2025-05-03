import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/screens/auth/signin.dart';
import 'package:qlola_umkm/screens/auth/signup.dart';

class AuthRouter {
  AuthRouter._();

  static const String initialRoute = '/signin';

  static List<GoRoute> get routes {
    return [
      GoRoute(
        path: '/auth/signin',
        name: 'Sign In',
        builder: (context, state) {
          return SigninScreen(key: state.pageKey);
        }
      ),
      GoRoute(
        path: '/auth/signup',
        name: 'Sign Up',
        builder: (context, state) {
          return SignupScreen(key: state.pageKey);
        }
      )
    ];
  }
}