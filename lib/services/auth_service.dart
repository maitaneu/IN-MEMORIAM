import '../models/models.dart';
import 'mock_data.dart';

enum AuthEstado { desconocido, autenticado, noAutenticado }

/// Simula autenticación local. Sin backend real.
class AuthService {
  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;
  bool get estaLogueado => _usuarioActual != null;

  /// Login con email y contraseña (mock: cualquier email de la lista con pass '1234' funciona).
  Future<AuthResultado> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (password != '1234') {
      return AuthResultado.error('Contraseña incorrecta. (Demo: usa "1234")');
    }

    final usuario = MockData.usuarios.where((u) => u.email == email).firstOrNull;
    if (usuario == null) {
      return AuthResultado.error('No existe ninguna cuenta con ese email.');
    }

    _usuarioActual = usuario;
    return AuthResultado.ok(usuario);
  }

  /// Registro de nuevo usuario (mock: lo añade a la lista en memoria).
  Future<AuthResultado> registrar({
    required String nombre,
    required String apellidos,
    required String email,
    required String password,
    String? localidad,
    String? provincia,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final existe = MockData.usuarios.any((u) => u.email == email);
    if (existe) {
      return AuthResultado.error('Ya existe una cuenta con ese email.');
    }

    final nuevo = Usuario(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      nombre: nombre,
      apellidos: apellidos,
      email: email,
      rol: RolUsuario.registrado,
      fechaRegistro: DateTime.now(),
      localidad: localidad,
      provincia: provincia,
    );
    MockData.usuarios.add(nuevo);
    _usuarioActual = nuevo;
    return AuthResultado.ok(nuevo);
  }

  void logout() {
    _usuarioActual = null;
  }
}

class AuthResultado {
  final bool exito;
  final Usuario? usuario;
  final String? mensajeError;

  const AuthResultado._({required this.exito, this.usuario, this.mensajeError});

  factory AuthResultado.ok(Usuario usuario) =>
      AuthResultado._(exito: true, usuario: usuario);

  factory AuthResultado.error(String mensaje) =>
      AuthResultado._(exito: false, mensajeError: mensaje);
}
