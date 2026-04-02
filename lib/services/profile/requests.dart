import '../core/api_client.dart' show apiBaseUrl, getJson;
import 'models.dart';
import 'parsers.dart';

Future<ProfileScoreData> fetchProfileScore() async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/users/profile'),
    errorMessage: 'Erro ao carregar perfil',
  );
  return parseProfileScoreData(payload);
}
