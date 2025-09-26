enum UserRole { admin, user }

UserRole roleFromString(String s) =>
    s.toLowerCase() == 'admin' ? UserRole.admin : UserRole.user;

class AppUser {
  final String username;
  final UserRole role;
  final String token; // si tu backend devuelve JWT o similar

  const AppUser({
    required this.username,
    required this.role,
    required this.token,
  });
}
