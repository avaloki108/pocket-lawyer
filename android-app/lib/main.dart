import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants.dart';
import 'core/themes.dart';
import 'presentation/splash_screen.dart';
import 'presentation/home_screen.dart';
import 'presentation/chat_screen.dart';
import 'presentation/prompts_screen.dart';
import 'presentation/settings_screen.dart';

void main() {
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
