// lib/ui/reservas_page.dart
import 'package:flutter/material.dart';
import '../core/session.dart';
import '../models/reserva.dart';
import '../services/reservas_service.dart';
import 'reserva_form_page.dart';

class ReservasPage extends StatefulWidget {
  const ReservasPage({super.key});

  @override
  State<ReservasPage> createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage> {
  final _svc = ReservasService();

  @override
  Widget build(BuildContext context) {
    // Guarda: si no hay login, no peguemos al backend
    if (Session.authHeader == null) {
      return const Center(
        child: Text('Inicia sesión para ver y gestionar tus reservas'),
      );
    }

    return Scaffold(
      body: FutureBuilder<List<Reserva>>(
        future: _svc.listar(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text(
                'Error: ${snap.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final items = snap.data ?? const [];
          if (items.isEmpty) {
            return const Center(child: Text('No tienes reservas'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final r = items[i];
              return ListTile(
                tileColor: Colors.green.shade50.withOpacity(.35),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                title: Text('Reserva #${r.id ?? '-'}'),
                subtitle: Text('${r.inicio} → ${r.fin} · ${r.estado ?? ''}'),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Editar',
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReservaFormPage(reservaId: r.id),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                    IconButton(
                      tooltip: 'Cancelar',
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        try {
                          await _svc.cancelar(r.id!.toInt());
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reserva cancelada')),
                            );
                            setState(() {});
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No se pudo cancelar: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      // FAB para crear NUEVA reserva
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nueva reserva',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReservaFormPage()),
          ).then((_) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}














