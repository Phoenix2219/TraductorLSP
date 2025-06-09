import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sign_language_translator/core/constants/constants.dart';

class SavedTranslationsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _translations = [];

  List<Map<String, dynamic>> get translations => _translations;

  Future<void> fetchTranslations({int? userId}) async {
    final uri = userId != null
        ? Uri.parse('$baseAPIUrl/traducciones?id_usuario=$userId')
        : Uri.parse('$baseAPIUrl/traducciones');
    
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      _translations = List<Map<String, dynamic>>.from(responseBody);
      notifyListeners();
    }
  }

  Future<void> deleteTranslation(int id) async {
    final uri = Uri.parse('$baseAPIUrl/traducciones/$id');
    final response = await http.delete(uri);

    if (response.statusCode == 204) {
      _translations.removeWhere((translation) => translation['id_traduccion'] == id);
      notifyListeners();
    }
  }

  Future<void> updateTranslation(int id, Map<String, dynamic> updatedTranslation) async {
    final uri = Uri.parse('$baseAPIUrl/traducciones/$id');
    final response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedTranslation));

    if (response.statusCode == 200) {
      final index = _translations.indexWhere((t) => t['id_traduccion'] == id);
      _translations[index] = updatedTranslation;
      notifyListeners();
    }
  }
}
