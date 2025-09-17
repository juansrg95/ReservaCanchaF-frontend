class Reserva {
  final int id;
  final int canchaId;
  final String usuario;
  final DateTime inicio;
  final DateTime fin;
  final String estado;

  Reserva({
    required this.id,
    required this.canchaId,
    required this.usuario,
    required this.inicio,
    required this.fin,
    required this.estado,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'],
      canchaId: json['cancha_id'],
      usuario: json['usuario'],
      inicio: DateTime.parse(json['inicio']),
      fin: DateTime.parse(json['fin']),
      estado: json['estado'],
    );
  }
}
