import 'package:dio/dio.dart';
import '../core/constants.dart';

class CongressApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
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
      String endpoint = '${AppConstants.backendCongressPath}/bill';
      if (congress != null) {
        endpoint += '/$congress';
        if (billType != null) {
          endpoint += '/$billType';
        }
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: {
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
      final response = await _dio.get('${AppConstants.backendCongressPath}/bill/$congress/$billType/$billNumber');

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
      final response = await _dio.get(
        '${AppConstants.backendCongressPath}/bill/$congress/$billType/$billNumber/text',
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
      final response = await _dio.get(
        '${AppConstants.backendCongressPath}/law',
        queryParameters: {
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
