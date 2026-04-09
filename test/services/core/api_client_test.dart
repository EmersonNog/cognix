import 'package:cognix/services/core/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveApiBaseUrl', () {
    test('usa a URL de producao por padrao em release', () {
      final baseUrl = resolveApiBaseUrl(
        envBaseUrl: '',
        isReleaseMode: true,
        isWeb: false,
        targetPlatform: TargetPlatform.iOS,
      );

      expect(baseUrl, 'https://api.cognix-hub.com');
    });

    test('aceita override HTTPS em release', () {
      final baseUrl = resolveApiBaseUrl(
        envBaseUrl: 'https://api.exemplo.com/',
        isReleaseMode: true,
        isWeb: false,
        targetPlatform: TargetPlatform.android,
      );

      expect(baseUrl, 'https://api.exemplo.com');
    });

    test('rejeita override HTTP em release', () {
      expect(
        () => resolveApiBaseUrl(
          envBaseUrl: 'http://localhost:8000',
          isReleaseMode: true,
          isWeb: false,
          targetPlatform: TargetPlatform.android,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('usa 10.0.2.2 no Android em debug', () {
      final baseUrl = resolveApiBaseUrl(
        envBaseUrl: '',
        isReleaseMode: false,
        isWeb: false,
        targetPlatform: TargetPlatform.android,
      );

      expect(baseUrl, 'http://10.0.2.2:8000');
    });

    test('usa localhost no iOS em debug', () {
      final baseUrl = resolveApiBaseUrl(
        envBaseUrl: '',
        isReleaseMode: false,
        isWeb: false,
        targetPlatform: TargetPlatform.iOS,
      );

      expect(baseUrl, 'http://localhost:8000');
    });
  });
}
