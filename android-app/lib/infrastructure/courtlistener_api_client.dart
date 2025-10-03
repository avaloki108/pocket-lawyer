import 'package:dio/dio.dart';
import '../core/constants.dart';

class CourtListenerApiClient {
  late final Dio _dio;

  CourtListenerApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.courtListenerBaseUrl,
      headers: {
        'Authorization': 'Token ${AppConstants.courtListenerApiKey}',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }

  /// Fetch case clusters from CourtListener API
  Future<Map<String, dynamic>> getCaseClusters({
    String? query,
    String? court,
    int? page,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/clusters/',
        queryParameters: {
          if (query != null) 'q': query,
          if (court != null) 'court': court,
          if (page != null) 'page': page,
          'page_size': pageSize,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch case clusters: $e');
    }
  }

  /// Fetch a specific case cluster by ID
  Future<Map<String, dynamic>> getCaseCluster(int clusterId) async {
    try {
      final response = await _dio.get('/clusters/$clusterId/');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch case cluster: $e');
    }
  }

  /// Search for opinions
  Future<Map<String, dynamic>> searchOpinions({
    required String query,
    String? court,
    DateTime? filedAfter,
    DateTime? filedBefore,
    int? page,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/search/',
        queryParameters: {
          'q': query,
          'type': 'o',  // 'o' for opinions
          if (court != null) 'court': court,
          if (filedAfter != null) 'filed_after': filedAfter.toIso8601String().split('T')[0],
          if (filedBefore != null) 'filed_before': filedBefore.toIso8601String().split('T')[0],
          if (page != null) 'page': page,
          'page_size': pageSize,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to search opinions: $e');
    }
  }

  /// Fetch docket information
  Future<Map<String, dynamic>> getDocket(int docketId) async {
    try {
      final response = await _dio.get('/dockets/$docketId/');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch docket: $e');
    }
  }

  /// Fetch court information
  Future<Map<String, dynamic>> getCourt(String courtId) async {
    try {
      final response = await _dio.get('/courts/$courtId/');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch court info: $e');
    }
  }
}
