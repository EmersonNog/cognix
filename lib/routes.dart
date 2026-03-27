import 'package:flutter/cupertino.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages/home.dart';
import 'pages/forgot_password.dart';

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
