# Cognix App

Aplicativo Flutter da Cognix para autenticação, treino por áreas de conhecimento, simulados com progresso persistido, resumos com mapa mental e acompanhamento de desempenho.

## Visão Geral

O app foi estruturado para conectar a experiência de estudo ao backend da Cognix e ao Firebase Authentication.

Principais fluxos:

- login com e-mail e senha
- login com Google
- cadastro de conta
- recuperação de senha
- navegação por áreas e subcategorias
- simulado com progresso salvo localmente e sincronizado com o backend
- retomada de sessão em andamento
- redirecionamento para resultados quando a sessão já estiver concluída
- resumo personalizado com mapa mental
- cards e métricas alimentados por dados reais

## Stack

- Flutter
- Firebase Core
- Firebase Auth
- Google Sign-In
- HTTP
- Shared Preferences
- Google Fonts
- Reactive Mind Map

## Estrutura

Estrutura principal do app:

```text
lib/
  main.dart
  routes.dart
  services/
    auth/
    core/
    local/
    questions/
    summaries/
  pages/
    auth/
    home/
    profile/
    subjects/
    training/
      session/
      results/
      widgets/
      models/
  widgets/
    cognix/
  utils/
```

### Organização por domínio

- `services/core`: cliente HTTP compartilhado e autenticação de requests
- `services/questions`: chamadas relacionadas a questões, tentativas e sessões
- `services/summaries`: resumo, mapa mental e progresso
- `pages/training/session`: fluxo específico do simulado
- `pages/training/results`: tela e widgets de resultados
- `widgets/cognix`: base visual reutilizável do app

## Integração com backend

O app consome a API da Cognix para:

- buscar subcategorias e questões
- enviar tentativas
- salvar sessão do simulado
- restaurar sessão
- limpar sessão ao refazer
- consultar overview de sessões
- buscar resumo personalizado
- buscar progresso real do treino

### Sessões de treino

O fluxo de treino foi conectado ao backend para permitir:

- continuar um simulado em andamento
- manter sessão concluída
- reabrir resultados em vez de reiniciar a última questão
- sincronizar entre dispositivos com a mesma conta, desde que a sessão tenha sido persistida com sucesso

## Autenticação

O app usa Firebase Authentication.

Fluxos disponíveis:

- `login`
- `register`
- `forgot`

Essas rotas estão registradas em [`lib/routes.dart`](./lib/routes.dart).

## Como rodar

### 1. Instale dependências

```bash
flutter pub get
```

### 2. Configure o Firebase

O projeto já possui:

- [`lib/firebase_options.dart`](./lib/firebase_options.dart)

Garanta que a configuração do Firebase usada no ambiente local está válida para o projeto que você quer testar.

### 3. Rode o app

```bash
flutter run
```

## Build e qualidade

Comandos úteis:

```bash
flutter analyze
flutter test
```

## Funcionalidades de treino

### Training Tab

- mostra o ritmo do usuário com dados reais
- mostra total real de questões por área
- atualiza ao voltar de outras telas

### Training Detail

- mostra progresso real da subcategoria
- CTA dinâmico:
  - `Iniciar Simulado`
  - `Continuar Simulado`
  - `Ver Resultados`

### Training Session

- carrega questões paginadas
- salva estado local
- sincroniza sessão com backend
- restaura sessão em andamento
- persiste sessão concluída

### Training Results

- exibe desempenho do simulado
- permite refazer
- permite voltar ao painel

### Training Summary

- busca resumo personalizado
- exibe métricas
- renderiza mapa mental interativo

## Observações

- parte do conteúdo visual ainda usa dados mockados em alguns cards da home
- o fluxo principal de treino já está integrado ao backend
- o app foi refatorado para reduzir arquivos monolíticos e organizar a feature `training` por domínio

## Próximos passos sugeridos

- adicionar constantes de rota para evitar strings soltas
- aumentar cobertura com testes de widgets e serviços
- revisar os últimos textos estáticos da home para maior consistência editorial
- documentar variáveis de ambiente e ambientes de backend
