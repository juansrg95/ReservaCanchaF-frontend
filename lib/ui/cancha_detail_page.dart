// lib/ui/cancha_detail_page.dart
// Pantalla de detalle de una cancha. Compatible con el modelo nuevo (sede como objeto).

import 'package:flutter/material.dart';
import '../models/cancha.dart';

class CanchaDetailPage extends StatelessWidget {
  final Cancha cancha;

  const CanchaDetailPage({super.key, required this.cancha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cancha.nombre)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoRow(
            icon: Icons.sports_soccer,
            label: 'Deporte',
            value: cancha.deporte,
          ),
          _InfoRow(
            icon: cancha.activa ? Icons.check_circle : Icons.cancel,
            label: 'Estado',
            value: cancha.activa ? 'Activa' : 'Inactiva',
            valueColor: cancha.activa ? Colors.green : Colors.red,
          ),
          const Divider(height: 24),
          Text('Sede', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.apartment,
            label: 'Nombre',
            value: cancha.sede.nombre, // <- usamos el objeto sede
          ),
          _InfoRow(
            icon: Icons.location_city,
            label: 'Sede ID',
            value: '${cancha.sede.id}', // <- si necesitas el id, sale de sede.id
          ),
          _InfoRow(
            icon: Icons.place,
            label: 'Dirección',
            value: cancha.sede.direccion,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label, style: Theme.of(context).textTheme.bodySmall),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: valueColor,
            ),
      ),
    );
  }
}
