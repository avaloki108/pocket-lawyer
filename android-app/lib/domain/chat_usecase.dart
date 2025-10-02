import '../data/rag_repository.dart';

class ChatUseCase {
  final RagRepository _ragRepository;

  ChatUseCase(this._ragRepository);

  Future<String> sendMessage(String query) async {
    // Placeholder – real implementation will call RAG repository
    return await _ragRepository.query(query);
  }
}
