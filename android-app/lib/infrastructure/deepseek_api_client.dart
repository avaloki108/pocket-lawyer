import 'package:dio/dio.dart';

class DeepSeekApiClient {
  final String apiKey;
  final String baseUrl;
  final String defaultModel;
  late final Dio _dio;

  DeepSeekApiClient({
    required this.apiKey,
    this.baseUrl = 'https://api.deepseek.com/v1',
    this.defaultModel = 'deepseek-chat',
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }

  Future<String> chat({
    required List<Map<String, String>> messages,
    String? model,
    double temperature = 0.3,
    int maxTokens = 1000,
  }) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': model ?? defaultModel,
          'messages': messages,
          'temperature': temperature,
          'max_tokens': maxTokens,
        },
      );

      if (response.statusCode == 200) {
        final choices = response.data['choices'];
        if (choices != null && choices is List && choices.isNotEmpty) {
          final content = choices[0]['message']['content'];
          if (content is String) return content;
        }
        throw Exception('Empty choices from DeepSeek response');
      }
      throw Exception('DeepSeek status ${response.statusCode}');
    } catch (e) {
      throw Exception('DeepSeek API error: $e');
    }
  }

  Future<String> generate({
    required String prompt,
    String? model,
    double temperature = 0.3,
    int maxTokens = 1000,
  }) async {

    return chat(
      messages: [
        {
          'role': 'system',
          'content':
              'You are a helpful assistant that translates complex legal text into simple, easy-to-understand language.',
        },
        {'role': 'user', 'content': prompt},
      ],
      model: model,
      temperature: temperature,
      maxTokens: maxTokens,
    );
  }
}

