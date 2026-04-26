import 'package:cognix/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('MyApp builds a MaterialApp shell', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
