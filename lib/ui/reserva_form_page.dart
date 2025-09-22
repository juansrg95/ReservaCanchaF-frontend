import 'package:flutter/material.dart';
import '../models/cancha.dart';

class ReservaFormPage extends StatefulWidget {
  final Cancha cancha;
  const ReservaFormPage({super.key, required this.cancha});

  @override
  State<ReservaFormPage> createState() => _ReservaFormPageState();
}

class _ReservaFormPageState extends State<ReservaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  DateTime? _fecha;
  TimeOfDay? _horaInicio;
  TimeOfDay? _horaFin;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFecha() async {
    final hoy = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 60)),
    );
    if (picked != null) setState(() => _fecha = picked);
  }

  Future<void> _pickHoraInicio() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked != null) setState(() => _horaInicio = picked);
  }

  Future<void> _pickHoraFin() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 19, minute: 0),
    );
    if (picked != null) setState(() => _horaFin = picked);
  }

  void _enviar() {
    if (!_formKey.currentState!.validate()) return;
    if (_fecha == null || _horaInicio == null || _horaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona fecha y horas')),
      );
      return;
    }

    if (_horaFin!.hour < _horaInicio!.hour ||
        (_horaFin!.hour == _horaInicio!.hour &&
            _horaFin!.minute <= _horaInicio!.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hora fin debe ser mayor a inicio')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmación'),
        content: Text(
          'Reserva solicitada para "${widget.cancha.nombre}"\n'
          'Usuario: ${_nombreCtrl.text}\n'
          'Fecha: ${_fecha!.day}/${_fecha!.month}/${_fecha!.year}\n'
          'Horario: ${_horaInicio!.format(context)} - ${_horaFin!.format(context)}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservar cancha')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Cancha: ${widget.cancha.nombre}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Tu nombre',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Ingresa tu nombre' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(_fecha == null
                  ? 'Seleccionar fecha'
                  : '${_fecha!.day}/${_fecha!.month}/${_fecha!.year}'),
              onTap: _pickFecha,
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(_horaInicio == null
                  ? 'Hora inicio'
                  : _horaInicio!.format(context)),
              onTap: _pickHoraInicio,
            ),
            ListTile(
              leading: const Icon(Icons.access_time_filled),
              title:
                  Text(_horaFin == null ? 'Hora fin' : _horaFin!.format(context)),
              onTap: _pickHoraFin,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _enviar,
              icon: const Icon(Icons.send),
              label: const Text('Solicitar reserva'),
            ),
          ],
        ),
      ),
    );
  }
}

