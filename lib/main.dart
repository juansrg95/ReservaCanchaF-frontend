import 'package:flutter/material.dart';
import 'ui/home_page.dart'; // Traigo la pantalla inicial desde /ui

void main() {
  runApp(const ReservaCanchasApp()); // Punto de entrada: arranco mi app
}

class ReservaCanchasApp extends StatelessWidget {
  const ReservaCanchasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de Canchas',
      debugShowCheckedModeBanner: false, // saco la cinta DEBUG
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), // verde = canchas
        useMaterial3: true, // Material Design 3
      ),
      home: const HomePage(), // pantalla inicial
    );
  }
}

