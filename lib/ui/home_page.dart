import 'package:flutter/material.dart';
import '../core/session.dart';
import '../models/cancha.dart';
import '../services/cancha_service.dart';
import 'canchas_list.dart';
import 'reservas_page.dart';
import 'register_page.dart';
import 'login_page.dart';
import '../widgets/cancha_card.dart';


class HomePage extends StatelessWidget {
  final void Function(int index)? onJumpToTab;
  const HomePage({super.key, this.onJumpToTab});

  void _go(BuildContext ctx, int tab, Widget page) {
    if (onJumpToTab != null) {
      onJumpToTab!(tab);
    } else {
      Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => page));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Session.isAdmin;

    return Scaffold(
      appBar: AppBar(title: Text('Reserva de Canchas – ${isAdmin ? 'admin' : 'user'}')),
      body: ListView(
        children: [
          // Banner futbolero
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/canchas/cancha_norte.jpg', fit: BoxFit.cover),
                Container(color: Colors.black26),
                const Center(
                  child: Text(
                    'Reserva tu cancha fácil y rápido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Acceso rápido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 14, runSpacing: 14,
              children: [
                _HomeTile(
                  icon: Icons.stadium, title: 'Listado de canchas',
                  onTap: () => _go(context, 1, const CanchasListPage()),
                ),
                _HomeTile(
                  icon: Icons.calendar_month, title: 'Calendario / Reservas',
                  onTap: () => _go(context, 2, const ReservasPage()),
                ),
                _HomeTile(
                  icon: Icons.person, title: 'Perfil / Crear usuario',
                  onTap: () => _go(context, 3, const RegisterPage()),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Login / Registro si no hay sesión
          if (Session.basicAuth == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 12, runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.lock_open, size: 28),
                      const Text('¿Tienes cuenta?', style: TextStyle(fontWeight: FontWeight.w700)),
                      FilledButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginPage())),
                        child: const Text('Iniciar sesión'),
                      ),
                      OutlinedButton(
                        onPressed: () => _go(context, 3, const RegisterPage()),
                        child: const Text('Crear usuario'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (Session.isAdmin)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Card(
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 12, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center,
                    children: const [
                      Icon(Icons.admin_panel_settings, size: 28),
                      Text('Acciones de administrador (cancha/sede) disponibles en menú Canchas.',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Canchas disponibles (cards)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: FutureBuilder<List<Cancha>>(
              future: CanchaService().activas(),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snap.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text('Error cargando canchas: ${snap.error}', style: const TextStyle(color: Colors.red)),
                  );
                }
                final data = snap.data ?? const <Cancha>[];
                if (data.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text('No hay canchas activas por ahora.'),
                  );
                }
                // grid responsivo
                return LayoutBuilder(
                  builder: (ctx, c) {
                    final cols = c.maxWidth > 1200 ? 3 : (c.maxWidth > 800 ? 2 : 1);
                    return GridView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 16 / 12,
                      ),
                      itemBuilder: (_, i) => CanchaCard(cancha: data[i]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap;
  const _HomeTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 260, padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 28, color: Colors.green.shade700),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

















