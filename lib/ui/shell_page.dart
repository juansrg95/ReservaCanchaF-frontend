import 'package:flutter/material.dart';
import '../core/session.dart';
import 'home_page.dart';
import 'canchas_list.dart';
import 'reservas_page.dart';
import 'register_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});
  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;
  void _jumpTo(int i) => setState(() => _index = i);

  List<Widget> get _pages => [
        HomePage(onJumpToTab: _jumpTo),
        const CanchasListPage(),
        const ReservasPage(),
        const RegisterPage(),
      ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final wide = c.maxWidth >= 980; // sidebar estilo desktop
        if (wide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Icon(Icons.sports_soccer, size: 32, color: Colors.green.shade700),
                  ),
                  trailing: Session.basicAuth != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: IconButton(
                            tooltip: 'Cerrar sesión',
                            onPressed: () {
                              Session.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sesión cerrada')),
                              );
                              setState(() {});
                            },
                            icon: const Icon(Icons.logout),
                          ),
                        )
                      : null,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(
                      icon: Icon(Icons.stadium_outlined), selectedIcon: Icon(Icons.stadium), label: Text('Canchas')),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: Text('Reservas')),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Perfil')),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: _pages[_index]),
              ],
            ),
          );
        }
        // móvil
        return Scaffold(
          body: IndexedStack(index: _index, children: _pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
              NavigationDestination(icon: Icon(Icons.stadium), label: 'Canchas'),
              NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Reservas'),
              NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
            ],
          ),
          floatingActionButton: Session.basicAuth != null
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Session.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sesión cerrada')),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Salir'),
                )
              : null,
        );
      },
    );
  }
}
