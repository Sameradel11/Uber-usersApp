import 'package:go_router/go_router.dart';
import 'package:user_app/Features/Autentication/presentation/views/signin.dart';
import 'package:user_app/Features/Autentication/presentation/views/signup.dart';
import 'package:user_app/Features/home/homeview.dart';
import 'package:user_app/Features/splash/splash_view.dart';

class AppRoutes {
  static const String splashview = "/";
  static const String homeview = "/homeview";
  static const String signin = '/signin';
  static const String signup = '/signup';

  static final routes = GoRouter(routes: [
    GoRoute(path: splashview, builder: (context, state) => const SplashView()),
    GoRoute(path: homeview, builder: (context, state) => const HomeView()),
    GoRoute(path: signup, builder: (context, state) => const SignUp()),
    GoRoute(path: signin, builder: (context, state) => const SignIn()),
  ]);
}
