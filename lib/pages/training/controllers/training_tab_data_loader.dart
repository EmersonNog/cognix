import '../../../services/questions/questions_api.dart';
import '../../subjects/subjects_data.dart';
import '../models/training_tab_models.dart';

class TrainingTabDataLoader {
  Future<TrainingRhythmData> loadRhythmData() async {
    try {
      final overview = await fetchTrainingSessionsOverview();
      final latest = overview.latestSession;
      final completedCountLabel =
          '${overview.completedSessions} '
          '${overview.completedSessions == 1 ? 'simulado concluído' : 'simulados concluídos'}';

      if (latest == null) {
        if (overview.inProgressSessions > 0) {
          final inProgressLabel =
              '${overview.inProgressSessions} '
              '${overview.inProgressSessions == 1 ? 'simulado em andamento' : 'simulados em andamento'}';
          return TrainingRhythmData(
            subtitle: 'Você ainda tem treino para retomar',
            badgeLabel: '${overview.inProgressSessions}x',
            completedCountLabel: inProgressLabel,
          );
        }

        if (overview.completedSessions > 0) {
          return TrainingRhythmData(
            subtitle: 'Seu histórico recente já está salvo',
            badgeLabel: '${overview.completedSessions}x',
            completedCountLabel: completedCountLabel,
          );
        }

        return const TrainingRhythmData.empty();
      }

      if (latest.completed) {
        final percent = latest.totalQuestions <= 0
            ? 0
            : ((latest.answeredQuestions / latest.totalQuestions) * 100)
                  .round();
        return TrainingRhythmData(
          subtitle: latest.subcategory.isEmpty
              ? 'último simulado concluído'
              : 'último simulado concluído em ${latest.subcategory}',
          badgeLabel: '$percent%',
          completedCountLabel: completedCountLabel,
        );
      }

      return TrainingRhythmData(
        subtitle: latest.subcategory.isEmpty
            ? 'Simulado em andamento'
            : 'Continuando ${latest.subcategory}',
        badgeLabel: latest.totalQuestions <= 0
            ? '${latest.answeredQuestions}'
            : '${latest.answeredQuestions}/${latest.totalQuestions}',
        completedCountLabel: completedCountLabel,
      );
    } catch (_) {
      return const TrainingRhythmData.error();
    }
  }

  Future<Map<SubjectsArea, int>> loadAreaTotals() async {
    final totals = <SubjectsArea, int>{};

    for (final item in trainingAreas) {
      try {
        final subcategories = await fetchSubcategories(
          subjectsAreaTitle(item.area),
        );
        totals[item.area] = subcategories.fold<int>(
          0,
          (sum, subcategory) => sum + subcategory.total,
        );
      } catch (_) {
        totals[item.area] = 0;
      }
    }

    return totals;
  }
}
