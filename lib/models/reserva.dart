class Reserva {
  final int? id;
  final int? canchaId;
  final String? canchaNombre;
  final String? usuario;
  final DateTime? inicio;
  final DateTime? fin;
  final String? estado;

  const Reserva({
    this.id,
    this.canchaId,
    this.canchaNombre,
    this.usuario,
    this.inicio,
    this.fin,
    this.estado,
  });

  factory Reserva.fromJson(Map<String, dynamic> j) => Reserva(
        id: (j['id'] as num?)?.toInt(),
        canchaId: (j['canchaId'] as num?)?.toInt(),
        canchaNombre: j['canchaNombre'] as String?,
        usuario: j['usuario'] as String?,
        inicio: j['inicio'] != null ? DateTime.parse(j['inicio']) : null,
        fin: j['fin'] != null ? DateTime.parse(j['fin']) : null,
        estado: j['estado'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'canchaId': canchaId,
        'canchaNombre': canchaNombre,
        'usuario': usuario,
        'inicio': inicio?.toIso8601String(),
        'fin': fin?.toIso8601String(),
        'estado': estado,
      };
}




