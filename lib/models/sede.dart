class Sede {
  final int id;
  final String nombre;

  Sede({required this.id, required this.nombre});

  factory Sede.fromJson(Map<String, dynamic> j) =>
      Sede(id: j['id'] as int, nombre: j['nombre'] as String? ?? 'Sede');

  Map<String, dynamic> toJson() => {'id': id, 'nombre': nombre};
}



