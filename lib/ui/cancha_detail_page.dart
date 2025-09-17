
// lib/ui/cancha_detail_page.dart
 // Pantalla de detalle de la cancha: hero image, info y botón "Reservar".

 import 'package:flutter/material.dart';
 import '../models/cancha.dart';

 class CanchaDetailPage extends StatelessWidget {
   const CanchaDetailPage({super.key, required this.cancha});

   final Cancha cancha;

   String _imagenDeporte() {
     final d = cancha.deporte.toLowerCase();
     if (d.contains('fut') || d.contains('fútbol') || d.contains('futbol')) {
       return 'assets/canchas/cancha_norte.jpg'; // usa la que prefieras como genérica
     }
     // puedes añadir mapeos a otros deportes si luego los tienen
     return 'assets/canchas/cancha_norte.jpg';
   }

   @override
   Widget build(BuildContext context) {
     final imgPath = _imagenDeporte();

     return Scaffold(
       appBar: AppBar(
         title: Text(cancha.nombre),
       ),
       body: ListView(
         children: [
           // Imagen superior (hero)
           AspectRatio(
             aspectRatio: 16 / 6,
             child: Image.asset(
               imgPath,
               fit: BoxFit.cover,
             ),
           ),

           const SizedBox(height: 12),

           // Info general
           Card(
             margin: const EdgeInsets.symmetric(horizontal: 16),
             child: Padding(
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
                     icon: Icons.verified,
                     label: 'Estado',
                     value: cancha.activa ? 'Activa' : 'Inactiva',
                     valueColor: cancha.activa ? Colors.green : Colors.red,
                   ),
                 ],
               ),
             ),
           ),

           const SizedBox(height: 12),

           // Info sede
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16),
             child: Text('Sede', style: Theme.of(context).textTheme.titleMedium),
           ),
           Card(
             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 children: [
                   _InfoRow(
                     icon: Icons.apartment,
                     label: 'Nombre',
                     value: cancha.sede.nombre,
                   ),
                   const SizedBox(height: 8),
                   _InfoRow(
                     icon: Icons.confirmation_number,
                     label: 'Sede ID',
                     value: '${cancha.sede.id}',
                   ),
                   const SizedBox(height: 8),
                   _InfoRow(
                     icon: Icons.location_on,
                     label: 'Dirección',
                     value: cancha.sede.direccion,
                   ),
                 ],
               ),
             ),
           ),

           const SizedBox(height: 100),
         ],
       ),

       // Botón de acción (reservar)
       floatingActionButton: FloatingActionButton.extended(
         onPressed: () {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Aquí irá el formulario de reserva ')),
           );
           // Aquí luego navegaremos a ReserveFormPage(...)
         },
         icon: const Icon(Icons.event_available),
         label: const Text('Reservar'),
       ),
       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
     );
   }
 }

 class _InfoRow extends StatelessWidget {
   const _InfoRow({
     required this.icon,
     required this.label,
     required this.value,
     this.valueColor,
   });

   final IconData icon;
   final String label;
   final String value;
   final Color? valueColor;

   @override
   Widget build(BuildContext context) {
     final styleLabel = Theme.of(context).textTheme.bodyMedium;
     final styleValue = Theme.of(context).textTheme.bodyMedium?.copyWith(
           fontWeight: FontWeight.w600,
           color: valueColor,
         );
     return Row(
       children: [
         Icon(icon, size: 18),
         const SizedBox(width: 8),
         Text('$label: ', style: styleLabel),
         Expanded(child: Text(value, style: styleValue)),
       ],
     );
   }
 }




