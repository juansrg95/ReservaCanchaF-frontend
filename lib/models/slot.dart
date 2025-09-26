class Slot {
  final DateTime inicio;
  final DateTime fin;

  Slot({required this.inicio, required this.fin});

  factory Slot.fromJson(Map<String, dynamic> j) =>
      Slot(inicio: DateTime.parse(j['inicio']), fin: DateTime.parse(j['fin']));
}
