/// Sesión simple para cliente web.
class Session {
  /// ¿El usuario actual es ADMIN?
  static bool isAdmin = false;

  /// Usuario (email/login) para enviar al backend en reservas.
  static String? username;

  /// Credencial en base64 "user:pass" (sin el prefijo "Basic ").
  static String? basicAuth;

  /// Header Authorization listo para usar.
  static String? get authHeader => (basicAuth != null) ? 'Basic $basicAuth' : null;

  /// Headers por defecto (solo Authorization).
  static Map<String, String> get defaultHeaders =>
      authHeader != null ? {'Authorization': authHeader!} : {};

  /// Limpia cualquier rastro de sesión.
  static void clear() {
    basicAuth = null;
    username  = null;
    isAdmin   = false;
  }
}






