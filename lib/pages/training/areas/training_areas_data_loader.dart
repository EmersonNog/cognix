import '../../../services/questions/questions_api.dart';
import '../../../services/core/api_client.dart'
    show isSubscriptionRequiredError;
import '../../subjects/subjects_data.dart';
import 'training_area_models.dart';

class TrainingAreasDataLoader {
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
      } catch (error) {
        if (isSubscriptionRequiredError(error)) {
          rethrow;
        }
        totals[item.area] = 0;
      }
    }

    return totals;
  }
}
