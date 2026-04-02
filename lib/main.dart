import 'package:firebase_core/firebase_core.dart';
import 'pages/onboarding/onboarding_gate.dart';
import 'navigation/app_route_observer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingGate(),
      routes: Routes.routes,
      navigatorObservers: [appRouteObserver],
    );
  }
}
