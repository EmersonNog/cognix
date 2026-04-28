part of '../requests.dart';

Uri _writingThemesUri({
  String? category,
  String? search,
  int limit = 10,
  int offset = 0,
}) {
  final queryParameters = <String, String>{
    'limit': '$limit',
    'offset': '$offset',
  };
  if (category != null && category.trim().isNotEmpty) {
    queryParameters['category'] = category.trim();
  }
  if (search != null && search.trim().isNotEmpty) {
    queryParameters['search'] = search.trim();
  }

  return Uri.parse(
    '${apiBaseUrl()}/writing/themes',
  ).replace(queryParameters: queryParameters);
}

Future<WritingThemesData> fetchWritingThemes({
  String? category,
  String? search,
  int limit = 10,
  int offset = 0,
}) async {
  final payload = await getJson(
    _writingThemesUri(
      category: category,
      search: search,
      limit: limit,
      offset: offset,
    ),
    errorMessage: 'Não consegui carregar os temas de redação',
  );
  return parseWritingThemesData(payload);
}

Future<WritingThemesAccessResult> fetchWritingThemesWithAccess({
  String? category,
  String? search,
  int limit = 10,
  int offset = 0,
}) async {
  try {
    final data = await fetchWritingThemes(
      category: category,
      search: search,
      limit: limit,
      offset: offset,
    );
    return WritingThemesAccessResult.available(data);
  } on SubscriptionRequiredException {
    final lockedData = await _tryFetchLockedWritingThemes(
      category: category,
      search: search,
      limit: limit,
      offset: offset,
    );

    return WritingThemesAccessResult.locked(
      _hasAnyThemeContent(lockedData)
          ? lockedData
          : _buildPreviewWritingThemes(
              category: category,
              search: search,
              limit: limit,
              offset: offset,
            ),
    );
  }
}

bool _hasAnyThemeContent(WritingThemesData data) {
  return data.items.isNotEmpty ||
      data.categories.isNotEmpty ||
      data.monthlyTheme != null;
}

Future<WritingThemesData> _tryFetchLockedWritingThemes({
  String? category,
  String? search,
  int limit = 10,
  int offset = 0,
}) async {
  try {
    final token = await requireAuthToken();
    final response = await http
        .get(
          _writingThemesUri(
            category: category,
            search: search,
            limit: limit,
            offset: offset,
          ),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(apiTimeout);

    final payload = _decodeWritingThemesPayload(response.body);
    if (payload == null) {
      return const WritingThemesData.empty();
    }

    final hasThemeData =
        payload['items'] is List ||
        payload['monthly_theme'] is Map ||
        payload['categories'] is List;
    if (!hasThemeData) {
      return const WritingThemesData.empty();
    }

    return parseWritingThemesData(payload);
  } catch (_) {
    return const WritingThemesData.empty();
  }
}

Map<String, dynamic>? _decodeWritingThemesPayload(String body) {
  if (body.trim().isEmpty) {
    return null;
  }

  try {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
  } catch (_) {
    return null;
  }

  return null;
}
