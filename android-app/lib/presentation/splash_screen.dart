import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/biometric_service.dart';
import '../core/accessibility_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final BiometricService _biometricService = BiometricService();
  final AccessibilityService _accessibilityService = AccessibilityService();
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAuth();
  }

  Future<void> _goHome() async {
    if (!mounted || _navigated) return;
    _navigated = true;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> _checkBiometricAuth() async {
    final disableBiometric = (dotenv.maybeGet('DISABLE_BIOMETRIC') ?? 'false').toLowerCase() == 'true';
    if (disableBiometric) {
      await _goHome();
      return;
    }

    final isAvailable = await _biometricService.isBiometricAvailable();

    if (isAvailable) {
      _accessibilityService.announce('Biometric authentication required');

      final authenticated = await _biometricService.authenticate(
        localizedReason: 'Authenticate to access Pocket Lawyer',
      );

      if (authenticated) {
        _accessibilityService.announce('Authentication successful');
        await _goHome();
      } else {
        _accessibilityService.announce('Authentication failed');
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
              _checkBiometricAuth(); // Retry
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.blueAccent],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security, size: 80, color: Colors.white),
              SizedBox(height: 24),
              Text(
                'Pocket Lawyer',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Authenticating...',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
