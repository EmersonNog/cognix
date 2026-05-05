enum AiChatRole {
  user,
  assistant;

  String get apiValue {
    return switch (this) {
      AiChatRole.user => 'user',
      AiChatRole.assistant => 'assistant',
    };
  }
}

class AiChatMessage {
  const AiChatMessage({
    required this.role,
    required this.content,
    required this.createdAt,
  });

  final AiChatRole role;
  final String content;
  final DateTime createdAt;

  Map<String, dynamic> toRequestJson() {
    return {'role': role.apiValue, 'content': content};
  }

  AiChatMessage copyWith({
    AiChatRole? role,
    String? content,
    DateTime? createdAt,
  }) {
    return AiChatMessage(
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
