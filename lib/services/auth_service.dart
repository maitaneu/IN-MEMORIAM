import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import 'supabase_service.dart';

/// Servicio de autenticación usando Supabase Auth + tabla pública usuarios.
class AuthService {
  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;
  bool get estaLogueado => _usuarioActual != null;

  // ── Conversor fila → Usuario ──────────────────────────────────

  static Usuario rowToUsuario(Map<String, dynamic> row) {
    final rolStr = row['rol'] as String? ?? 'registrado';
    final rol = RolUsuario.values.firstWhere(
      (r) => r.name == rolStr,
      orElse: () => RolUsuario.registrado,
    );

    DatosTanatorio? datosTanatorio;
    if (rol == RolUsuario.tanatorio) {
      datosTanatorio = DatosTanatorio(
        razonSocial: row['razon_social'] as String? ?? '',
        cif: row['cif'] as String? ?? '',
        direccion: row['direccion'] as String? ?? '',
        telefono: row['telefono'] as String?,
        web: row['web'] as String?,
        descripcion: row['descripcion'] as String?,
        logoUrl: row['logo_url'] as String?,
        servicios: List<String>.from(row['servicios'] ?? []),
        latitud: (row['latitud'] as num?)?.toDouble(),
        longitud: (row['longitud'] as num?)?.toDouble(),
      );
    }

    DatosParticular? datosParticular;
    if (rol == RolUsuario.particular) {
      final pagoStr = row['estado_pago'] as String? ?? 'pendiente';
      datosParticular = DatosParticular(
        relacionFallecido: row['relacion_fallecido'] as String? ?? '',
        documentoIdentidad: row['documento_identidad'] as String?,
        estadoPago: EstadoPagoParticular.values.firstWhere(
          (e) => e.name == pagoStr,
          orElse: () => EstadoPagoParticular.pendiente,
        ),
      );
    }

    return Usuario(
      id: row['id'] as String,
      nombre: row['nombre'] as String,
      apellidos: row['apellidos'] as String,
      email: row['email'] as String,
      avatarUrl: row['avatar_url'] as String?,
      rol: rol,
      fechaRegistro: DateTime.parse(row['fecha_registro'] as String),
      localidad: row['localidad'] as String?,
      provincia: row['provincia'] as String?,
      datosTanatorio: datosTanatorio,
      datosParticular: datosParticular,
    );
  }

  // ── Helpers privados ──────────────────────────────────────────

  Future<Usuario?> cargarPerfil(String uid) async {
    final row = await SB.client
        .from('usuarios')
        .select()
        .eq('id', uid)
        .maybeSingle();
    if (row == null) return null;
    return rowToUsuario(row);
  }

  Future<void> _insertarPerfil(Map<String, dynamic> datos) async {
    await SB.client.from('usuarios').insert(datos);
  }

  // ── Auth público ──────────────────────────────────────────────

  Future<AuthResultado> login(String email, String password) async {
    try {
      final res = await SB.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (res.user == null) {
        return AuthResultado.error('No se pudo iniciar sesión.');
      }
      final usuario = await cargarPerfil(res.user!.id);
      if (usuario == null) {
        return AuthResultado.error('Perfil no encontrado.');
      }
      _usuarioActual = usuario;
      return AuthResultado.ok(usuario);
    } on AuthException catch (e) {
      return AuthResultado.error(_mensajeAuth(e.message));
    } catch (_) {
      return AuthResultado.error('Error inesperado. Inténtalo de nuevo.');
    }
  }

  Future<AuthResultado> registrar({
    required String nombre,
    required String apellidos,
    required String email,
    required String password,
    String? localidad,
    String? provincia,
  }) async {
    try {
      final res = await SB.client.auth.signUp(email: email, password: password);
      if (res.user == null) return AuthResultado.error('No se pudo crear la cuenta.');
      await _insertarPerfil({
        'id': res.user!.id,
        'nombre': nombre,
        'apellidos': apellidos,
        'email': email,
        'rol': 'registrado',
        'localidad': localidad,
        'provincia': provincia,
        'fecha_registro': DateTime.now().toIso8601String(),
      });
      final usuario = await cargarPerfil(res.user!.id);
      _usuarioActual = usuario;
      return AuthResultado.ok(usuario!);
    } on AuthException catch (e) {
      return AuthResultado.error(_mensajeAuth(e.message));
    } catch (_) {
      return AuthResultado.error('Error al crear la cuenta.');
    }
  }

  Future<AuthResultado> registrarParticular({
    required String nombre,
    required String apellidos,
    required String email,
    required String password,
    required String relacionFallecido,
    String? documentoIdentidad,
    String? localidad,
    String? provincia,
  }) async {
    try {
      final res = await SB.client.auth.signUp(email: email, password: password);
      if (res.user == null) return AuthResultado.error('No se pudo crear la cuenta.');
      await _insertarPerfil({
        'id': res.user!.id,
        'nombre': nombre,
        'apellidos': apellidos,
        'email': email,
        'rol': 'particular',
        'localidad': localidad,
        'provincia': provincia,
        'relacion_fallecido': relacionFallecido,
        'documento_identidad': documentoIdentidad,
        'estado_pago': 'pendiente',
        'fecha_registro': DateTime.now().toIso8601String(),
      });
      final usuario = await cargarPerfil(res.user!.id);
      _usuarioActual = usuario;
      return AuthResultado.ok(usuario!);
    } on AuthException catch (e) {
      return AuthResultado.error(_mensajeAuth(e.message));
    } catch (_) {
      return AuthResultado.error('Error al crear la cuenta.');
    }
  }

  Future<AuthResultado> registrarTanatorio({
    required String nombre,
    required String apellidos,
    required String email,
    required String password,
    required String razonSocial,
    required String cif,
    required String direccion,
    String? telefono,
    String? web,
    String? descripcion,
    String? localidad,
    String? provincia,
  }) async {
    try {
      final res = await SB.client.auth.signUp(email: email, password: password);
      if (res.user == null) return AuthResultado.error('No se pudo crear la cuenta.');
      await _insertarPerfil({
        'id': res.user!.id,
        'nombre': nombre,
        'apellidos': apellidos,
        'email': email,
        'rol': 'tanatorio',
        'localidad': localidad,
        'provincia': provincia,
        'razon_social': razonSocial,
        'cif': cif,
        'direccion': direccion,
        'telefono': telefono,
        'web': web,
        'descripcion': descripcion,
        'fecha_registro': DateTime.now().toIso8601String(),
      });
      final usuario = await cargarPerfil(res.user!.id);
      _usuarioActual = usuario;
      return AuthResultado.ok(usuario!);
    } on AuthException catch (e) {
      return AuthResultado.error(_mensajeAuth(e.message));
    } catch (_) {
      return AuthResultado.error('Error al crear la cuenta.');
    }
  }

  /// Restaura sesión activa al arrancar la app.
  Future<void> restaurarSesion() async {
    final session = SB.client.auth.currentSession;
    if (session != null) {
      _usuarioActual = await cargarPerfil(session.user.id);
    }
  }

  void logout() {
    SB.client.auth.signOut();
    _usuarioActual = null;
  }

  // ── Mensajes de error legibles ────────────────────────────────
  String _mensajeAuth(String msg) {
    if (msg.contains('Invalid login')) return 'Email o contraseña incorrectos.';
    if (msg.contains('Email not confirmed')) return 'Confirma tu email antes de entrar.';
    if (msg.contains('already registered')) return 'Ya existe una cuenta con ese email.';
    if (msg.contains('Password should be')) return 'La contraseña debe tener al menos 6 caracteres.';
    return msg;
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
