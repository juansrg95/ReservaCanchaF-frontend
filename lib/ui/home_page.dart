import 'package:flutter/material.dart';

/// HomePage: primera pantalla de la app.
/// La dejo como StatefulWidget porque tiene estado (contador de ejemplo).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0; // estado local de ejemplo

  void _increment() => setState(() => _counter++); // actualizo estado y redibujo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reserva de Canchas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Has presionado el botón esta cantidad de veces:'),
            const SizedBox(height: 8),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayMedium, // tipografía grande
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment, // sumo 1 al contador
        child: const Icon(Icons.add),
      ),
    );
  }
}

