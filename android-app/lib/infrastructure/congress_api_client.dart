import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CongressApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.congress.gov/v3',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> getBills({
    int? congress,
    String? billType,
    String? query,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final apiKey = dotenv.env['CONGRESS_GOV_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception('CONGRESS_GOV_API_KEY not found in .env file');
      }

      String endpoint = '/bill';
      if (congress != null) {
        endpoint += '/$congress';
        if (billType != null) {
          endpoint += '/$billType';
        }
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: {
          'api_key': apiKey,
          if (query != null) 'query': query,
          'limit': limit,
          'offset': offset,
          'sort': '-updateDate',
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to fetch federal bills');
    } catch (e) {
      throw Exception('Congress.gov API error: $e');
    }
  }

  Future<Map<String, dynamic>> getBillDetails({
    required int congress,
    required String billType,
    required String billNumber,
  }) async {
    try {
      final apiKey = dotenv.env['CONGRESS_GOV_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception('CONGRESS_GOV_API_KEY not found in .env file');
      }

      final response = await _dio.get(
        '/bill/$congress/$billType/$billNumber',
        queryParameters: {'api_key': apiKey},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to fetch bill details');
    } catch (e) {
      throw Exception('Congress.gov API error: $e');
    }
  }

  Future<Map<String, dynamic>> getBillText({
    required int congress,
    required String billType,
    required String billNumber,
  }) async {
    try {
      final apiKey = dotenv.env['CONGRESS_GOV_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception('CONGRESS_GOV_API_KEY not found in .env file');
      }

      final response = await _dio.get(
        '/bill/$congress/$billType/$billNumber/text',
        queryParameters: {'api_key': apiKey},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to fetch bill text');
    } catch (e) {
      throw Exception('Congress.gov API error: $e');
    }
  }

  Future<Map<String, dynamic>> searchLaws({
    String? query,
    int limit = 20,
  }) async {
    try {
      final apiKey = dotenv.env['CONGRESS_GOV_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception('CONGRESS_GOV_API_KEY not found in .env file');
      }

      final response = await _dio.get(
        '/law',
        queryParameters: {
          'api_key': apiKey,
          if (query != null) 'query': query,
          'limit': limit,
          'sort': '-updateDate',
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to search laws');
    } catch (e) {
      throw Exception('Congress.gov API error: $e');
    }
  }
}
