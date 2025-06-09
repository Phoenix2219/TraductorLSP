import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SupportProvider with ChangeNotifier {
  
  Future<void> sendEmail(String subject, String email, String name, String description) async  {
    if (subject.isNotEmpty && email.isNotEmpty && name.isNotEmpty) {
      const String mailgunDomain = 'sandbox644117d8fcb2429e98bd34aae4a89e6d.mailgun.org';
      final String apiKey = dotenv.env['MAILGUN_API_KEY'] ?? '';
      const String mailgunUrl = 'https://api.mailgun.net/v3/$mailgunDomain/messages';

      // Datos para el correo
      final Map<String, String> data = {
        'from': 'Soporte <mailgun@$mailgunDomain>',
        'to': 'dannrobg@gmail.com',
        'subject': subject,
        'text': 'Nombre: $name\nCorreo: $email\n\nDescripción:\n$description',
      };

      // Realiza la solicitud POST a la API de Mailgun
      final response = await http.post(
        Uri.parse(mailgunUrl),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('api:$apiKey'))}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        // Notifica que el correo fue enviado correctamente
        notifyListeners();
      } else {
        // Muestra el error
        print('================== Error al enviar el correo, codigo de error: ${response.statusCode} ========================');
      }
    } else {
      return;
    }
  }
}