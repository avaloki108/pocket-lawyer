import '../infrastructure/openai_api_client.dart';
import '../infrastructure/legiscan_api_client.dart';
import '../infrastructure/congress_api_client.dart';

class ApiClientRepository {
  final OpenAiApiClient _openAiClient;
  final LegiScanApiClient _legiScanClient;
  final CongressApiClient _congressClient;

  ApiClientRepository(
    this._openAiClient,
    this._legiScanClient,
    this._congressClient,
  );

  // Legal API functions as defined in the specification

  /// Retrieve state statutes and regulations based on jurisdiction and legal topic
  Future<Map<String, dynamic>> getStateLaws({
    required String state,
    required String legalTopic,
    String? searchQuery,
  }) async {
    try {
      return await _legiScanClient.getStateLaws(
        state: state,
        query: searchQuery != null ? '$legalTopic $searchQuery' : legalTopic,
      );
    } catch (e) {
      // Fallback to OpenAI for general legal information if API fails
      final prompt =
          'Provide information on $legalTopic laws in $state${searchQuery != null ? ' regarding $searchQuery' : ''}. Include relevant statutes and cite sources.';
      final aiResponse = await _openAiClient.generate(prompt: prompt);
      return {'ai_response': aiResponse, 'source': 'openai_fallback'};
    }
  }

  /// Retrieve federal statutes and regulations
  Future<Map<String, dynamic>> getFederalLaws({
    required String legalTopic,
    String? searchQuery,
  }) async {
    try {
      return await _congressClient.searchLaws(
        query: searchQuery != null ? '$legalTopic $searchQuery' : legalTopic,
      );
    } catch (e) {
      // Fallback to OpenAI
      final prompt =
          'Provide information on federal $legalTopic laws${searchQuery != null ? ' regarding $searchQuery' : ''}. Include relevant statutes and cite sources.';
      final aiResponse = await _openAiClient.generate(prompt: prompt);
      return {'ai_response': aiResponse, 'source': 'openai_fallback'};
    }
  }

  /// Search relevant court decisions and case law
  Future<Map<String, dynamic>> searchCaseLaw({
    required String jurisdiction,
    required String legalIssue,
    int maxResults = 5,
  }) async {
    // For now, use OpenAI to simulate case law search
    // In production, this would integrate with case law databases
    final prompt =
        'Search for relevant court cases in $jurisdiction regarding $legalIssue. Provide up to $maxResults cases with citations and brief summaries.';
    final aiResponse = await _openAiClient.generate(prompt: prompt);
    return {'ai_response': aiResponse, 'source': 'openai'};
  }

  /// Retrieve specific law by citation or statute number
  Future<Map<String, dynamic>> getSpecificCitation({
    required String citation,
    String? jurisdiction,
  }) async {
    try {
      // Try to determine if it's a federal or state citation
      if (jurisdiction == null) {
        // Simple heuristic - if citation contains state abbreviations, treat as state
        final stateAbbreviations = [
          'CA',
          'NY',
          'TX',
          'FL',
          'IL',
          'PA',
          'OH',
          'GA',
          'NC',
          'MI',
        ];
        final isStateCitation = stateAbbreviations.any(
          (abbr) => citation.contains(abbr),
        );

        if (isStateCitation) {
          // Extract state from citation (simplified)
          final stateMatch = RegExp(r'\b([A-Z]{2})\b').firstMatch(citation);
          if (stateMatch != null) {
            jurisdiction = stateMatch.group(1);
          }
        }
      }

      if (jurisdiction != null && jurisdiction != 'federal') {
        // Try state law first
        return await _legiScanClient.getStateLaws(
          state: jurisdiction,
          query: citation,
        );
      } else {
        // Try federal law
        return await _congressClient.searchLaws(query: citation);
      }
    } catch (e) {
      // Fallback to OpenAI
      final prompt =
          'Provide the text and explanation of citation: $citation${jurisdiction != null ? ' from $jurisdiction' : ''}.';
      final aiResponse = await _openAiClient.generate(prompt: prompt);
      return {'ai_response': aiResponse, 'source': 'openai_fallback'};
    }
  }

  // Legacy methods for backward compatibility
  Future<String> queryOpenAi(String prompt) =>
      _openAiClient.generate(prompt: prompt);
}
