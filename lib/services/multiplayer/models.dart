class MultiplayerRoom {
  const MultiplayerRoom({
    required this.id,
    required this.pin,
    required this.hostUserId,
    required this.hostFirebaseUid,
    required this.status,
    required this.maxParticipants,
    required this.participantCount,
    required this.participants,
    this.startedAt,
    this.finishedAt,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String pin;
  final int hostUserId;
  final String hostFirebaseUid;
  final String status;
  final int maxParticipants;
  final int participantCount;
  final List<MultiplayerParticipant> participants;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isWaiting => status == 'waiting';
  bool get isInProgress => status == 'in_progress';

  bool hasParticipantFirebaseUid(String? firebaseUid) {
    final normalized = firebaseUid?.trim();
    if (normalized == null || normalized.isEmpty) {
      return false;
    }

    return participants.any((item) => item.firebaseUid == normalized);
  }

  bool isHostFirebaseUid(String? firebaseUid) {
    final normalized = firebaseUid?.trim();
    return normalized != null &&
        normalized.isNotEmpty &&
        hostFirebaseUid == normalized;
  }
}

class MultiplayerParticipant {
  const MultiplayerParticipant({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.firebaseUid,
    required this.displayName,
    required this.role,
    required this.status,
    this.joinedAt,
    this.removedAt,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int roomId;
  final int userId;
  final String firebaseUid;
  final String displayName;
  final String role;
  final String status;
  final DateTime? joinedAt;
  final DateTime? removedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get name {
    final normalized = displayName.trim();
    return normalized.isEmpty ? 'Jogador' : normalized;
  }

  bool get isHost => role == 'host';
  bool get isJoined => status == 'joined';
}
