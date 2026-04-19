part of '../api_client.dart';

const String _productionApiBaseUrl = 'https://api.cognix-hub.com';
const String _localhostApiBaseUrl = 'http://localhost:8000';
const String _androidEmulatorApiBaseUrl = 'http://10.0.2.2:8000';

String normalizeApiBaseUrl(String rawBaseUrl) {
  return rawBaseUrl.trim().replaceFirst(RegExp(r'/+$'), '');
}

String resolveApiBaseUrl({
  required String envBaseUrl,
  required bool isReleaseMode,
  required bool isWeb,
  required TargetPlatform targetPlatform,
}) {
  final normalizedEnvBaseUrl = normalizeApiBaseUrl(envBaseUrl);
  if (normalizedEnvBaseUrl.isNotEmpty) {
    if (isReleaseMode && !normalizedEnvBaseUrl.startsWith('https://')) {
      throw StateError(
        'API_BASE_URL precisa usar HTTPS em builds de produção.',
      );
    }
    return normalizedEnvBaseUrl;
  }

  if (isReleaseMode) {
    return _productionApiBaseUrl;
  }

  if (isWeb) {
    return _localhostApiBaseUrl;
  }

  if (targetPlatform == TargetPlatform.android) {
    return _androidEmulatorApiBaseUrl;
  }

  return _localhostApiBaseUrl;
}

String apiBaseUrl() {
  const envBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
  return resolveApiBaseUrl(
    envBaseUrl: envBaseUrl,
    isReleaseMode: kReleaseMode,
    isWeb: kIsWeb,
    targetPlatform: defaultTargetPlatform,
  );
}

String apiWebSocketBaseUrl() {
  final baseUrl = apiBaseUrl();
  if (baseUrl.startsWith('https://')) {
    return 'wss://${baseUrl.substring('https://'.length)}';
  }
  if (baseUrl.startsWith('http://')) {
    return 'ws://${baseUrl.substring('http://'.length)}';
  }
  throw StateError('API_BASE_URL inválida para WebSocket.');
}

