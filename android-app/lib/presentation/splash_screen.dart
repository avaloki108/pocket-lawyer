import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/biometric_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final BiometricService _biometricService = BiometricService();
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAuth();
  }

  /// Navigates to the home screen after a 10‑second delay.
  Future<void> _goHome() async {
    if (!mounted || _navigated) return;
    _navigated = true;
    // 10 000 ms = 10 seconds
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _checkBiometricAuth() async {
    final disableBiometric =
        (dotenv.maybeGet('DISABLE_BIOMETRIC') ?? 'false').toLowerCase() == 'true';
    if (disableBiometric) {
      await _goHome();
      return;
    }

    final isAvailable = await _biometricService.isBiometricAvailable();

    if (isAvailable) {
      final authenticated = await _biometricService.authenticate(
        localizedReason: 'Authenticate to access Pocket Lawyer',
      );

      if (authenticated) {
        await _goHome();
      } else {
        _showAuthFailedDialog();
      }
    } else {
      await _goHome();
    }
  }

  void _showAuthFailedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Failed'),
        content: const Text('Unable to authenticate. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkBiometricAuth();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
