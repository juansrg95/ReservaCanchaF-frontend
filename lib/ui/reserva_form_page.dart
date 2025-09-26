// lib/ui/reserva_form_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';

import '../core/api_client.dart';
import '../core/session.dart';
import '../models/cancha.dart';
import '../services/cancha_service.dart';
import '../services/reservas_service.dart';

class ReservaFormPage extends StatefulWidget {
  final Cancha? cancha;
  final int? reservaId; // si viene -> editar

  const ReservaFormPage({super.key, this.cancha, this.reservaId});

  @override
  State<ReservaFormPage> createState() => _ReservaFormPageState();
}

class _ReservaFormPageState extends State<ReservaFormPage> {
  final _api = ApiClient();
  final _svcReservas = ReservasService();
  final _svcCanchas = CanchaService();

  int? _canchaId;
  DateTime? _inicio;
  DateTime? _fin;

  List<Map<String, String>> _slots = [];

  @override
  void initState() {
    super.initState();
    _canchaId = widget.cancha?.id?.toInt();
    final now = DateTime.now();
    _inicio = DateTime(now.year, now.month, now.day, now.hour);
    _fin = _inicio!.add(const Duration(hours: 1));
  }

  Future<void> _pickInicio() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _inicio ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d == null) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_inicio!));
    if (t == null) return;
    setState(() {
      _inicio = DateTime(d.year, d.month, d.day, t.hour, t.minute);
      if (_fin != null && !_fin!.isAfter(_inicio!)) {
        _fin = _inicio!.add(const Duration(hours: 1));
      }
    });
  }

  Future<void> _pickFin() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _fin ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d == null) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_fin!));
    if (t == null) return;
    setState(() {
      _fin = DateTime(d.year, d.month, d.day, t.hour, t.minute);
      if (_inicio != null && !_fin!.isAfter(_inicio!)) {
        _inicio = _fin!.subtract(const Duration(hours: 1));
      }
    });
  }

  Future<void> _verDisponibilidad() async {
    // Guardia: requiere login
    if (Session.authHeader == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes iniciar sesión para ver disponibilidad')),
        );
      }
      return;
    }
    if (_canchaId == null || _inicio == null || _fin == null) return;

    final r = await _api.get(
      '/api/disponibilidad',
      query: {
        'canchaId': _canchaId!.toString(),
        'from': _inicio!.toIso8601String(),
        'to': _fin!.toIso8601String(),
        'slotMin': '60',
      },
    );

    if (r.statusCode == 200) {
      final data = jsonDecode(r.body) as List;
      _slots = data.map<Map<String, String>>((e) {
        final m = e as Map<String, dynamic>;
        return {
          'from': m['from']?.toString() ?? '',
          'to': m['to']?.toString() ?? '',
        };
      }).toList();
      if (mounted) setState(() {});
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error consultando disponibilidad: ${r.statusCode}')),
        );
      }
    }
  }

  Future<void> _guardar() async {
    if (_canchaId == null || _inicio == null || _fin == null) return;

    try {
      if (widget.reservaId == null) {
        await _svcReservas.crear(
          canchaId: _canchaId!,
          inicio: _inicio!,
          fin: _fin!,
        );
      } else {
        await _svcReservas.actualizar(
          id: widget.reservaId!,
          canchaId: _canchaId!,
          inicio: _inicio!,
          fin: _fin!,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva guardada')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar la reserva: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.reservaId == null ? 'Nueva reserva' : 'Editar reserva')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Selección de cancha
          FutureBuilder<List<Cancha>>(
            future: _svcCanchas.activas(),
            builder: (_, snap) {
              final items = snap.data ?? const <Cancha>[];
              return DropdownButtonFormField<int>(
                value: _canchaId,
                decoration: const InputDecoration(labelText: 'Cancha'),
                items: items
                    .map(
                      (c) => DropdownMenuItem<int>(
                        value: c.id?.toInt(),
                        child: Text(c.nombre ?? 'Cancha ${c.id}'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _canchaId = v),
              );
            },
          ),
          const SizedBox(height: 16),

          // Inicio / Fin
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Inicio'),
                  subtitle: Text(_inicio?.toIso8601String() ?? ''),
                  trailing: const Icon(Icons.access_time),
                  onTap: _pickInicio,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fin'),
                  subtitle: Text(_fin?.toIso8601String() ?? ''),
                  trailing: const Icon(Icons.access_time),
                  onTap: _pickFin,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Acciones
          Row(
            children: [
              FilledButton.icon(
                onPressed: _verDisponibilidad,
                icon: const Icon(Icons.search),
                label: const Text('Ver disponibilidad'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Slots
          const Text('Slots disponibles:'),
          const SizedBox(height: 8),
          ..._slots.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Chip(label: Text('${s['from']} → ${s['to']}')),
            ),
          ),
        ],
      ),
    );
  }
}













