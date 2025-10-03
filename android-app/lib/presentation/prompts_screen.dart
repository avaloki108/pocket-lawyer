import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import '../domain/models/prompt_selected_notifier.dart';

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
          'title': 'Rights when fired without cause (with citations)',
          'prompt': 'What are my rights if I\'m fired without cause in [STATE]? Please cite specific statutes and recent case law.',
        },
        {
          'title': 'Minimum wage & overtime requirements',
          'prompt': 'What is the current minimum wage in [STATE] and what are the overtime requirements? Include recent legislative changes.',
        },
        {
          'title': 'Workplace discrimination procedures',
          'prompt': 'How do I report workplace discrimination or harassment in [STATE]? What are the legal procedures and timelines?',
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
          'prompt': 'What are tenant rights regarding security deposits in [STATE]? Cite specific statutes and maximum amounts allowed.',
        },
        {
          'title': 'Eviction notice requirements & defenses',
          'prompt': 'How much notice must a landlord give before eviction in [STATE]? Include legal procedures and tenant defenses.',
        },
        {
          'title': 'Landlord repair obligations & enforcement',
          'prompt': 'What repairs is a landlord required to make in [STATE]? Reference habitability statutes and enforcement options.',
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
          'title': 'Fighting speeding tickets & defenses',
          'prompt': 'What is the legal process for fighting a speeding ticket in [STATE]? Include court procedures and potential defenses.',
        },
        {
          'title': 'Constitutional rights in traffic stops',
          'prompt': 'What are my constitutional rights during a police traffic stop in [STATE]? Reference relevant case law.',
        },
        {
          'title': 'Missing court dates & consequences',
          'prompt': 'What are the consequences of missing a court date in [STATE]? Include warrant procedures and remedies.',
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
          'title': 'Filing for divorce - complete process',
          'prompt': 'What is the process for filing for divorce in [STATE]? Include residency requirements, grounds, and procedures.',
        },
        {
          'title': 'Will requirements & validity',
          'prompt': 'What are the legal requirements for writing a will in [STATE]? Include witness requirements and validity standards.',
        },
        {
          'title': 'Grandparent visitation rights',
          'prompt': 'What are grandparent visitation rights in [STATE]? Cite relevant statutes and recent court decisions.',
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
    final selectedState = ref.read(selectedStateProvider);
    final prompt = promptTemplate.replaceAll('[STATE]', selectedState);

    // Set the prompt in the provider and let the home screen handle tab switching
    ref.read(promptSelectedProvider.notifier).selectPrompt(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expert Legal Prompts'),
        backgroundColor: const Color(0xFF5D5CDE),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _categories.entries.map((entry) {
          final categoryId = entry.key;
          final category = entry.value;
          final isExpanded = _expandedCategories.contains(categoryId);

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
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
                          child: InkWell(
                            onTap: () => _usePrompt(prompt['prompt'] as String),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      prompt['title'] as String,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
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
