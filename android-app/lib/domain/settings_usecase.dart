import '../data/secure_storage_repository.dart';

class SettingsUseCase {
  final SecureStorageRepository _secureStorage;

  SettingsUseCase(this._secureStorage);

  Future<String?> getApiKey() async {
    return await _secureStorage.get('api_key');
  }

  Future<void> saveApiKey(String apiKey) async {
    await _secureStorage.put('api_key', apiKey);
  }

  Future<void> deleteApiKey() async {
    await _secureStorage.delete('api_key');
  }
}
