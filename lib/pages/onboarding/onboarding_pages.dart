class OnboardingPageSpec {
  const OnboardingPageSpec({
    required this.title,
    required this.body,
    required this.asset,
  });

  final String title;
  final String body;
  final String asset;
}

const List<OnboardingPageSpec> onboardingPages = [
  OnboardingPageSpec(
    title: 'Tudo para estudar no Cognix',
    body:
        'Questões, flashcards, redação, mapas mentais, plano semanal e foco em um só lugar para organizar sua rotina.',
    asset: 'assets/onboarding/onboarding_hub_generated.png',
  ),
  OnboardingPageSpec(
    title: 'Questões por área',
    body:
        'Treine por Ciências da Natureza, Humanas, Linguagens e Matemática, responda alternativas e acompanhe sua evolução.',
    asset: 'assets/onboarding/onboarding_questions_generated.png',
  ),
  OnboardingPageSpec(
    title: 'Mapas mentais interativos',
    body:
        'Depois do simulado, revise pontos-chave em mapas com zoom e arraste para fixar melhor cada disciplina.',
    asset: 'assets/onboarding/onboarding_maps_generated.png',
  ),
  OnboardingPageSpec(
    title: 'Flashcards do seu jeito',
    body:
        'Crie decks por matéria, adicione texto e imagens, filtre seus cartões e retome a revisão de onde parou.',
    asset: 'assets/onboarding/onboarding_flashcards_generated.png',
  ),
  OnboardingPageSpec(
    title: 'Redação com análise de IA',
    body:
        'Escolha temas, escreva com checklist, peça análise da redação e compare versões no histórico.',
    asset: 'assets/onboarding/onboarding_writing_generated.png',
  ),
  OnboardingPageSpec(
    title: 'Foto, diagnóstico e solução',
    body:
        'Fotografe uma redação ou equação para a IA ler o conteúdo, devolver um diagnóstico e organizar a solução passo a passo.',
    asset: 'assets/onboarding/onboarding_photo_ai_generated.png',
  ),
  OnboardingPageSpec(
    title: 'Plano semanal e desempenho',
    body:
        'Monte metas de estudo, acompanhe sequência, acertos, tempo e recomendações para decidir o próximo passo.',
    asset: 'assets/onboarding/onboarding_plan_generated.png',
  ),
  OnboardingPageSpec(
    title: 'Foco solo ou em grupo',
    body:
        'Use Pomodoro para estudar em blocos e crie salas multiplayer ou entre com PIN para partidas em tempo real.',
    asset: 'assets/onboarding/onboarding_focus_group_generated.png',
  ),
];
