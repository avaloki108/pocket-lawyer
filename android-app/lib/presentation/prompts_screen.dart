import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class PromptsScreen extends ConsumerStatefulWidget {
  const PromptsScreen({super.key});

  @override
  ConsumerState<PromptsScreen> createState() => _PromptsScreenState();
}

class _PromptsScreenState extends ConsumerState<PromptsScreen> {
  final Set<String> _expandedCategories = {};

  final Map<String, Map<String, dynamic>> _categories = {
    'employment': {
      'title': 'Employment Law',
      'icon': '💼',
      'color': Colors.blue,
      'description': 'Workplace rights, wages, discrimination',
      'prompts': [
        {
          'title': 'Rights when fired without cause',
          'prompt': 'What are my rights if I\'m fired without cause in {state}? Please cite specific statutes and recent case law.',
        },
        {
          'title': 'Minimum wage & overtime',
          'prompt': 'What is the current minimum wage in {state} and what are the overtime requirements? Include recent legislative changes.',
        },
        {
          'title': 'Workplace discrimination procedures',
          'prompt': 'How do I report workplace discrimination or harassment in {state}? What are the legal procedures and timelines?',
        },
      ],
    },
    'realestate': {
      'title': 'Real Estate',
      'icon': '🏠',
      'color': Colors.green,
      'description': 'Tenant rights, property laws, landlord issues',
      'prompts': [
        {
          'title': 'Security deposit rights & limits',
          'prompt': 'What are tenant rights regarding security deposits in {state}? Cite specific statutes and maximum amounts allowed.',
        },
        {
          'title': 'Eviction notice requirements',
          'prompt': 'How much notice must a landlord give before eviction in {state}? Include legal procedures and tenant defenses.',
        },
        {
          'title': 'Landlord repair obligations',
          'prompt': 'What repairs is a landlord required to make in {state}? Reference habitability statutes and enforcement options.',
        },
      ],
    },
    'criminal': {
      'title': 'Criminal & Traffic',
      'icon': '⚖️',
      'color': Colors.red,
      'description': 'Legal procedures, rights, court processes',
      'prompts': [
        {
          'title': 'Fighting speeding tickets',
          'prompt': 'What is the legal process for fighting a speeding ticket in {state}? Include court procedures and potential defenses.',
        },
        {
          'title': 'Traffic stop rights',
          'prompt': 'What are my constitutional rights during a police traffic stop in {state}? Reference relevant case law.',
        },
        {
          'title': 'Missing court dates',
          'prompt': 'What are the consequences of missing a court date in {state}? Include warrant procedures and remedies.',
        },
      ],
    },
    'family': {
      'title': 'Family & Personal',
      'icon': '👨‍👩‍👧‍👦',
      'color': Colors.purple,
      'description': 'Divorce, custody, wills, personal rights',
      'prompts': [
        {
          'title': 'Filing for divorce',
          'prompt': 'What is the process for filing for divorce in {state}? Include residency requirements, grounds, and procedures.',
        },
        {
          'title': 'Writing a valid will',
          'prompt': 'What are the legal requirements for writing a will in {state}? Include witness requirements and validity standards.',
        },
        {
          'title': 'Grandparent visitation rights',
          'prompt': 'What are grandparent visitation rights in {state}? Cite relevant statutes and recent court decisions.',
        },
      ],
    },
  };

  void _toggleCategory(String category) {
    setState(() {
      if (_expandedCategories.contains(category)) {
        _expandedCategories.remove(category);
      } else {
        _expandedCategories.add(category);
      }
    });
  }

  void _usePrompt(String promptTemplate) {
    // Get abbreviation from provider, get full name for display
    final stateAbbr = ref.read(selectedStateProvider);
    final stateName = abbrToStateName[stateAbbr] ?? 'California';

    // Replace {state} with full name for better readability in chat
    final prompt = promptTemplate.replaceAll('{state}', stateName);

    // Set prompt which will trigger navigation in home_screen
    ref.read(promptSelectedProvider.notifier).selectPrompt(prompt);
  }

  @override
  Widget build(BuildContext context) {
    final stateAbbr = ref.watch(selectedStateProvider);
    final stateName = abbrToStateName[stateAbbr] ?? 'California';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expert Legal Prompts'),
        backgroundColor: const Color(0xFF5D5CDE),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Selected State: $stateName',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const Spacer(),
                Text(
                  'Tap Config to change',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _categories.entries.map((entry) {
          final categoryId = entry.key;
          final category = entry.value;
          final isExpanded = _expandedCategories.contains(categoryId);

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: isExpanded ? 4 : 2,
            child: Column(
              children: [
                InkWell(
                  onTap: () => _toggleCategory(categoryId),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: (category['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              category['icon'] as String,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category['description'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: (category['prompts'] as List).map((prompt) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _usePrompt(prompt['prompt'] as String),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: (category['color'] as Color).withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: (category['color'] as Color).withOpacity(0.05),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        prompt['title'] as String,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 18,
                                      color: category['color'] as Color,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}