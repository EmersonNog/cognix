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
    this.attachments = const [],
  });

  final AiChatRole role;
  final String content;
  final DateTime createdAt;
  final List<AiChatAttachment> attachments;

  Map<String, dynamic> toRequestJson() {
    return {
      'role': role.apiValue,
      'content': content,
      if (attachments.isNotEmpty)
        'attachments': attachments
            .map((attachment) => attachment.toRequestJson())
            .toList(),
    };
  }

  AiChatMessage copyWith({
    AiChatRole? role,
    String? content,
    DateTime? createdAt,
    List<AiChatAttachment>? attachments,
  }) {
    return AiChatMessage(
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      attachments: attachments ?? this.attachments,
    );
  }
}

class AiChatAttachment {
  const AiChatAttachment({
    required this.name,
    required this.mimeType,
    required this.dataBase64,
    required this.sizeBytes,
  });

  final String name;
  final String mimeType;
  final String dataBase64;
  final int sizeBytes;

  bool get isImage => mimeType.toLowerCase().startsWith('image/');

  Map<String, dynamic> toRequestJson() {
    return {
      'name': name,
      'mime_type': mimeType,
      'data_base64': dataBase64,
      'size_bytes': sizeBytes,
    };
  }
}
