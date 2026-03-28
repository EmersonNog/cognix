import 'package:flutter/cupertino.dart';
import 'pages/auth/signin.dart';

class Routes {
  static Map<String, Widget Function(BuildContext context)> routes =
      <String, WidgetBuilder>{'login': (context) => const SignIn()};

  static String initialRoute = 'login';
}
