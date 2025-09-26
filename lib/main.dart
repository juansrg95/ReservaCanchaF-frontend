import 'package:flutter/material.dart';
import 'ui/shell_page.dart';
import 'ui/login_page.dart';
import 'ui/register_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reserva de Canchas',
      // IMPORTANTE: definimos /shell para que el login haga pushReplacementNamed('/shell')
      initialRoute: '/shell',
      routes: {
        '/shell': (_) => const ShellPage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
      },
      // si alguien navega a una ruta rara, lo mando al shell
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const ShellPage()),
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
    );
  }
}



