import 'package:flutter/cupertino.dart';
import 'pages/auth/signin.dart';
import 'pages/auth/signup.dart';
import 'pages/home/home.dart';
import 'pages/auth/forgot_password.dart';

class Routes {
  static Map<String, Widget Function(BuildContext context)> routes =
      <String, WidgetBuilder>{
        'login': (context) => const SignIn(),
        'register': (context) => const SignUp(),
        'home': (context) => const Home(),
        'forgot': (context) => const ForgotPassword(),
      };

  static String initialRoute = 'login';
}
