class Sede {
  final int id;
  final String nombre;
  final String direccion;

  Sede({required this.id, required this.nombre, required this.direccion});

  factory Sede.fromJson(Map<String, dynamic> j) =>
      Sede(id: j['id'], nombre: j['nombre'], direccion: j['direccion']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'direccion': direccion,
      };
}

class Cancha {
  final int id;
  final String nombre;
  final String deporte;
  final bool activa;
  final Sede sede;

  Cancha({
    required this.id,
    required this.nombre,
    required this.deporte,
    required this.activa,
    required this.sede,
  });

  factory Cancha.fromJson(Map<String, dynamic> j) => Cancha(
        id: j['id'],
        nombre: j['nombre'],
        deporte: j['deporte'],
        activa: j['activa'] == true,
        sede: Sede.fromJson(j['sede']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'deporte': deporte,
        'activa': activa,
        'sede': sede.toJson(),
      };
}




