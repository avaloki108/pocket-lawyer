import 'package:flutter_riverpod/flutter_riverpod.dart';

class PromptSelectedNotifier extends StateNotifier<String?> {
  PromptSelectedNotifier() : super(null);

  void selectPrompt(String prompt) {
    state = prompt;
  }

  void clearPrompt() {
    state = null;
  }
}

final promptSelectedProvider = StateNotifierProvider<PromptSelectedNotifier, String?>((ref) {
  return PromptSelectedNotifier();
});
