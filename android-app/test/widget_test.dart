// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:android_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Provide minimal env for tests with biometric disabled
    dotenv.testLoad(fileInput: 'DISABLE_BIOMETRIC=true');
  });

  testWidgets('App loads and shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump();

    // Initial frame (splash) - only logo is visible
    expect(find.byWidgetPredicate((widget) => widget is Image), findsAtLeastNWidgets(1));

    // Verify app loaded successfully
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));

    // Let timers and navigation complete
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}
