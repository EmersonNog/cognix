import 'pages/auth/forgot_password.dart';
import 'package:flutter/cupertino.dart';
import 'pages/plan/plan_screen.dart';
import 'pages/auth/signin.dart';
import 'pages/auth/signup.dart';
import 'pages/home/home.dart';

class Routes {
  static Map<String, Widget Function(BuildContext context)> routes =
      <String, WidgetBuilder>{
        'login': (context) => const SignIn(),
        'register': (context) => const SignUp(),
        'forgot': (context) => const ForgotPassword(),
        'home': (context) => const Home(),
        'plan': (context) => const PlanScreen(),
      };

  static String initialRoute = 'login';
}
