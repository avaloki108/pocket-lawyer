import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Lightweight client to talk to a locally running Ollama daemon.
///
/// By default it targets localhost on desktop/web and 10.0.2.2 on Android emulators
/// (which forwards to the host machine's 127.0.0.1). Adjust [baseUrl] if you run
/// the daemon elsewhere (e.g. LAN machine or a different port).
class LocalLlmClient {
  final String baseUrl;
  final String model;
  final double temperature;

  LocalLlmClient({
    String? baseUrl,
    this.model = 'gpt-oss:20b',
    this.temperature = 0.3,
  }) : baseUrl = baseUrl ?? _defaultBaseUrl();

  static String _defaultBaseUrl() {
    // Web cannot use dart:io Platform in some contexts; protect with try/catch.
    try {
      if (!kIsWeb && Platform.isAndroid) {
        // Android emulator -> host loopback
        return 'http://10.0.2.2:11434';
      }
    } catch (_) {}
    return 'http://127.0.0.1:11434';
  }

  /// Simple text generation using Ollama /api/generate (non-streaming for now)
  Future<String> generate({required String prompt}) async {
    final uri = Uri.parse('$baseUrl/api/generate');
    final body = jsonEncode({
      'model': model,
      'prompt': prompt,
      'stream': false,
      'options': {
        'temperature': temperature,
      },
    });

    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final response = data['response'];
        if (response is String && response.isNotEmpty) {
          return response.trim();
        }
        throw Exception('Malformed Ollama response payload');
      }
      throw Exception('Ollama HTTP ${resp.statusCode}: ${resp.body}');
    } catch (e) {
      throw Exception('Local LLM error: $e');
    }
  }
}

