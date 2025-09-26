import 'package:flutter/material.dart';
import '../../models/cancha.dart';
import '../../core/session.dart';

String assetForCancha(String nombre) {
  final n = nombre.toLowerCase();
  if (n.contains('tech')) return 'assets/canchas/cancha_techada.jpg';
  if (n.contains('sur'))  return 'assets/canchas/cancha_sur.jpg';
  return 'assets/canchas/cancha_norte.jpg';
}

class CanchaCard extends StatelessWidget {
  final Cancha cancha;
  final VoidCallback? onEliminar;
  final VoidCallback? onEditar;
  const CanchaCard({super.key, required this.cancha, this.onEliminar, this.onEditar});

  @override
  Widget build(BuildContext context) {
    final dir = cancha.sede?.direccion ?? cancha.sede?.nombre ?? '-';
    final isAdmin = Session.isAdmin;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: onEditar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto grande
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                assetForCancha(cancha.nombre),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.sports_soccer, color: Colors.black54),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cancha.nombre,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text('Deporte: ${cancha.deporte} · Sede: $dir',
                            style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (cancha.activa == true) ? Colors.green.shade100 : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(cancha.activa == true ? 'ACTIVA' : 'INACTIVA'),
                  ),
                ],
              ),
            ),
            if (isAdmin) Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: onEditar,
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: onEliminar,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Eliminar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


