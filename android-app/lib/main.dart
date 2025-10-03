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
      onGenerateRoute: (settings) {
        // Handle routes with arguments
        if (settings.name == '/chat') {
          return MaterialPageRoute(
            builder: (context) => const ChatScreen(),
            settings: settings,
          );
        }
        // Default routes
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const SplashScreen());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/prompts':
            return MaterialPageRoute(builder: (context) => const PromptsScreen());
          case '/settings':
            return MaterialPageRoute(builder: (context) => const SettingsScreen());
          default:
            return MaterialPageRoute(builder: (context) => const SplashScreen());
        }
      },
    );
  }
}
