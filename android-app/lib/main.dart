import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/constants.dart';
import 'core/themes.dart';
import 'presentation/splash_screen.dart';
import 'presentation/home_screen.dart';
import 'presentation/chat_screen.dart';
import 'presentation/prompts_screen.dart';
import 'presentation/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Attempt to load .env file (optional). If missing, proceed; keys may come from --dart-define.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    try {
      await dotenv.load(fileName: '.env.example');
    } catch (_) {}
  }

  final missing = AppConstants.missingRequiredKeys();
  if (missing.isNotEmpty) {

    print('[PocketLawyer][WARNING] Missing API keys: ${missing.join(', ')}. Some features may not work.');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        '/prompts': (context) => const PromptsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
