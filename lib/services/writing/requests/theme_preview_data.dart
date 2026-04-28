part of '../requests.dart';

WritingThemesData _buildPreviewWritingThemes({
  String? category,
  String? search,
  int limit = 10,
  int offset = 0,
}) {
  final normalizedCategory = category?.trim().toLowerCase();
  final normalizedSearch = search?.trim().toLowerCase() ?? '';

  final filteredThemes = _previewWritingThemes
      .where((theme) {
        return _previewThemeMatchesFilters(
          theme,
          normalizedCategory: normalizedCategory,
          normalizedSearch: normalizedSearch,
        );
      })
      .toList(growable: false);

  final total = filteredThemes.length;
  final safeOffset = offset < 0 ? 0 : (offset > total ? total : offset);
  final safeEnd = safeOffset + limit > total ? total : safeOffset + limit;
  final pageItems = safeOffset >= total
      ? const <WritingTheme>[]
      : filteredThemes.sublist(safeOffset, safeEnd);

  final monthlyTheme =
      _previewThemeMatchesFilters(
        _previewMonthlyTheme,
        normalizedCategory: normalizedCategory,
        normalizedSearch: normalizedSearch,
      )
      ? _previewMonthlyTheme
      : null;

  return WritingThemesData(
    items: pageItems,
    categories: _previewThemeCategories,
    total: total,
    limit: limit,
    offset: safeOffset,
    hasMore: safeEnd < total,
    monthlyTheme: monthlyTheme,
  );
}

bool _previewThemeMatchesFilters(
  WritingTheme theme, {
  String? normalizedCategory,
  required String normalizedSearch,
}) {
  if (normalizedCategory != null &&
      normalizedCategory.isNotEmpty &&
      theme.category.toLowerCase() != normalizedCategory) {
    return false;
  }

  if (normalizedSearch.isEmpty) {
    return true;
  }

  final haystack = [
    theme.title,
    theme.category,
    theme.description,
    theme.exam,
    ...theme.keywords,
  ].join(' ').toLowerCase();

  return haystack.contains(normalizedSearch);
}

const _previewThemeCategories = <String>[
  'Tecnologia',
  'Sociedade',
  'Educação',
  'Saúde',
  'Cidadania',
  'Meio ambiente',
];

const _previewMonthlyTheme = WritingTheme(
  id: 'preview-monthly-theme',
  title:
      'Os desafios para equilibrar inovação e responsabilidade no uso da inteligência artificial',
  category: 'Tecnologia',
  description:
      'Discuta como escola, governo e sociedade podem promover o uso ético da IA no cotidiano brasileiro.',
  keywords: ['ética digital', 'inovação', 'regulação'],
  difficulty: 'médio',
  exam: 'ENEM',
);

const _previewWritingThemes = <WritingTheme>[
  WritingTheme(
    id: 'preview-theme-1',
    title: 'Caminhos para combater a desinformação nas redes sociais',
    category: 'Tecnologia',
    description:
        'Analise como educação midiática, plataformas e políticas públicas podem reduzir a circulação de boatos.',
    keywords: ['redes sociais', 'informação', 'cidadania digital'],
    difficulty: 'médio',
    exam: 'ENEM',
  ),
  WritingTheme(
    id: 'preview-theme-2',
    title: 'Desafios para ampliar o acesso à leitura entre adolescentes',
    category: 'Educação',
    description:
        'Discuta barreiras culturais e escolares para a formação de leitores no Brasil contemporâneo.',
    keywords: ['leitura', 'juventude', 'escola'],
    difficulty: 'fácil',
    exam: 'ENEM',
  ),
  WritingTheme(
    id: 'preview-theme-3',
    title: 'Os impactos da crise climática na rotina das cidades brasileiras',
    category: 'Meio ambiente',
    description:
        'Aborde efeitos de enchentes, ondas de calor e falhas urbanas sobre a vida da população.',
    keywords: ['clima', 'cidades', 'sustentabilidade'],
    difficulty: 'médio',
    exam: 'ENEM',
  ),
  WritingTheme(
    id: 'preview-theme-4',
    title: 'A persistência da insegurança alimentar no Brasil',
    category: 'Sociedade',
    description:
        'Reflita sobre renda, acesso à comida de qualidade e o papel de políticas de proteção social.',
    keywords: ['fome', 'desigualdade', 'políticas públicas'],
    difficulty: 'difícil',
    exam: 'ENEM',
  ),
  WritingTheme(
    id: 'preview-theme-5',
    title: 'A valorização do trabalho de cuidado na sociedade contemporânea',
    category: 'Sociedade',
    description:
        'Discuta o reconhecimento social e econômico do cuidado com crianças, idosos e pessoas dependentes.',
    keywords: ['trabalho', 'família', 'equidade'],
    difficulty: 'médio',
    exam: 'ENEM',
  ),
  WritingTheme(
    id: 'preview-theme-6',
    title: 'Desafios para garantir saúde mental aos jovens brasileiros',
    category: 'Saúde',
    description:
        'Analise o peso da pressão social, do ambiente escolar e do uso intenso de telas sobre adolescentes.',
    keywords: ['saúde mental', 'juventude', 'prevenção'],
    difficulty: 'médio',
    exam: 'ENEM',
  ),
  WritingTheme(
    id: 'preview-theme-7',
    title: 'O papel da escola na construção da cidadania digital',
    category: 'Educação',
    description:
        'Debata como a formação escolar pode preparar estudantes para uso crítico e seguro da internet.',
    keywords: ['escola', 'internet', 'formação cidadã'],
    difficulty: 'fácil',
    exam: 'ENEM',
  ),
  WritingTheme(
    id: 'preview-theme-8',
    title: 'Como fortalecer a participação política da juventude',
    category: 'Cidadania',
    description:
        'Discuta meios de ampliar engajamento democrático de jovens em conselhos, escolas e comunidades.',
    keywords: ['democracia', 'juventude', 'participação'],
    difficulty: 'médio',
    exam: 'ENEM',
  ),
  WritingTheme(
    id: 'preview-theme-9',
    title:
        'Os limites éticos do uso de reconhecimento facial em espaços públicos',
    category: 'Tecnologia',
    description:
        'Reflita sobre segurança, privacidade e vieses em sistemas automatizados de vigilância.',
    keywords: ['privacidade', 'segurança', 'tecnologia'],
    difficulty: 'difícil',
    exam: 'ENEM',
  ),
  WritingTheme(
    id: 'preview-theme-10',
    title: 'Desafios para promover mobilidade urbana mais inclusiva',
    category: 'Cidadania',
    description:
        'Analise transporte público, acessibilidade e planejamento urbano na garantia do direito de ir e vir.',
    keywords: ['mobilidade', 'acessibilidade', 'cidades'],
    difficulty: 'médio',
    exam: 'ENEM',
  ),
  WritingTheme(
    id: 'preview-theme-11',
    title: 'A importância da vacinação diante da queda na cobertura vacinal',
    category: 'Saúde',
    description:
        'Debata os efeitos da desinformação e as estratégias coletivas para retomar a confiança em campanhas.',
    keywords: ['vacinação', 'prevenção', 'saúde pública'],
    difficulty: 'fácil',
    exam: 'ENEM',
  ),
  WritingTheme(
    id: 'preview-theme-12',
    title: 'Caminhos para ampliar a economia circular no cotidiano brasileiro',
    category: 'Meio ambiente',
    description:
        'Discuta consumo consciente, reuso de materiais e responsabilidade compartilhada entre empresas e sociedade.',
    keywords: ['consumo', 'reciclagem', 'sustentabilidade'],
    difficulty: 'médio',
    exam: 'ENEM',
  ),
];
