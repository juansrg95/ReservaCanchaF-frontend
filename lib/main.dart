import 'package:flutter/material.dart';
// Importo el paquete base de Flutter que me da acceso a todos los widgets de Material Design.

void main() {
  runApp(const ReservaCanchasApp());
  // Esta es la función principal del programa.
  // Aquí le digo a Flutter que ejecute mi aplicación "ReservaCanchasApp".
}

class ReservaCanchasApp extends StatelessWidget {
  const ReservaCanchasApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí defino la estructura general de mi app.
    return MaterialApp(
      title: 'Reserva de Canchas', // El título interno de mi aplicación.
      debugShowCheckedModeBanner: false, // Quito la cinta roja de "DEBUG".
      theme: ThemeData(
        // Defino el tema principal de la app.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        // Uso un color base (verde) porque está relacionado con las canchas de fútbol.
        useMaterial3: true, // Le indico que use la nueva versión de Material Design (M3).
      ),
      home: const HomePage(),
      // Indico que la primera pantalla al abrir la app será HomePage.
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  // HomePage es un StatefulWidget porque va a cambiar dinámicamente (con el contador).
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  // Creo una variable privada "_counter" que empieza en 0.
  // Esta me servirá para mostrar cuántas veces presioné el botón.

  void _increment() => setState(() => _counter++);
  // Defino una función "_increment" que aumenta el contador en 1.
  // setState le dice a Flutter: "oye, cambió algo, redibuja la pantalla".

  @override
  Widget build(BuildContext context) {
    // Aquí defino cómo se ve mi pantalla principal.
    return Scaffold(
      appBar: AppBar(title: const Text('Reserva de Canchas')),
      // Le pongo un AppBar con el título de mi aplicación.

      body: Center(
        // El contenido de la pantalla estará centrado.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // Coloco los widgets uno debajo de otro y centrados.
          children: [
            const Text('Has presionado el botón esta cantidad de veces:'),
            const SizedBox(height: 8), // Dejo un espacio vertical de 8 px.
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayMedium
              // Aquí muestro el valor del contador con estilo de texto grande.
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _increment, // Al presionar el botón llamo a _increment().
        child: const Icon(Icons.add), // Icono "+" dentro del botón flotante.
      ),
    );
  }
}

