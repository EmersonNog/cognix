import 'core.dart';
import 'models.dart';
import 'parsers.dart';

List<SubcategoryItem> parseSubcategoryItems(
  Map<String, dynamic> payload, {
  String fallbackDiscipline = '',
}) {
  final items = payload['items'];
  if (items is! List) {
    return [];
  }

  return items
      .whereType<Map>()
      .map(
        (item) =>
            parseSubcategoryItem(item, fallbackDiscipline: fallbackDiscipline),
      )
      .where((item) => item.name.trim().isNotEmpty)
      .toList();
}

Future<String?> _findCanonicalDisciplineName(String discipline) async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/questions/disciplines'),
    errorMessage: 'Erro ao carregar disciplinas',
  );

  final items = payload['items'];
  if (items is! List) {
    return null;
  }

  final expected = _normalizeText(discipline);
  for (final item in items) {
    final value = item?.toString().trim();
    if (value == null || value.isEmpty) {
      continue;
    }
    if (_normalizeText(value) == expected) {
      return value;
    }
  }
  return null;
}

Future<String?> _tryFindCanonicalDisciplineName(String discipline) async {
  try {
    return await _findCanonicalDisciplineName(discipline);
  } catch (_) {
    return null;
  }
}

Future<String?> _findCanonicalSubcategoryName({
  required String discipline,
  required String subcategory,
}) async {
  final payload = await getJson(
    Uri.parse(
      '${apiBaseUrl()}/questions/subcategories',
    ).replace(queryParameters: {'discipline': discipline}),
    errorMessage: 'Erro ao carregar subcategorias',
  );

  final items = payload['items'];
  if (items is! List) {
    return null;
  }

  final expected = _normalizeText(subcategory);
  for (final item in items.whereType<Map>()) {
    final value = item['name']?.toString().trim();
    if (value == null || value.isEmpty) {
      continue;
    }
    if (_normalizeText(value) == expected) {
      return value;
    }
  }
  return null;
}

Future<String?> _tryFindCanonicalSubcategoryName({
  required String discipline,
  required String subcategory,
}) async {
  try {
    return await _findCanonicalSubcategoryName(
      discipline: discipline,
      subcategory: subcategory,
    );
  } catch (_) {
    return null;
  }
}

String _normalizeText(String value) {
  const replacements = {
    '\u00E1': 'a',
    '\u00E0': 'a',
    '\u00E3': 'a',
    '\u00E2': 'a',
    '\u00E4': 'a',
    '\u00C1': 'a',
    '\u00C0': 'a',
    '\u00C3': 'a',
    '\u00C2': 'a',
    '\u00C4': 'a',
    '\u00E9': 'e',
    '\u00E8': 'e',
    '\u00EA': 'e',
    '\u00EB': 'e',
    '\u00C9': 'e',
    '\u00C8': 'e',
    '\u00CA': 'e',
    '\u00CB': 'e',
    '\u00ED': 'i',
    '\u00EC': 'i',
    '\u00EE': 'i',
    '\u00EF': 'i',
    '\u00CD': 'i',
    '\u00CC': 'i',
    '\u00CE': 'i',
    '\u00CF': 'i',
    '\u00F3': 'o',
    '\u00F2': 'o',
    '\u00F5': 'o',
    '\u00F4': 'o',
    '\u00F6': 'o',
    '\u00D3': 'o',
    '\u00D2': 'o',
    '\u00D5': 'o',
    '\u00D4': 'o',
    '\u00D6': 'o',
    '\u00FA': 'u',
    '\u00F9': 'u',
    '\u00FB': 'u',
    '\u00FC': 'u',
    '\u00DA': 'u',
    '\u00D9': 'u',
    '\u00DB': 'u',
    '\u00DC': 'u',
    '\u00E7': 'c',
    '\u00C7': 'c',
  };

  final buffer = StringBuffer();
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(replacements[char] ?? char.toLowerCase());
  }
  return buffer.toString().trim();
}

Future<QuestionsPage> requestQuestionsPage({
  required String? discipline,
  required String subcategory,
  required int limit,
  required int offset,
}) async {
  final queryParameters = <String, String>{
    'subcategory': subcategory,
    'limit': '$limit',
    'offset': '$offset',
    'include_total': 'true',
  };
  if (discipline != null && discipline.trim().isNotEmpty) {
    queryParameters['subject'] = discipline;
  }

  final payload = await getJson(
    Uri.parse(
      '${apiBaseUrl()}/questions',
    ).replace(queryParameters: queryParameters),
    errorMessage: 'Erro ao carregar questões',
  );

  return parseQuestionsPage(
    payload,
    fallbackLimit: limit,
    fallbackOffset: offset,
    fallbackDiscipline: discipline ?? '',
    fallbackSubcategory: subcategory,
  );
}

Future<List<SubcategoryItem>> loadSubcategoriesWithFallback(
  String discipline,
) async {
  final payload = await getJson(
    Uri.parse(
      '${apiBaseUrl()}/questions/subcategories',
    ).replace(queryParameters: {'discipline': discipline}),
    errorMessage: 'Erro ao carregar subcategorias',
  );

  final parsed = parseSubcategoryItems(payload, fallbackDiscipline: discipline);
  if (parsed.isNotEmpty) {
    return parsed;
  }

  final canonicalDiscipline = await _tryFindCanonicalDisciplineName(discipline);
  if (canonicalDiscipline == null || canonicalDiscipline == discipline) {
    return parsed;
  }

  final fallbackPayload = await getJson(
    Uri.parse(
      '${apiBaseUrl()}/questions/subcategories',
    ).replace(queryParameters: {'discipline': canonicalDiscipline}),
    errorMessage: 'Erro ao carregar subcategorias',
  );
  return parseSubcategoryItems(
    fallbackPayload,
    fallbackDiscipline: canonicalDiscipline,
  );
}

Future<String?> _findCanonicalSubcategoryFromDiscipline(
  String discipline,
  String subcategory,
) async {
  try {
    final items = await loadSubcategoriesWithFallback(discipline);
    final expected = _normalizeText(subcategory);
    for (final item in items) {
      if (_normalizeText(item.name) == expected) {
        return item.name;
      }
    }
  } catch (_) {}
  return null;
}

Future<QuestionsPage> loadQuestionsPageWithFallback({
  required String discipline,
  required String subcategory,
  required int limit,
  required int offset,
}) async {
  QuestionsPage? originalPage;
  Object? originalError;

  try {
    originalPage = await requestQuestionsPage(
      discipline: discipline,
      subcategory: subcategory,
      limit: limit,
      offset: offset,
    );
    if (originalPage.items.isNotEmpty || offset > 0) {
      return originalPage;
    }
  } catch (error) {
    originalError = error;
  }

  final canonicalDiscipline = await _tryFindCanonicalDisciplineName(discipline);
  final effectiveDiscipline = canonicalDiscipline ?? discipline;
  final canonicalSubcategory =
      await _findCanonicalSubcategoryFromDiscipline(
        effectiveDiscipline,
        subcategory,
      ) ??
      await _tryFindCanonicalSubcategoryName(
        discipline: effectiveDiscipline,
        subcategory: subcategory,
      );
  final effectiveSubcategory = canonicalSubcategory ?? subcategory;

  if (effectiveDiscipline != discipline ||
      effectiveSubcategory != subcategory) {
    try {
      final canonicalPage = await requestQuestionsPage(
        discipline: effectiveDiscipline,
        subcategory: effectiveSubcategory,
        limit: limit,
        offset: offset,
      );
      if (canonicalPage.items.isNotEmpty || offset > 0) {
        return canonicalPage;
      }
      originalPage ??= canonicalPage;
    } catch (error) {
      originalError ??= error;
    }
  }

  if (offset == 0) {
    try {
      final subcategoryOnlyPage = await requestQuestionsPage(
        discipline: null,
        subcategory: effectiveSubcategory,
        limit: limit,
        offset: offset,
      );
      if (subcategoryOnlyPage.items.isNotEmpty) {
        return subcategoryOnlyPage;
      }
      originalPage ??= subcategoryOnlyPage;
    } catch (error) {
      originalError ??= error;
    }
  }

  if (originalPage != null) {
    return originalPage;
  }
  if (originalError != null) {
    throw originalError;
  }

  return QuestionsPage(items: const [], limit: limit, offset: offset, total: 0);
}
