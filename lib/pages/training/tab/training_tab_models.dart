class TrainingRhythmData {
  const TrainingRhythmData({
    required this.subtitle,
    required this.badgeLabel,
    required this.completedCountLabel,
    this.isLoading = false,
    this.isError = false,
  });

  const TrainingRhythmData.empty()
    : subtitle = 'Nenhum simulado iniciado ainda',
      badgeLabel = '0%',
      completedCountLabel = '0 simulados concluídos',
      isLoading = false,
      isError = false;

  const TrainingRhythmData.loading()
    : subtitle = 'Carregando seu ritmo de treino',
      badgeLabel = '...',
      completedCountLabel = 'Buscando seu histórico recente',
      isLoading = true,
      isError = false;

  const TrainingRhythmData.error()
    : subtitle = 'Não foi possível carregar agora',
      badgeLabel = '--',
      completedCountLabel = 'Puxe para atualizar',
      isLoading = false,
      isError = true;

  final String subtitle;
  final String badgeLabel;
  final String completedCountLabel;
  final bool isLoading;
  final bool isError;
}
