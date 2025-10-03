import 'package:dio/dio.dart';
import '../core/constants.dart';

class OpenAiApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {
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
        '${AppConstants.backendOpenAiPath}/chat',
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
        // Expect the backend to normalize the response
        final content = response.data['content'] ??
            (response.data['choices'] != null && (response.data['choices'] as List).isNotEmpty
                ? response.data['choices'][0]['message']['content']
                : null);
        if (content is String) {
          return content;
        }
      }
      throw Exception('Failed to get response from backend OpenAI proxy');
    } catch (e) {
      throw Exception('OpenAI API error: $e');
    }
  }
}
