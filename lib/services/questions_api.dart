import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

String apiBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:8000';
  }
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000';
  }
  return 'http://localhost:8000';
}

class SubcategoryItem {
  const SubcategoryItem({required this.name, required this.total});

  final String name;
  final int total;
}

Future<List<SubcategoryItem>> fetchSubcategories(String discipline) async {
  final token = await FirebaseAuth.instance.currentUser?.getIdToken();
  if (token == null || token.isEmpty) {
    throw Exception('Usuário não autenticado.');
  }

  final uri = Uri.parse('${apiBaseUrl()}/questions/subcategorias')
      .replace(queryParameters: {'disciplina': discipline});
  final response = await http.get(
    uri,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode != 200) {
    throw Exception('Erro ao carregar subcategorias (${response.statusCode}).');
  }

  final payload = jsonDecode(response.body) as Map<String, dynamic>;
  final items = payload['items'];
  if (items is! List) {
    return [];
  }
  return items
      .whereType<Map>()
      .map(
        (e) => SubcategoryItem(
          name: e['nome']?.toString() ?? '',
          total: int.tryParse(e['total']?.toString() ?? '') ?? 0,
        ),
      )
      .where((item) => item.name.trim().isNotEmpty)
      .toList();
}
