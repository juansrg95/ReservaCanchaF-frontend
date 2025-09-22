import 'package:flutter/material.dart';
import 'ui/home_page.dart';

/// Punto de entrada de mi app.
void main() {
  runApp(const ReservaCanchasApp());
}

/// Configuración general de temas y ruta inicial.
class ReservaCanchasApp extends StatelessWidget {
  const ReservaCanchasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de Canchas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

