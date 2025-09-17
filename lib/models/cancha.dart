// lib/models/cancha.dart
// Modelo de Cancha alineado con lo que devuelve el backend.
// OJO: el backend envía "sede" como OBJETO { id, nombre, direccion }, no "sede_id".

import 'sede.dart';

class Cancha {
  final int id;
  final String nombre;
  final String deporte;
  final bool activa;
  final Sede sede; // <- ahora guardo el objeto Sede completo

  Cancha({
    required this.id,
    required this.nombre,
    required this.deporte,
    required this.activa,
    required this.sede,
  });

  factory Cancha.fromJson(Map<String, dynamic> json) {
    return Cancha(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      deporte: json['deporte'] as String,
      activa: json['activa'] as bool,
      sede: Sede.fromJson(json['sede'] as Map<String, dynamic>), // <- parseo la sede
    );
  }
}

