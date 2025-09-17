import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';
import '../models/cancha.dart';

/// Servicio que habla con mi backend (Spring) para obtener las canchas.
class CanchaService {
  /// Traigo todas las canchas con un GET a `${Env.baseUrl}/api/canchas`.
  Future<List<Cancha>> getCanchas() async {
    final uri = Uri.parse('${Env.baseUrl}/api/canchas/activas');

    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
    });

    if (resp.statusCode == 200) {
      // Mi backend devuelve un JSON con lista de canchas
      final List data = json.decode(resp.body);
      return data.map((e) => Cancha.fromJson(e as Map<String, dynamic>)).toList();
    }

    // Si algo falla, lanzo una excepción para mostrar error en UI
    throw Exception('Error ${resp.statusCode} al cargar canchas');
  }
}

