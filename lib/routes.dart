import 'package:flutter/cupertino.dart';
import 'pages/auth/signin.dart';
import 'pages/home/home.dart';
import 'pages/plan/plan_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext context)> routes =
      <String, WidgetBuilder>{
        'login': (context) => const SignIn(),
        'home': (context) => const Home(),
        'plan': (context) => const PlanScreen(),
      };

  static String initialRoute = 'login';
}
