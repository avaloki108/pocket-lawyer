import 'package:dio/dio.dart';
import '../core/constants.dart';

class LegiScanApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.legiScanBaseUrl,
      queryParameters: {'key': AppConstants.legiScanApiKey},
    ),
  );

  Future<Map<String, dynamic>> getStateLaws({
    required String state,
    String? query,
    int year = 2024,
  }) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
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
      final response = await _dio.get(
        '',
        queryParameters: {'op': 'getBill', 'id': billId},
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
      final response = await _dio.get(
        '',
        queryParameters: {'op': 'getBillText', 'id': billId},
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
