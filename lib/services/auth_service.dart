import 'dart:convert';
import '../core/api_client.dart';
import '../core/session.dart';

class AuthService {
  /// Intenta loguear con Basic Auth. Devuelve true si la credencial funciona.
  Future<bool> login({
    required String email,
    required String password,
    required bool isAdmin,
  }) async {
    final basic = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';

    // seteo provisional para probar
    Session.basicAuth = basic;
    Session.isAdmin   = isAdmin;

    // validamos pegándole a un endpoint protegido
    final r = await ApiClient.get('/api/reservas');
    if (r.statusCode == 200) {
      return true;
    }

    // si falla, limpiamos sesión y devolvemos false
    Session.clear();
    return false;
  }

  /// Registro de usuario (ajusta el endpoint si el tuyo es distinto)
  Future<bool> registrar({
    required String nombre,
    required String email,
    required String password,
    required String rol, // 'user' o 'admin'
  }) async {
    final res = await ApiClient.post('/api/usuarios', {
      'nombre': nombre,
      'email': email,
      'password': password,
      'rol': rol.toUpperCase(), // si tu backend espera ADMIN/USER
    });
    return res.statusCode == 200 || res.statusCode == 201;
  }
}






