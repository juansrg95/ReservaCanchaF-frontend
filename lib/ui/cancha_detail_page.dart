// lib/ui/reserva_form_page.dart
// Formulario simple para registrar una reserva.
// Ahora mismo es un mock (demo), más adelante podemos conectarlo al backend.

// lib/ui/cancha_detail_page.dart
import 'package:flutter/material.dart';
import '../models/cancha.dart';

// IMPORTA el formulario de reserva
import 'reserva_form_page.dart';

class CanchaDetailPage extends StatelessWidget {
  final Cancha cancha;
  const CanchaDetailPage({super.key, required this.cancha});

  @override
  Widget build(BuildContext context) {
    // Intentamos mapear nombre -> imagen (usa snake_case)
    String imgName = cancha.nombre.toLowerCase().replaceAll(' ', '_');
    final posibleRutas = [
      'assets/canchas/$imgName.jpg',
      'assets/canchas/$imgName.jpeg',
      'assets/canchas/$imgName.png',
    ];

    return Scaffold(
      appBar: AppBar(title: Text(cancha.nombre)),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          // Header con imagen (si falla, muestra icono)
          SizedBox(
            height: 220,
            child: _HeaderImagen(rutas: posibleRutas),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  icon: Icons.sports_soccer,
                  label: 'Deporte',
                  value: cancha.deporte,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: cancha.activa ? Icons.check_circle : Icons.cancel,
                  label: 'Estado',
                  value: cancha.activa ? 'Activa' : 'Inactiva',
                  valueColor: cancha.activa ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                const Text('Sede',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.apartment,
                  label: 'Nombre',
                  value: cancha.sede.nombre,
                ),
                _InfoRow(
                  icon: Icons.pin,
                  label: 'Sede ID',
                  value: '${cancha.sede.id}',
                ),
                _InfoRow(
                  icon: Icons.location_on,
                  label: 'Dirección',
                  value: cancha.sede.direccion,
                ),
              ],
            ),
          ),
        ],
      ),

      // BOTÓN para abrir formulario de reserva
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReservaFormPage(cancha: cancha),
            ),
          );
        },
        icon: const Icon(Icons.calendar_month),
        label: const Text('Reservar'),
      ),
    );
  }
}

class _HeaderImagen extends StatelessWidget {
  final List<String> rutas;
  const _HeaderImagen({required this.rutas});

  @override
  Widget build(BuildContext context) {
    // probamos las rutas hasta que una funcione (simple)
    return Image.asset(
      rutas.first,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        // si falla la primera, probamos la segunda, etc.
        for (int i = 1; i < rutas.length; i++) {
          return Image.asset(
            rutas[i],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.image_not_supported, size: 80),
            ),
          );
        }
        return const Center(
          child: Icon(Icons.image_not_supported, size: 80),
        );
      },
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(color: valueColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



