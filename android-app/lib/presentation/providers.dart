import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/chat_usecase.dart';
import '../domain/prompts_usecase.dart';
import '../domain/settings_usecase.dart';
import '../data/rag_repository.dart';
import '../data/secure_storage_repository.dart';
import '../data/api_client_repository.dart';
import '../infrastructure/openai_api_client.dart';
import '../infrastructure/legiscan_api_client.dart';
import '../infrastructure/congress_api_client.dart';

// Infrastructure providers
final openAiClientProvider = Provider<OpenAiApiClient>(
  (ref) => OpenAiApiClient(),
);
final legiScanClientProvider = Provider<LegiScanApiClient>(
  (ref) => LegiScanApiClient(),
);
final congressClientProvider = Provider<CongressApiClient>(
  (ref) => CongressApiClient(),
);

// Repository providers
final apiClientRepositoryProvider = Provider<ApiClientRepository>((ref) {
  final openAiClient = ref.read(openAiClientProvider);
  final legiScanClient = ref.read(legiScanClientProvider);
  final congressClient = ref.read(congressClientProvider);
  return ApiClientRepository(openAiClient, legiScanClient, congressClient);
});

final ragRepositoryProvider = Provider<RagRepository>((ref) {
  final apiClient = ref.read(apiClientRepositoryProvider);
  return RagRepositoryImpl(apiClient);
});

final secureStorageProvider = Provider<SecureStorageRepository>(
  (ref) => SecureStorageRepository(),
);

// Use-case providers
final chatUseCaseProvider = Provider<ChatUseCase>((ref) {
  final repo = ref.read(ragRepositoryProvider);
  return ChatUseCase(repo);
});

final promptsUseCaseProvider = Provider<PromptsUseCase>(
  (ref) => PromptsUseCase(),
);

final settingsUseCaseProvider = Provider<SettingsUseCase>((ref) {
  final storage = ref.read(secureStorageProvider);
  return SettingsUseCase(storage);
});

// State providers
final selectedStateProvider = StateProvider<String>((ref) => 'California');
