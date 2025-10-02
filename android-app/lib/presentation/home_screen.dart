import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pocket Lawyer')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Chat'),
            onTap: () => Navigator.pushNamed(context, '/chat'),
          ),
          ListTile(
            title: const Text('Prompts Library'),
            onTap: () => Navigator.pushNamed(context, '/prompts'),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }
}
