class PromptsUseCase {
  // Placeholder for prompts library logic
  Future<List<String>> getPromptCategories() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return ['Employment', 'Real Estate', 'Criminal/Traffic', 'Family/Personal'];
  }

  Future<List<String>> getPromptsForCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return ['Prompt 1 for $category', 'Prompt 2 for $category'];
  }
}
