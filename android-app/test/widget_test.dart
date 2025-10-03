// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:android_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Provide minimal env so missing key warnings are avoided and biometric is disabled for test.
    dotenv.testLoad(fileInput: 'DISABLE_BIOMETRIC=true\nOPENAI_API_KEY=dummy\nLEGISCAN_API_KEY=dummy\nCONGRESS_GOV_API_KEY=dummy');
  });

  testWidgets('Splash screen navigates to Home and shows menu items', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Initial frame (splash)
    expect(find.text('Pocket Lawyer'), findsOneWidget);
    expect(find.text('Authenticating...'), findsOneWidget);

    // Allow navigation microtasks to complete
    await tester.pumpAndSettle();

    // After navigation: Home screen list tiles
    expect(find.text('Pocket Lawyer'), findsOneWidget); // AppBar title
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Prompts Library'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
