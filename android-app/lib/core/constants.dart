/// Application constants
class AppConstants {
  static const String appName = 'Pocket Lawyer';
  static const String appVersion = '1.0.0';

  // API endpoints
  static const String baseUrl = 'https://api.pocketlawyer.com';

  // External API endpoints
  static const String legiScanBaseUrl = 'https://api.legiscan.com';
  static const String congressGovBaseUrl = 'https://api.congress.gov/v3';
  static const String openAiBaseUrl = 'https://api.openai.com/v1';

  // API Keys (should be stored securely in production)
  static const String legiScanApiKey = '6da9b568d057150d0f032566d5ca54e4';
  static const String congressGovApiKey =
      'mXdjKaTeDzfwekxPaPILvoa8malhIenpSNtmCkwI';

  // Storage keys
  static const String apiKeyStorageKey = 'api_key';
  static const String userSettingsKey = 'user_settings';
  static const String openAiApiKey =
      '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';

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
}
