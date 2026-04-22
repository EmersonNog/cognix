import 'package:cognix/theme/app_theme.dart';
import 'package:cognix/theme/app_theme_controller.dart';
import 'package:cognix/theme/app_theme_scope.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'navigation/app_route_observer.dart';
import 'pages/onboarding/onboarding_gate.dart';
import 'routes.dart';
import 'services/media/image_picker_recovery.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ImagePickerRecovery.instance.retrieveLostData();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppThemeController _themeController = AppThemeController();

  @override
  void initState() {
    super.initState();
    _themeController.load();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        return AppThemeScope(
          controller: _themeController,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: _themeController.themeMode,
            home: const OnboardingGate(),
            routes: Routes.routes,
            navigatorObservers: [appRouteObserver],
          ),
        );
      },
    );
  }
}
