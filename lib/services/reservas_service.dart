// lib/services/reservas_service.dart
import 'dart:convert';
import 'package:reservacanchaf_frontend/core/api_client.dart';
import 'package:reservacanchaf_frontend/core/session.dart';
import 'package:reservacanchaf_frontend/models/reserva.dart';

class ReservasService {
  final _api = ApiClient();

  Future<List<Reserva>> listar() async {
    final r = await _api.get('/api/reservas');
    if (r.statusCode != 200) {
      throw Exception('Error listando reservas: ${r.statusCode}');
    }
    final data = jsonDecode(r.body) as List;

    // Usa fromJson si existe; si no, hace un mapeo manual tipado.
    return data.map<Reserva>((e) {
      final m = e as Map<String, dynamic>;
      try {
        // si tu modelo tiene fromJson, esto compila
        return Reserva.fromJson(m);
      } catch (_) {
        // fallback seguro si no existe fromJson
        return Reserva(
          id: (m['id'] as num?)?.toInt(),
          inicio: DateTime.tryParse(m['inicio']?.toString() ?? ''),
          fin: DateTime.tryParse(m['fin']?.toString() ?? ''),
          estado: m['estado']?.toString(),
        );
      }
    }).toList();
  }

  Future<void> crear({
    required int canchaId,
    required DateTime inicio,
    required DateTime fin,
  }) async {
    final body = jsonEncode({
      'canchaId': canchaId,
      'inicio': inicio.toIso8601String(),
      'fin': fin.toIso8601String(),
      'usuario': Session.username ?? 'user',
    });

    final r = await _api.post('/api/reservas', body: body);
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Error creando reserva: ${r.statusCode} - ${r.body}');
    }
  }

  Future<void> actualizar({
    required int id,
    required int canchaId,
    required DateTime inicio,
    required DateTime fin,
  }) async {
    final body = jsonEncode({
      'canchaId': canchaId,
      'inicio': inicio.toIso8601String(),
      'fin': fin.toIso8601String(),
      'usuario': Session.username ?? 'user',
    });

    final r = await _api.put('/api/reservas/$id', body: body);
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Error actualizando reserva: ${r.statusCode} - ${r.body}');
    }
  }

  /// Cancela robusto (prueba 3 rutas comunes).
  Future<void> cancelar(int id) async {
    // Plan A: POST /cancelar
    try {
      final r1 = await _api.post('/api/reservas/$id/cancelar', body: jsonEncode({}));
      if (r1.statusCode >= 200 && r1.statusCode < 300) return;
    } catch (_) {}

    // Plan B: DELETE /{id}
    try {
      final r2 = await _api.delete('/api/reservas/$id');
      if (r2.statusCode >= 200 && r2.statusCode < 300) return;
    } catch (_) {}

    // Plan C: PUT estado=CANCELADA
    final r3 = await _api.put('/api/reservas/$id', body: jsonEncode({'estado': 'CANCELADA'}));
    if (r3.statusCode < 200 || r3.statusCode >= 300) {
      throw Exception('Error cancelando reserva: ${r3.statusCode} - ${r3.body}');
    }
  }
}
















