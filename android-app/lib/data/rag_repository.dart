import 'api_client_repository.dart';

abstract class RagRepository {
  Future<String> query(String prompt);
}

// Real implementation using external APIs
class RagRepositoryImpl implements RagRepository {
  final ApiClientRepository _apiClient;

  RagRepositoryImpl(this._apiClient);

  @override
  Future<String> query(String prompt) async {
    try {
      // Determine jurisdiction from prompt (simplified logic)
      final jurisdiction = _extractJurisdiction(prompt);
      final legalTopic = _extractLegalTopic(prompt);

      // Try state laws first if jurisdiction detected
      if (jurisdiction != null && !_isFederalJurisdiction(jurisdiction)) {
        final stateData = await _apiClient.getStateLaws(
          state: jurisdiction,
          legalTopic: legalTopic ?? 'general',
          searchQuery: prompt,
        );

        if (stateData.containsKey('searchresult')) {
          final results = stateData['searchresult'] as List?;
          if (results != null && results.isNotEmpty) {
            final firstResult = results[0] as Map<String, dynamic>;
            return _formatStateLawResponse(firstResult, jurisdiction);
          }
        }
      }

      // Try federal laws
      final federalData = await _apiClient.getFederalLaws(
        legalTopic: legalTopic ?? 'general',
        searchQuery: prompt,
      );

      if (federalData.containsKey('bills')) {
        final bills = federalData['bills'] as List?;
        if (bills != null && bills.isNotEmpty) {
          final firstBill = bills[0] as Map<String, dynamic>;
          return _formatFederalLawResponse(firstBill);
        }
      }

      // Fallback to OpenAI
      final aiResponse = await _apiClient.queryOpenAi(
        'Based on the following legal question, provide a comprehensive answer citing relevant laws and cases: $prompt',
      );

      return aiResponse;
    } catch (e) {
      // Ultimate fallback
      return 'I apologize, but I encountered an error while researching your legal question. Please consult with a qualified attorney for personalized legal advice. Error: $e';
    }
  }

  String? _extractJurisdiction(String prompt) {
    // Simple extraction - look for state names or abbreviations
    final statePattern = RegExp(
      r'\b(California|New York|Texas|Florida|Nevada|Arizona|Colorado|Utah|Washington|Oregon|Idaho|Montana|Wyoming|North Dakota|South Dakota|Nebraska|Kansas|Oklahoma|Arkansas|Louisiana|Mississippi|Alabama|Tennessee|Kentucky|Indiana|Illinois|Wisconsin|Minnesota|Iowa|Missouri|Arkansas|Louisiana|Mississippi|Alabama|Tennessee|Kentucky|Indiana|Illinois|Wisconsin|Minnesota|Iowa|Missouri|North Carolina|South Carolina|Georgia|Florida|Virginia|West Virginia|Maryland|Delaware|New Jersey|Pennsylvania|Ohio|Michigan|Connecticut|Rhode Island|Massachusetts|Vermont|New Hampshire|Maine|Hawaii|Alaska)\b|\b([A-Z]{2})\b',
    );
    final match = statePattern.firstMatch(prompt.toLowerCase());
    if (match != null) {
      return match.group(1) ?? match.group(2);
    }
    return null;
  }

  String? _extractLegalTopic(String prompt) {
    final topics = [
      'employment',
      'real estate',
      'criminal',
      'traffic',
      'business',
      'health',
      'family',
      'tax',
      'immigration',
      'consumer',
    ];
    final promptLower = prompt.toLowerCase();

    for (final topic in topics) {
      if (promptLower.contains(topic)) {
        return topic;
      }
    }
    return null;
  }

  bool _isFederalJurisdiction(String jurisdiction) {
    return jurisdiction.toLowerCase() == 'federal' ||
        jurisdiction.toLowerCase() == 'us' ||
        jurisdiction.toLowerCase() == 'united states';
  }

  String _formatStateLawResponse(Map<String, dynamic> result, String state) {
    final title = result['title'] ?? 'Unknown Title';
    final description = result['description'] ?? '';
    final billNumber = result['bill_number'] ?? '';

    return '''
Based on $state law:

**Bill: $billNumber**
**Title:** $title

**Description:** $description

*Note: This is general information based on legislative data. For personalized legal advice, please consult with a qualified attorney licensed in $state.*

**Source:** LegiScan API - State of $state Legislature
''';
  }

  String _formatFederalLawResponse(Map<String, dynamic> bill) {
    final title = bill['title'] ?? 'Unknown Title';
    final number = bill['number'] ?? '';
    final congress = bill['congress'] ?? '';
    final originChamber = bill['originChamber'] ?? '';

    return '''
Based on federal law:

**Bill:** $number
**Congress:** $congress
**Chamber:** $originChamber
**Title:** $title

*Note: This is general information based on federal legislative data. For personalized legal advice, please consult with a qualified attorney.*

**Source:** Congress.gov - U.S. Congress
''';
  }
}
