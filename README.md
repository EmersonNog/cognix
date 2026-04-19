# Cognix App

App Flutter do Cognix para iOS e Android, com autenticacao via Firebase,
simulados, progresso, perfil e integracao com a API do Cognix Hub.

## Estado Atual

- API de producao: `https://sua-api.com`
- Android em release: `com.cognixhub.app`
- Firebase Android alinhado com `com.cognixhub.app`
- Keystore de release esperada em `android/app/upload-keystore.jks`
- Configuracao local da assinatura em `android/key.properties`
- APK de release: `build/app/outputs/flutter-apk/app-release.apk`
- App Bundle: `build/app/outputs/bundle/release/app-release.aab`

Observacao importante:

- Android esta pronto para release.
- iOS e macOS ainda continuam com `com.example.cognix` ate uma migracao
  separada.

## Producao

Em builds de release, o app usa por padrao:

```text
https://sua-api.com
```

Se você quiser sobrescrever a URL da API no build, use `API_BASE_URL` com
HTTPS:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://sua-api.com
flutter build appbundle --release --dart-define=API_BASE_URL=https://sua-api.com
flutter build ios --release --dart-define=API_BASE_URL=https://sua-api.com
```

Para testar release localmente:

```bash
flutter run --release
```

Ou apontando para outra API:

```bash
flutter run --release --dart-define=API_BASE_URL=https://api.seudominio.com
```

## Desenvolvimento

Em desenvolvimento:

- Web usa `http://localhost:8000`
- Android emulator usa `http://10.0.2.2:8000`
- iOS simulator e desktop usam `http://localhost:8000`

Se você quiser usar outra URL em desenvolvimento:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.0.10:8000
```

## Primeiros Passos

Instale as dependencias:

```bash
flutter pub get
```

Gere a splash nativa:

```bash
dart run flutter_native_splash:create
```

Gere os icones:

```bash
dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
```

Rode o app:

```bash
flutter run
```

## Fluxo de Autenticacao

O app usa Firebase Auth no login e no cadastro.

Depois da autenticacao:

1. o app pega um `idToken` do Firebase
2. sincroniza o usuario com o backend
3. passa a consumir a API autenticada com `Authorization: Bearer <token>`

Se o usuario ja estiver autenticado ao abrir o app, a sessao e restaurada e o
app tenta sincronizar novamente com o backend antes de entrar na home.

## Android Release

### Arquivos importantes

- `android/app/build.gradle.kts`
- `android/app/google-services.json`
- `android/key.properties`
- `android/app/upload-keystore.jks`

### Identificador do app

O Android usa:

```text
com.cognixhub.app
```

O `google-services.json` precisa ser do app Firebase Android com esse mesmo
identificador.

### Assinatura

O projeto espera estes valores em `android/key.properties`:

```properties
storePassword=SUA_SENHA_DO_STORE
keyPassword=SUA_SENHA_DA_CHAVE
keyAlias=upload
storeFile=app/upload-keystore.jks
```

Se a keystore real ainda nao existir, o projeto consegue usar assinatura de
debug para testes locais de release. Isso serve para validacao local, nao para
publicacao real.

### Build de release

APK:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://sua-api.com
```

App Bundle para Play Store:

```bash
flutter build appbundle --release --dart-define=API_BASE_URL=https://sua-api.com
```

Arquivos gerados:

```text
build/app/outputs/flutter-apk/app-release.apk
build/app/outputs/bundle/release/app-release.aab
```

## Checklist de Publicacao

Antes de publicar na Play Store, confira:

1. `version` atualizada em `pubspec.yaml`
2. `applicationId` correto em `android/app/build.gradle.kts`
3. `google-services.json` atualizado para `com.cognixhub.app`
4. `android/key.properties` preenchido com valores reais
5. `android/app/upload-keystore.jks` existente
6. SHA-1 e SHA-256 da debug key cadastrados no Firebase
7. SHA-1 e SHA-256 da keystore real cadastrados no Firebase
8. login com Google testado em debug e em release
9. API respondendo em `https://sua-api.com`

## Seguranca

Nunca suba para o Git:

- `android/key.properties`
- arquivos `.jks`
- arquivos `.keystore`
- `.env`
- outros segredos locais

Arquivos como `key.properties.example` podem ficar versionados normalmente.
