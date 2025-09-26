import 'package:flutter/material.dart';
import '../models/cancha.dart';

class CanchaDetailPage extends StatelessWidget {
  final Cancha cancha;
  const CanchaDetailPage({required this.cancha, super.key});

  String _assetForCancha() {
    final n = cancha.nombre.toLowerCase();
    if (n.contains('norte')) return 'assets/canchas/cancha_norte.jpg';
    if (n.contains('techada')) return 'assets/canchas/cancha_techada.jpg';
    return 'assets/canchas/cancha_sur.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final asset = _assetForCancha();
    return Scaffold(
      appBar: AppBar(title: Text(cancha.nombre)),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(asset, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cancha.nombre,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Deporte: ${cancha.deporte}'),
                const SizedBox(height: 8),
                Text('Sede: ${cancha.sede.nombre}'),
                const SizedBox(height: 4),
                Text('Dirección: ${cancha.sede.direccion}'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Chip(
                      label: Text(cancha.activa ? 'ACTIVA' : 'INACTIVA'),
                      backgroundColor:
                          cancha.activa ? Colors.green.shade100 : Colors.red.shade100,
                      side: BorderSide.none,
                      labelStyle: TextStyle(
                        color: cancha.activa ? Colors.green.shade900 : Colors.red.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}









