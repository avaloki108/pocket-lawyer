import '../infrastructure/open_router_api_client.dart';
import '../infrastructure/legiscan_api_client.dart';
import '../infrastructure/congress_api_client.dart';

class ApiClientRepository {
  final OpenRouterApiClient _openRouterClient;
  final LegiScanApiClient _legiScanClient;
  final CongressApiClient _congressClient;

  ApiClientRepository(
    this._openRouterClient,
    this._legiScanClient,
    this._congressClient,
  );

  /// Retrieve state statutes and regulations, augmented by LLM.
  Future<Map<String, dynamic>> getStateLaws({
    required String state,
    required String legalTopic,
    String? searchQuery,
  }) async {
    try {
      final lawApiResponse = await _legiScanClient.getStateLaws(
        state: state,
        query: searchQuery != null ? '$legalTopic $searchQuery' : legalTopic,
      );
      
      final prompt = 'Based on the following data, provide a comprehensive summary of $legalTopic laws in $state: $lawApiResponse. Explain in simple terms, include relevant statutes, and cite sources.';
      final aiSummary = await _openRouterClient.generate(prompt: prompt);

      return {'structured_data': lawApiResponse, 'ai_summary': aiSummary};
    } catch (e) {
      // If structured API fails, fallback to pure LLM.
      final prompt =
          'Provide information on $legalTopic laws in $state${searchQuery != null ? ' regarding $searchQuery' : ''}. Include relevant statutes and cite sources.';
      final aiResponse = await _openRouterClient.generate(prompt: prompt);
      return {'ai_response': aiResponse, 'source': 'openrouter_fallback'};
    }
  }

  /// Retrieve federal statutes and regulations, augmented by LLM.
  Future<Map<String, dynamic>> getFederalLaws({
    required String legalTopic,
    String? searchQuery,
  }) async {
    try {
      final lawApiResponse = await _congressClient.searchLaws(
        query: searchQuery != null ? '$legalTopic $searchQuery' : legalTopic,
      );

      final prompt = 'Based on the following data, provide a comprehensive summary of federal $legalTopic laws: $lawApiResponse. Explain in simple terms, include relevant statutes, and cite sources.';
      final aiSummary = await _openRouterClient.generate(prompt: prompt);
      
      return {'structured_data': lawApiResponse, 'ai_summary': aiSummary};
    } catch (e) {
      // If structured API fails, fallback to pure LLM.
      final prompt =
          'Provide information on federal $legalTopic laws${searchQuery != null ? ' regarding $searchQuery' : ''}. Include relevant statutes and cite sources.';
      final aiResponse = await _openRouterClient.generate(prompt: prompt);
      return {'ai_response': aiResponse, 'source': 'openrouter_fallback'};
    }
  }

  /// Search relevant court decisions and case law (simulated via AI).
  Future<Map<String, dynamic>> searchCaseLaw({
    required String jurisdiction,
    required String legalIssue,
    int maxResults = 5,
  }) async {
    final prompt =
        'Search for relevant court cases in $jurisdiction regarding $legalIssue. Provide up to $maxResults cases with citations and brief summaries.';
    final aiResponse = await _openRouterClient.generate(prompt: prompt);
    return {'ai_response': aiResponse, 'source': 'openrouter'};
  }

  /// Retrieve specific law by citation or statute number, augmented by LLM.
  Future<Map<String, dynamic>> getSpecificCitation({
    required String citation,
    String? jurisdiction,
  }) async {
    try {
      if (jurisdiction == null) {
        final stateAbbreviations = ['CA', 'NY', 'TX', 'FL', 'IL', 'PA', 'OH', 'GA', 'NC', 'MI'];
        final matchedAbbr = stateAbbreviations.firstWhere((abbr) => citation.contains(abbr), orElse: () => '');
        if (matchedAbbr.isNotEmpty) {
          jurisdiction = matchedAbbr;
        } else {
          jurisdiction = 'federal'; // Default to federal if no state is obvious
        }
      }

      Map<String, dynamic> lawApiResponse;
      String apiSource;

      if (jurisdiction != 'federal') {
        lawApiResponse = await _legiScanClient.getStateLaws(state: jurisdiction!, query: citation);
        apiSource = 'LegiScan';
      } else {
        lawApiResponse = await _congressClient.searchLaws(query: citation);
        apiSource = 'Congress.gov';
      }

      final prompt = 'Based on the following data from $apiSource, provide a detailed explanation of the law or citation "$citation": $lawApiResponse. Explain its meaning and implications in simple terms.';
      final aiSummary = await _openRouterClient.generate(prompt: prompt);

      return {'structured_data': lawApiResponse, 'ai_summary': aiSummary};
    } catch (e) {
      // If structured API fails, fallback to pure LLM.
      final prompt =
          'Provide the text and explanation of citation: $citation${jurisdiction != null ? ' from $jurisdiction' : ''}.';
      final aiResponse = await _openRouterClient.generate(prompt: prompt);
      return {'ai_response': aiResponse, 'source': 'openrouter_fallback'};
    }
  }

  /// Legacy method, now pointing to OpenRouter.
  Future<String> queryOpenRouter(String prompt) => _openRouterClient.generate(prompt: prompt);
}
