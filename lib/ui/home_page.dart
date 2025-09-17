// lib/ui/home_page.dart
// Pantalla principal donde muestro el listado de canchas.
// Ahora: 1) uso el objeto sede para mostrar su nombre,
//        2) puedo refrescar con pull-to-refresh,
//        3) navego a una pantalla de detalle al tocar una tarjeta.

import 'package:flutter/material.dart';
import '../models/cancha.dart';
import '../services/cancha_service.dart';
import 'cancha_detail_page.dart'; // ← para abrir el detalle

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Guardo mi servicio (donde hago los GET al backend)
  final _service = CanchaService();

  // Mantengo el Future para poder refrescarlo cuando quiera
  late Future<List<Cancha>> _future;

  @override
  void initState() {
    super.initState();
    // Apenas entro a la pantalla, disparo la carga de canchas
    _future = _service.getCanchas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canchas disponibles')),

      // Envolví el FutureBuilder con RefreshIndicator para hacer pull-to-refresh
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _future = _service.getCanchas();
          });
          await _future; // espero a que termine para que el indicador desaparezca
        },
        child: FutureBuilder<List<Cancha>>(
          future: _future,
          builder: (context, snapshot) {
            // 1) Mientras carga, muestro un spinner centrado
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2) Si vino un error, lo muestro con un botón para reintentar
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

            // 3) Si no hay datos, informo al usuario
            final canchas = snapshot.data ?? [];
            if (canchas.isEmpty) {
              return const Center(child: Text('No hay canchas registradas'));
            }

            // 4) Si todo bien, pinto la lista
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: canchas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final c = canchas[i];

                // Color e icono según disponibilidad (para dar feedback visual)
                final disponible = c.activa;
                final dispIcon = disponible ? Icons.check_circle : Icons.cancel;
                final dispColor = disponible ? Colors.green : Colors.red;

                return Card(
                  elevation: 2,
                  child: ListTile(
                    // Un avatar/icono más “bonito”
                    leading: CircleAvatar(
                      backgroundColor: dispColor.withOpacity(40),
                      child: Icon(dispIcon, color: dispColor),
                    ),

                    // Nombre de la cancha
                    title: Text(c.nombre),

                    // Aquí uso el objeto 'sede' que trae el backend para mostrar su nombre
                    subtitle: Text('Deporte: ${c.deporte} • Sede: ${c.sede.nombre}'),

                    trailing: const Icon(Icons.chevron_right),

                    // Al tocar, navego al detalle
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

      // Botón para refrescar manualmente (además del pull-to-refresh)
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


