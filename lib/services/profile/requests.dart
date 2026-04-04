import '../core/api_client.dart' show apiBaseUrl, getJson, postJson;
import 'models.dart';
import 'parsers.dart';

Future<ProfileScoreData> fetchProfileScore() async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/users/profile'),
    errorMessage: 'Erro ao carregar perfil',
  );
  return parseProfileScoreData(payload);
}

Future<ProfileAvatarSelectionResult> selectProfileAvatar(
  String avatarSeed,
) async {
  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/users/avatar/select'),
    body: {'avatar_seed': avatarSeed},
    errorMessage: 'Erro ao atualizar avatar',
  );
  return parseProfileAvatarSelectionResult(payload);
}
