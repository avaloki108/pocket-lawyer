import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LegiScanApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.legiscan.com',
    ),
  );

  Future<Map<String, dynamic>> getStateLaws({
    required String state,
    String? query,
    int year = 2024,
  }) async {
    try {
      final apiKey = dotenv.env['LEGISCAN_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception('LEGISCAN_API_KEY not found in .env file');
      }

      final response = await _dio.get(
        '/',
        queryParameters: {
          'key': apiKey,
          'op': 'getSearch',
          'state': state.toUpperCase(),
          'query': query ?? '',
          'year': year,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to fetch state laws');
    } catch (e) {
      throw Exception('LegiScan API error: $e');
    }
  }

  Future<Map<String, dynamic>> getBill(int billId) async {
    try {
      final apiKey = dotenv.env['LEGISCAN_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception('LEGISCAN_API_KEY not found in .env file');
      }

      final response = await _dio.get(
        '/',
        queryParameters: {
          'key': apiKey,
          'op': 'getBill',
          'id': billId,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to fetch bill details');
    } catch (e) {
      throw Exception('LegiScan API error: $e');
    }
  }

  Future<Map<String, dynamic>> getBillText(int billId) async {
    try {
      final apiKey = dotenv.env['LEGISCAN_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception('LEGISCAN_API_KEY not found in .env file');
      }

      final response = await _dio.get(
        '/',
        queryParameters: {
          'key': apiKey,
          'op': 'getBillText',
          'id': billId,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to fetch bill text');
    } catch (e) {
      throw Exception('LegiScan API error: $e');
    }
  }
}
