import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sign_language_translator/core/constants/constants.dart';

class UsersProvider with ChangeNotifier {
  List<Map<String, dynamic>> _users = [];

  List<Map<String, dynamic>> get users => _users;

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseAPIUrl/usuarios'));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      _users = List<Map<String, dynamic>>.from(responseBody);
      notifyListeners();
    }
  }

  Future<void> addUser(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse('$baseAPIUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );

    if (response.statusCode == 201) {
      _users.add(user); 
      notifyListeners();
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> updatedUser) async {
    final response = await http.put(
      Uri.parse('$baseAPIUrl/usuarios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedUser),
    );

    if (response.statusCode == 200) {
      final index = _users.indexWhere((u) => u['id_usuario'] == id);
      if (index != -1) {
        _users[index] = updatedUser; 
        notifyListeners();
      }
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseAPIUrl/usuarios/$id'));

    if (response.statusCode == 204) {
      _users.removeWhere((u) => u['id_usuario'] == id); // Elimina el usuario de la lista
      notifyListeners();
    }
  }
}
