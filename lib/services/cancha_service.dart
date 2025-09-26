// lib/services/cancha_service.dart
import 'dart:convert';

import 'package:reservacanchaf_frontend/core/api_client.dart';
import 'package:reservacanchaf_frontend/models/cancha.dart' as cmodel;

class CanchaService {
  final _api = ApiClient();

  Future<List<cmodel.Cancha>> activas() async {
    final r = await _api.get('/api/canchas/activas');
    if (r.statusCode != 200) {
      throw Exception('Error listando canchas activas: ${r.statusCode}');
    }

    final data = jsonDecode(r.body) as List;

    return data.map<cmodel.Cancha>((e) {
      final m = (e as Map).cast<String, dynamic>();

      // Si tu modelo tiene fromJson, úsalo primero
      try {
        return cmodel.Cancha.fromJson(m);
      } catch (_) {
        // Fallback manual si el fromJson no calza
        final sedeMap = (m['sede'] as Map?)?.cast<String, dynamic>();

        final cmodel.Sede sede = cmodel.Sede(
          id: (sedeMap?['id'] as num?)?.toInt() ?? 0,
          nombre: (sedeMap?['nombre'] ?? '').toString(),
          direccion: (sedeMap?['direccion'] ?? '').toString(), // <- OBLIGATORIO
        );

        return cmodel.Cancha(
          id: (m['id'] as num?)?.toInt() ?? 0,
          activa: (m['activa'] as bool?) ?? true,
          nombre: (m['nombre'] ?? '').toString(),
          deporte: (m['deporte'] ?? '').toString(),
          sede: sede,
        );
      }
    }).toList();
  }

  Future<void> eliminar(int id) async {
    final r = await _api.delete('/api/canchas/$id');
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Error eliminando cancha: ${r.statusCode} - ${r.body}');
    }
  }
}















