import 'package:dio/dio.dart';

class HarvardCapApiClient {
  final Dio _dio = Dio();

  Future<String> getCase(String citation) async {
    // Placeholder for Harvard CAP API
    await Future.delayed(const Duration(milliseconds: 150));
    return 'Harvard CAP data for: $citation';
  }
}
