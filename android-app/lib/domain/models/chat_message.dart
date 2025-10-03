import 'legal_source.dart';

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final List<LegalSource>? sources;
  final double? confidence;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.sources,
    this.confidence,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'sources': sources?.map((s) => s.toJson()).toList(),
      'confidence': confidence,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sources: (json['sources'] as List?)
          ?.map((s) => LegalSource.fromJson(s as Map<String, dynamic>))
          .toList(),
      confidence: json['confidence'] as double?,
    );
  }
}
