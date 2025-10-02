import 'package:dio/dio.dart';
import '../core/constants.dart';

class OpenAiApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.openAiBaseUrl,
      headers: {
        'Authorization': 'Bearer ${AppConstants.openAiApiKey}',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<String> generate({
    required String prompt,
    String model = 'gpt-4o-mini',
    double temperature = 0.3,
    int maxTokens = 1000,
  }) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a legal assistant providing information based on statutes and case law. Always cite sources and include disclaimers.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'temperature': temperature,
          'max_tokens': maxTokens,
        },
      );

      if (response.statusCode == 200) {
        final choices = response.data['choices'] as List;
        if (choices.isNotEmpty) {
          return choices[0]['message']['content'] as String;
        }
      }
      throw Exception('Failed to get response from OpenAI');
    } catch (e) {
      throw Exception('OpenAI API error: $e');
    }
  }
}
