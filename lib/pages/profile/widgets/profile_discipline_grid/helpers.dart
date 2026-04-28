part of '../profile_discipline_grid.dart';

String? _canonicalDisciplineKey(String value) {
  switch (_normalizeDiscipline(value)) {
    case 'linguagens':
    case 'linguagens, codigos e suas tecnologias':
      return 'linguagens';
    case 'ciencias humanas':
    case 'ciencias humanas e suas tecnologias':
      return 'ciencias_humanas';
    case 'ciencias da natureza':
    case 'ciencias da natureza e suas tecnologias':
      return 'ciencias_natureza';
    case 'matematica':
    case 'matematica e suas tecnologias':
      return 'matematica';
    default:
      return null;
  }
}

String _normalizeDiscipline(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('à', 'a')
      .replaceAll('â', 'a')
      .replaceAll('ã', 'a')
      .replaceAll('é', 'e')
      .replaceAll('ê', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ô', 'o')
      .replaceAll('õ', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ç', 'c')
      .replaceAll('Ã¡', 'a')
      .replaceAll('Ã ', 'a')
      .replaceAll('Ã¢', 'a')
      .replaceAll('Ã£', 'a')
      .replaceAll('Ã©', 'e')
      .replaceAll('Ãª', 'e')
      .replaceAll('Ã­', 'i')
      .replaceAll('Ã³', 'o')
      .replaceAll('Ã´', 'o')
      .replaceAll('Ãµ', 'o')
      .replaceAll('Ãº', 'u')
      .replaceAll('Ã§', 'c')
      .replaceAll('ÃƒÂ¡', 'a')
      .replaceAll('ÃƒÂ ', 'a')
      .replaceAll('ÃƒÂ¢', 'a')
      .replaceAll('ÃƒÂ£', 'a')
      .replaceAll('ÃƒÂ©', 'e')
      .replaceAll('ÃƒÂª', 'e')
      .replaceAll('ÃƒÂ­', 'i')
      .replaceAll('ÃƒÂ³', 'o')
      .replaceAll('ÃƒÂ´', 'o')
      .replaceAll('ÃƒÂµ', 'o')
      .replaceAll('ÃƒÂº', 'u')
      .replaceAll('ÃƒÂ§', 'c');
}

String _questionsLabel(int count) {
  return count == 1 ? 'questão respondida' : 'questões respondidas';
}

String _disciplineCaption(int count) {
  if (count == 1) {
    return 'Início';
  }

  if (count < 10) {
    return 'Primeiros passos';
  }

  if (count < 100) {
    return 'Em evolução';
  }

  return 'Consistênte';
}
