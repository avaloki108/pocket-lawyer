import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  static const String courtListenerBaseUrl = 'https://www.courtlistener.com/api/rest/v4';

  // Compile-time dart-define values (empty if not provided)
  static const String _openAiFromDefine = String.fromEnvironment('OPENAI_API_KEY');
  static const String _legiScanFromDefine = String.fromEnvironment('LEGISCAN_API_KEY');
  static const String _congressFromDefine = String.fromEnvironment('CONGRESS_GOV_API_KEY');
  static const String _pineconeFromDefine = String.fromEnvironment('PINECONE_API_KEY');
  static const String _courtListenerFromDefine = String.fromEnvironment('COURTLISTENER_API_KEY');

  // Resolved API keys (priority: dart-define > .env > empty)
  static String get openAiApiKey => _openAiFromDefine.isNotEmpty
      ? _openAiFromDefine
      : (dotenv.maybeGet('OPENAI_API_KEY') ?? '');
  static String get legiScanApiKey => _legiScanFromDefine.isNotEmpty
      ? _legiScanFromDefine
      : (dotenv.maybeGet('LEGISCAN_API_KEY') ?? '');
  static String get congressGovApiKey => _congressFromDefine.isNotEmpty
      ? _congressFromDefine
      : (dotenv.maybeGet('CONGRESS_GOV_API_KEY') ?? '');
  static String get pineconeApiKey => _pineconeFromDefine.isNotEmpty
      ? _pineconeFromDefine
      : (dotenv.maybeGet('PINECONE_API_KEY') ?? '');
  static String get courtListenerApiKey => _courtListenerFromDefine.isNotEmpty
      ? _courtListenerFromDefine
      : (dotenv.maybeGet('COURTLISTENER_API_KEY') ?? '');

  // Storage keys
  static const String apiKeyStorageKey = 'api_key';
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

  /// Utility: quick validation to ensure critical API keys are present (after dotenv load).
  static List<String> missingRequiredKeys() {
    final missing = <String>[];
    if (openAiApiKey.isEmpty) missing.add('OPENAI_API_KEY');
    if (legiScanApiKey.isEmpty) missing.add('LEGISCAN_API_KEY');
    if (congressGovApiKey.isEmpty) missing.add('CONGRESS_GOV_API_KEY');
    return missing;
  }
}
