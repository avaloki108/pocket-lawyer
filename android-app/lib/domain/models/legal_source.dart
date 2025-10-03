class LegalSource {
  final String citation;
  final String type;
  final String? url;
  final double? relevance;

  LegalSource({
    required this.citation,
    required this.type,
    this.url,
    this.relevance,
  });

  Map<String, dynamic> toJson() {
    return {
      'citation': citation,
      'type': type,
      'url': url,
      'relevance': relevance,
    };
  }

  factory LegalSource.fromJson(Map<String, dynamic> json) {
    return LegalSource(
      citation: json['citation'] as String,
      type: json['type'] as String,
      url: json['url'] as String?,
      relevance: json['relevance'] as double?,
    );
  }
}
