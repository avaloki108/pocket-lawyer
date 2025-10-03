/// Application constants
class AppConstants {
  static const String appName = 'Pocket Lawyer';
  static const String appVersion = '1.0.0';

  // Backend base URL (all external API calls must be proxied through backend)
  static const String baseUrl = 'https://api.pocketlawyer.com';

  // Backend proxy endpoint prefixes
  static const String backendOpenRouterPath = '/openrouter';
  static const String backendLegiScanPath = '/legiscan';
  static const String backendCongressPath = '/congress';
  static const String backendCourtListenerPath = '/courtlistener';

  // Storage keys
  static const String userSettingsKey = 'user_settings';

  // Encryption
  static const int aesKeyLength = 256;
  static const int ivLength = 16;

  // Cache
  static const Duration cacheExpiration = Duration(days: 30);

  // Legal topics
  static const List<String> legalTopics = [
    'employment',
    'real_estate',
    'criminal',
    'traffic',
    'business',
    'health',
    'family',
    'tax',
    'immigration',
    'consumer_protection',
  ];

  // No API keys should be present or required on the client.
  static List<String> missingRequiredKeys() => const <String>[];
}
