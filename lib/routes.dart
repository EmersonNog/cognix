import 'pages/auth/forgot_password.dart';
import 'package:flutter/cupertino.dart';
import 'pages/account_security/account_security_screen.dart';
import 'pages/plan/plan_screen.dart';
import 'pages/auth/signin.dart';
import 'pages/auth/signup.dart';
import 'pages/home/home.dart';
import 'pages/study_plan/study_plan_screen.dart';
import 'pages/support/support_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext context)> routes =
      <String, WidgetBuilder>{
        'login': (context) => const SignIn(),
        'register': (context) => const SignUp(),
        'forgot': (context) => const ForgotPassword(),
        'account-security': (context) => const AccountSecurityScreen(),
        'home': (context) => const Home(),
        'plan': (context) => const PlanScreen(),
        'study-plan': (context) => const StudyPlanScreen(),
        'support': (context) => const SupportScreen(),
      };

  static String initialRoute = 'login';
}
