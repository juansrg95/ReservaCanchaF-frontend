// Aquí defino cómo luce una "Cancha" en mi aplicación.
// Es decir, el modelo que voy a usar para intercambiar datos entre el frontend y el backend.

class Cancha {
  final int id;
  final String nombre;
  final String ubicacion;
  final bool disponible;

  // Constructor para crear una cancha
  Cancha({
    required this.id,
    required this.nombre,
    required this.ubicacion,
    required this.disponible,
  });

  // Método para convertir un JSON (del backend) en un objeto Cancha
  factory Cancha.fromJson(Map<String, dynamic> json) {
    return Cancha(
      id: json['id'],
      nombre: json['nombre'],
      ubicacion: json['ubicacion'],
      disponible: json['disponible'],
    );
  }

  // Método para convertir un objeto Cancha en JSON (para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'ubicacion': ubicacion,
      'disponible': disponible,
    };
  }
}
