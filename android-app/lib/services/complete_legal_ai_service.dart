// lib/services/complete_legal_ai_service.dart
// FULL INTEGRATION WITH ALL YOUR LAW LIBRARY APIs + LLM PROVIDERS

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CompleteLegalAIService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
  ));

  // ============================================
  // LAW LIBRARY APIS - YOUR ACTUAL ENDPOINTS
  // ============================================

  /// CourtListener API - Federal & State Case Law
  /// 8+ million opinions, oral arguments, judges database
  Future<Map<String, dynamic>> searchCourtCases({
    required String query,
    String? court,
    String? dateAfter,
    String? dateBefore,
    int page = 1,
  }) async {
    final apiKey = dotenv.env['COURTLISTENER_API_KEY']; // Your key: 2ad5f6b8c6f5bed4da797054dda8644ff2f98821

    try {
      final response = await _dio.get(
        'https://www.courtlistener.com/api/rest/v3/search/',
        options: Options(
          headers: {
            'Authorization': 'Token $apiKey',
          },
        ),
        queryParameters: {
          'q': query,
          'type': 'o', // opinions
          'order_by': 'score desc',
          'court': court,
          'filed_after': dateAfter,
          'filed_before': dateBefore,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final cases = response.data['results'] as List;

        // Process and enhance case data
        final enhancedCases = cases.map((case_) {
          return {
            'id': case_['id'],
            'case_name': case_['caseName'],
            'court': case_['court'],
            'date_filed': case_['dateFiled'],
            'citation': case_['citation']?.join(', '),
            'snippet': case_['snippet'],
            'download_url': case_['download_url'],
            'absolute_url': 'https://www.courtlistener.com${case_['absolute_url']}',
            'judge': case_['judge'],
            'importance_score': _calculateImportance(case_),
          };
        }).toList();

        return {
          'total_results': response.data['count'],
          'cases': enhancedCases,
          'next_page': response.data['next'] != null ? page + 1 : null,
        };
      }
      throw Exception('CourtListener API error: ${response.statusCode}');
    } catch (e) {
      return {'error': e.toString(), 'cases': []};
    }
  }

  /// LegiScan API - State & Federal Legislation Tracking
  /// 500,000+ bills from all 50 states + Congress
  Future<Map<String, dynamic>> searchLegislation({
    required String query,
    String? state,
    int? year,
    String? status, // introduced, passed, failed, enacted
  }) async {
    final apiKey = dotenv.env['LEGISCAN_API_KEY']; // Your key: 6da9b568d057150d0f032566d5ca54e4

    try {
      // First search for relevant bills
      final searchResponse = await _dio.get(
        'https://api.legiscan.com/',
        queryParameters: {
          'key': apiKey,
          'op': 'getSearch',
          'state': state ?? 'ALL',
          'query': query,
          'year': year ?? 2,  // Last 2 years default
        },
      );

      if (searchResponse.data['status'] == 'OK') {
        final bills = searchResponse.data['searchresult'];

        // Get detailed info for top bills
        final detailedBills = [];
        for (var i = 0; i < (bills.length > 10 ? 10 : bills.length); i++) {
          final billId = bills.keys.elementAt(i);
          if (billId == 'summary') continue;

          final billIdValue = bills[billId]['bill_id']?.toString() ?? '';
          final billDetail = await _getBillDetails(billIdValue, apiKey);
          if (billDetail != null) {
            detailedBills.add(billDetail);
          }
        }

        return {
          'total_results': bills['summary']['count'],
          'bills': detailedBills,
          'states_covered': bills['summary']['states_covered'] ?? [],
        };
      }
      throw Exception('LegiScan API error');
    } catch (e) {
      return {'error': e.toString(), 'bills': []};
    }
  }

  Future<Map<String, dynamic>?> _getBillDetails(String billId, String? apiKey) async {
    if (apiKey == null || apiKey.isEmpty || billId.isEmpty) return null;
    try {
      final response = await _dio.get(
        'https://api.legiscan.com/',
        queryParameters: {
          'key': apiKey,
          'op': 'getBill',
          'id': billId,
        },
      );

      if (response.data['status'] == 'OK') {
        final bill = response.data['bill'];
        return {
          'bill_id': bill['bill_id'],
          'number': bill['bill_number'],
          'title': bill['title'],
          'description': bill['description'],
          'state': bill['state'],
          'status': bill['status'],
          'progress': _calculateBillProgress(bill['progress']),
          'sponsors': bill['sponsors'],
          'history': bill['history'],
          'votes': bill['votes'],
          'texts': bill['texts'], // Different versions of bill text
          'url': bill['url'],
          'last_action': bill['last_action'],
          'last_action_date': bill['last_action_date'],
        };
      }
    } catch (e) {
    }
    return null;
  }

  /// Congress.gov API - Federal Laws & Congressional Records
  /// All federal legislation, Congressional records, committee reports
  Future<Map<String, dynamic>> searchCongressionalRecords({
    required String query,
    String? congress, // e.g., "118" for 118th Congress
    String? chamber, // house, senate, both
    String? type, // bill, resolution, amendment
  }) async {
    final apiKey = dotenv.env['CONGRESS_GOV_API_KEY']; // Your key: mXdjKaTeDzfwekxPaPILvoa8malhIenpSNtmCkwI

    try {
      final response = await _dio.get(
        'https://api.congress.gov/v3/bill',
        options: Options(
          headers: {
            'X-Api-Key': apiKey,
          },
        ),
        queryParameters: {
          'format': 'json',
          'limit': 20,
          'offset': 0,
          'fromDateTime': DateTime.now().subtract(Duration(days: 365)).toIso8601String(),
          'toDateTime': DateTime.now().toIso8601String(),
          'sort': 'updateDate+desc',
        },
      );

      if (response.statusCode == 200) {
        final bills = response.data['bills'] as List;

        // Search within bills for query match
        final matchingBills = bills.where((bill) {
          final title = bill['title']?.toString().toLowerCase() ?? '';
          final q = query.toLowerCase();
          return title.contains(q);
        }).map((bill) {
          return {
            'congress': bill['congress'],
            'number': bill['number'],
            'type': bill['type'],
            'title': bill['title'],
            'origin_chamber': bill['originChamber'],
            'introduced_date': bill['introducedDate'],
            'latest_action': bill['latestAction']?['text'],
            'latest_action_date': bill['latestAction']?['actionDate'],
            'url': bill['url'],
            'update_date': bill['updateDate'],
            'policy_area': bill['policyArea']?['name'],
            'sponsors': _extractSponsors(bill),
            'committees': bill['committees'],
          };
        }).toList();

        return {
          'total_results': matchingBills.length,
          'bills': matchingBills,
          'congress_number': congress ?? '118',
        };
      }
      throw Exception('Congress.gov API error: ${response.statusCode}');
    } catch (e) {
      return {'error': e.toString(), 'bills': []};
    }
  }

  // ============================================
  // INTEGRATED AI ANALYSIS WITH LAW LIBRARIES
  // ============================================

  /// Master legal query that combines all data sources
  Future<Map<String, dynamic>> comprehensiveLegalQuery({
    required String userQuery,
    bool searchCaseLaw = true,
    bool searchStatutes = true,
    bool searchCongress = true,
    String? jurisdiction,
    String? dateRange,
  }) async {

    // Parallel search across all law libraries
    final futures = <Future>[];

    if (searchCaseLaw) {
      futures.add(searchCourtCases(query: userQuery, court: jurisdiction));
    }

    if (searchStatutes) {
      futures.add(searchLegislation(query: userQuery, state: jurisdiction));
    }

    if (searchCongress) {
      futures.add(searchCongressionalRecords(query: userQuery));
    }

    final results = await Future.wait(futures);

    // Combine all legal sources
    final combinedContext = StringBuffer();
    final citations = <String>[];
    int resultIndex = 0;

    // Process case law results
    if (searchCaseLaw && resultIndex < results.length) {
      final caseResults = results[resultIndex++] as Map<String, dynamic>;
      if (caseResults['cases'] != null && (caseResults['cases'] as List).isNotEmpty) {
        combinedContext.writeln('\n=== RELEVANT CASE LAW ===');
        for (final case_ in (caseResults['cases'] as List).take(3)) {
          combinedContext.writeln('Case: ${case_['case_name']}');
          combinedContext.writeln('Citation: ${case_['citation']}');
          combinedContext.writeln('Court: ${case_['court']}');
          combinedContext.writeln('Date: ${case_['date_filed']}');
          combinedContext.writeln('Relevance: ${case_['snippet']}\n');
          citations.add(case_['citation'] ?? case_['case_name']);
        }
      }
    }

    // Process legislation results
    if (searchStatutes && resultIndex < results.length) {
      final billResults = results[resultIndex++] as Map<String, dynamic>;
      if (billResults['bills'] != null && (billResults['bills'] as List).isNotEmpty) {
        combinedContext.writeln('\n=== RELEVANT LEGISLATION ===');
        for (final bill in (billResults['bills'] as List).take(3)) {
          combinedContext.writeln('Bill: ${bill['number']} - ${bill['title']}');
          combinedContext.writeln('State: ${bill['state']}');
          combinedContext.writeln('Status: ${bill['status']}');
          combinedContext.writeln('Description: ${bill['description']}\n');
          citations.add('${bill['state']} ${bill['number']}');
        }
      }
    }

    // Process congressional results
    if (searchCongress && resultIndex < results.length) {
      final congressResults = results[resultIndex++] as Map<String, dynamic>;
      if (congressResults['bills'] != null && (congressResults['bills'] as List).isNotEmpty) {
        combinedContext.writeln('\n=== FEDERAL LEGISLATION ===');
        for (final bill in (congressResults['bills'] as List).take(3)) {
          combinedContext.writeln('Bill: ${bill['type']} ${bill['number']}');
          combinedContext.writeln('Title: ${bill['title']}');
          combinedContext.writeln('Latest Action: ${bill['latest_action']}');
          combinedContext.writeln('Policy Area: ${bill['policy_area']}\n');
          citations.add('${bill['congress']}th Congress, ${bill['type']} ${bill['number']}');
        }
      }
    }

    // Generate AI analysis using OpenRouter with legal context
    final aiResponse = await _generateLegalAnalysis(
      userQuery: userQuery,
      legalContext: combinedContext.toString(),
      citations: citations,
    );

    return {
      'ai_analysis': aiResponse,
      'legal_sources': combinedContext.toString(),
      'citations': citations,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Generate AI analysis using OpenRouter with your API key
  Future<String> _generateLegalAnalysis({
    required String userQuery,
    required String legalContext,
    required List<String> citations,
  }) async {
    final openRouterKey = dotenv.env['OPENROUTER_API_KEY']; // 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

    final systemPrompt = '''You are an expert legal AI assistant with access to real case law and statutes.
    
CRITICAL RULES:
1. Base your analysis on the PROVIDED LEGAL SOURCES below
2. Cite specific cases and statutes by name
3. Explain complex legal concepts clearly
4. Identify jurisdictional considerations
5. Include appropriate disclaimers about seeking professional counsel
6. Structure response with clear sections

LEGAL SOURCES PROVIDED:
$legalContext

CITATIONS AVAILABLE:
${citations.join('\n')}
''';

    try {
      final response = await _dio.post(
        'https://openrouter.ai/api/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $openRouterKey',
            'HTTP-Referer': 'https://pocketlawyer.ai',
            'X-Title': 'Pocket Lawyer Legal Analysis',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'anthropic/claude-3-opus', // Best for legal analysis
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': 'Legal Question: $userQuery\n\nProvide comprehensive legal analysis based on the sources provided.'},
          ],
          'temperature': 0.3, // Lower for factual accuracy
          'max_tokens': 2500,
        },
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'];
      }
    } catch (e) {

      // Fallback to OpenAI
      return await _fallbackToOpenAI(userQuery, legalContext, citations);
    }

    return 'Unable to generate analysis. Please try again.';
  }

  /// Fallback to OpenAI API
  Future<String> _fallbackToOpenAI(String query, String context, List<String> citations) async {
    final openAIKey = dotenv.env['OPENAI_API_KEY']; // Your actual OpenAI key

    try {
      final response = await _dio.post(
        'https://api.openai.com/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $openAIKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'gpt-4-turbo-preview',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a legal expert. Analyze based on: $context\nCitations: ${citations.join(", ")}'
            },
            {'role': 'user', 'content': query},
          ],
          'temperature': 0.3,
          'max_tokens': 2000,
        },
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'];
      }
    } catch (e) {
    }

    return 'Analysis temporarily unavailable.';
  }

  // Helper methods
  int _calculateImportance(Map<String, dynamic> caseData) {
    int score = 50;
    if (caseData['citation'] != null) score += 20;
    if (caseData['judge'] != null) score += 10;
    if (caseData['court']?.contains('Supreme') == true) score += 30;
    return score.clamp(0, 100);
  }

  Map<String, int> _calculateBillProgress(Map<String, dynamic>? progress) {
    if (progress == null) return {'percentage': 0};

    final steps = [
      progress['intro'] ?? 0,
      progress['committee'] ?? 0,
      progress['chamber1'] ?? 0,
      progress['chamber2'] ?? 0,
      progress['enacted'] ?? 0,
    ];

    final completed = steps.where((s) => s == 1).length;
    return {'percentage': (completed * 20), 'steps_completed': completed};
  }

  List<String> _extractSponsors(Map<String, dynamic> bill) {
    final sponsors = <String>[];
    if (bill['sponsors'] != null) {
      for (final sponsor in bill['sponsors']) {
        sponsors.add('${sponsor['firstName']} ${sponsor['lastName']} (${sponsor['party']}-${sponsor['state']})');
      }
    }
    return sponsors;
  }
}