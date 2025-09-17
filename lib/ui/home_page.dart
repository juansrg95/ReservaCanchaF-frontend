// lib/ui/home_page.dart
// Lista de canchas -> navega al detalle

import 'package:flutter/material.dart';

// IMPORTA tu modelo y el servicio:
import '../models/cancha.dart';
import '../services/cancha_service.dart';

// IMPORTA la pantalla de detalle (esto arregla tu error)
import 'cancha_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _service = CanchaService();
  late Future<List<Cancha>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getCanchas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canchas disponibles')),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _future = _service.getCanchas();
          });
          await _future;
        },
        child: FutureBuilder<List<Cancha>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ocurrió un error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _future = _service.getCanchas();
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final canchas = snapshot.data ?? [];
            if (canchas.isEmpty) {
              return const Center(child: Text('No hay canchas registradas'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: canchas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final c = canchas[i];
                final disponible = c.activa;
                final icono = disponible ? Icons.check_circle : Icons.cancel;
                final color = disponible ? Colors.green : Colors.red;

                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.15),
                      child: Icon(icono, color: color),
                    ),
                    title: Text(c.nombre),
                    subtitle: Text('Deporte: ${c.deporte} • Sede: ${c.sede.nombre}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CanchaDetailPage(cancha: c),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _future = _service.getCanchas();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}





