import '../core/api_client.dart' show apiBaseUrl, deleteJson, getJson, postJson;
import 'models.dart';
import 'parsers.dart';

Future<MultiplayerRoom> createMultiplayerRoom({
  String? displayName,
  int maxParticipants = 8,
}) async {
  final body = <String, dynamic>{'max_participants': maxParticipants};
  final normalizedDisplayName = displayName?.trim();
  if (normalizedDisplayName != null && normalizedDisplayName.isNotEmpty) {
    body['display_name'] = normalizedDisplayName;
  }

  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/multiplayer/rooms'),
    body: body,
    errorMessage:
        'Não consegui criar a sala agora. Tente de novo em instantes.',
  );
  return parseMultiplayerRoom(payload);
}

Future<MultiplayerAnswerResult> submitMultiplayerAnswer({
  required int roomId,
  required int questionId,
  required String selectedLetter,
}) async {
  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/multiplayer/rooms/$roomId/answers'),
    body: <String, dynamic>{
      'question_id': questionId,
      'selected_letter': selectedLetter,
    },
    errorMessage: 'Nao consegui enviar sua resposta agora.',
  );
  return parseMultiplayerAnswerResult(payload);
}

Future<MultiplayerRoom> joinMultiplayerRoom({
  required String pin,
  String? displayName,
}) async {
  final body = <String, dynamic>{'pin': pin.trim()};
  final normalizedDisplayName = displayName?.trim();
  if (normalizedDisplayName != null && normalizedDisplayName.isNotEmpty) {
    body['display_name'] = normalizedDisplayName;
  }

  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/multiplayer/rooms/join'),
    body: body,
    errorMessage: 'Não encontrei essa sala. Confira o PIN e tente novamente.',
  );
  return parseMultiplayerRoom(payload);
}

Future<MultiplayerRoom> fetchMultiplayerRoom(int roomId) async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/multiplayer/rooms/$roomId'),
    errorMessage: 'Não consegui atualizar a sala agora.',
  );
  return parseMultiplayerRoom(payload);
}

Future<MultiplayerRoom> fetchMultiplayerRoomByPin(String pin) async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/multiplayer/rooms/pin/${pin.trim()}'),
    errorMessage: 'Não encontrei uma sala com esse PIN.',
  );
  return parseMultiplayerRoom(payload);
}

Future<MultiplayerRoom> removeMultiplayerParticipant({
  required int roomId,
  required int participantId,
}) async {
  await deleteJson(
    Uri.parse(
      '${apiBaseUrl()}/multiplayer/rooms/$roomId/participants/$participantId',
    ),
    errorMessage: 'Não consegui remover esse participante agora.',
  );
  return fetchMultiplayerRoom(roomId);
}

Future<void> leaveMultiplayerRoom(int roomId) async {
  await postJson(
    Uri.parse('${apiBaseUrl()}/multiplayer/rooms/$roomId/leave'),
    body: const <String, dynamic>{},
    errorMessage: 'Não consegui tirar você da sala agora.',
  );
}

Future<MultiplayerRoom> startMultiplayerRoom(int roomId) async {
  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/multiplayer/rooms/$roomId/start'),
    body: const <String, dynamic>{},
    errorMessage: 'Ainda não consegui iniciar a partida.',
  );
  return parseMultiplayerRoom(payload);
}
