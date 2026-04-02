# Cognix App 🚀

Uma plataforma de estudos focada em evolução real: autenticação segura, treino por áreas, simulados e métricas claras de desempenho. Tudo pensado para transformar constância em resultado. ✨

## Produção (guia rápido) ✅

1. Defina a URL da API de produção (HTTPS) no build:
   ```bash
   flutter build apk --release --dart-define=API_BASE_URL=https://api.seudominio.com
   # ou
   flutter build appbundle --release --dart-define=API_BASE_URL=https://api.seudominio.com
   # iOS (no Mac)
   flutter build ios --release --dart-define=API_BASE_URL=https://api.seudominio.com
   ```
2. Garanta IDs reais e Firebase alinhados:
   - Android: `applicationId` em `android/app/build.gradle.kts`.
   - iOS: `PRODUCT_BUNDLE_IDENTIFIER` em `ios/Runner.xcodeproj/project.pbxproj`.
   - Firebase: `google-services.json` e `GoogleService-Info.plist` do mesmo app.
3. Assinatura de release:
   - Android: gerar keystore e configurar `signingConfig` no Gradle.
   - iOS: abrir no Xcode e configurar assinatura (Team/Signing).
4. Teste um release antes de subir:
   ```bash
   flutter run --release --dart-define=API_BASE_URL=https://api.seudominio.com
   ```

## Primeiros passos (obrigatório ao clonar) ✅

1. Instale dependências:
   ```bash
   flutter pub get
   ```
2. Gere a splash nativa:
   ```bash
   dart run flutter_native_splash:create
   ```
3. Gere os ícones do app (ordem correta):

   ```bash
   # Use apenas se ainda não existir flutter_launcher_icons.yaml na raiz do projeto
   dart run flutter_launcher_icons:generate

   # Depois, gere os ícones a partir do YAML
   dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
   ```

   Obs: o `generate` só é necessário quando o YAML não existe.

4. Garanta o Firebase configurado:
   `lib/firebase_options.dart` deve corresponder ao projeto Firebase que você vai usar.
5. Rode o app:
   ```bash
   flutter run
   ```

Se você trocar a imagem ou a cor da splash, edite `flutter_native_splash.yaml` e rode o comando novamente.

Se você trocar o ícone, edite `flutter_launcher_icons.yaml` e rode o comando novamente.
