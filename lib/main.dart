import 'dart:async';

import 'package:cognix/theme/app_theme.dart';
import 'package:cognix/theme/app_theme_controller.dart';
import 'package:cognix/theme/app_theme_scope.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'navigation/app_route_observer.dart';
import 'pages/onboarding/onboarding_gate.dart';
import 'pages/training/pomodoro/training_pomodoro_overlay_controller.dart';
import 'pages/training/pomodoro/widgets/training_pomodoro_global_indicator.dart';
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
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _themeController.load();
    unawaited(trainingPomodoroOverlayController.hydrate());
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      unawaited(trainingPomodoroOverlayController.hydrate());
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
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
            scaffoldMessengerKey: appScaffoldMessengerKey,
            navigatorKey: appNavigatorKey,
            home: const OnboardingGate(),
            routes: Routes.routes,
            navigatorObservers: [appRouteObserver],
            builder: (context, child) {
              if (child == null) return const SizedBox.shrink();
              return Stack(
                children: [child, const TrainingPomodoroGlobalIndicator()],
              );
            },
          ),
        );
      },
    );
  }
}
