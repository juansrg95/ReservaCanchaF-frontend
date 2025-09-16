import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';
import '../models/cancha.dart';

// Este servicio es el "puente" entre el frontend y el backend.
// Aquí creo métodos que llaman al backend usando HTTP.
class CanchaService {
  final String baseUrl = Env.apiUrl;

  // Método para obtener todas las canchas desde el backend
  Future<List<Cancha>> obtenerCanchas() async {
    final response = await http.get(Uri.parse('$baseUrl/canchas'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Cancha.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar las canchas");
    }
  }
}
