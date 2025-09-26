// lib/ui/canchas_list.dart
import 'package:flutter/material.dart';

import '../core/session.dart';
import '../models/cancha.dart' as cmodel;
import '../services/cancha_service.dart';
import 'cancha_detail_page.dart';

class CanchasListPage extends StatefulWidget {
  const CanchasListPage({super.key});

  @override
  State<CanchasListPage> createState() => _CanchasListPageState();
}

class _CanchasListPageState extends State<CanchasListPage> {
  final _svc = CanchaService();

  Future<void> _eliminar(cmodel.Cancha c) async {
    try {
      await _svc.eliminar(c.id!.toInt());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cancha eliminada')),
        );
        setState(() {}); // refrescar
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo eliminar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<cmodel.Cancha>>(
        future: _svc.activas(),
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text('Error: ${snap.error}', style: const TextStyle(color: Colors.red)),
            );
          }
          final items = snap.data ?? const <cmodel.Cancha>[];

          if (items.isEmpty) {
            return const Center(child: Text('No hay canchas activas'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final c = items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.nombre ?? 'Cancha ${c.id}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text('Deporte: ${c.deporte ?? '-'}'),
                      const SizedBox(height: 4),
                      Text('Sede: ${c.sede?.nombre ?? '-'}'),
                      const SizedBox(height: 4),
                      Text('Dirección: ${c.sede?.direccion ?? '-'}'),
                      const SizedBox(height: 10),
                      if (Session.isAdmin)
                        Row(
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text('Editar'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CanchaDetailPage(cancha: c),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.delete, size: 18),
                              label: const Text('Eliminar'),
                              onPressed: () => _eliminar(c),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Session.isAdmin
          ? FloatingActionButton(
              tooltip: 'Nueva cancha',
              onPressed: () {
                // Objeto "vacío" para el formulario de detalle
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CanchaDetailPage(
                      cancha: cmodel.Cancha(
                        id: 0,                // 0 => nueva
                        activa: true,
                        nombre: '',
                        deporte: '',
                        sede: cmodel.Sede(
                          id: 0,
                          nombre: '',
                          direccion: '', // <- obligatorio en tu modelo
                        ),
                      ),
                    ),
                  ),
                ).then((_) => setState(() {}));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}












