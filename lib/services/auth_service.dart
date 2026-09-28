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
    try {
      final row = await SB.client
          .from('usuarios')
          .select()
          .eq('id', uid)
          .maybeSingle();
      if (row == null) return null;
      return rowToUsuario(row);
    } catch (_) {
      return null;
    }
  }

  Future<void> _insertarPerfil(Map<String, dynamic> datos) async {
    await SB.client.rpc('crear_perfil_usuario', params: datos);
  }

  /// Construye un Usuario directamente sin releer la BD (para uso post-registro).
  Usuario _construirUsuario({
    required String id,
    required String nombre,
    required String apellidos,
    required String email,
    required RolUsuario rol,
    String? localidad,
    String? provincia,
    DatosTanatorio? datosTanatorio,
    DatosParticular? datosParticular,
  }) {
    return Usuario(
      id: id,
      nombre: nombre,
      apellidos: apellidos,
      email: email,
      rol: rol,
      fechaRegistro: DateTime.now(),
      localidad: localidad,
      provincia: provincia,
      datosTanatorio: datosTanatorio,
      datosParticular: datosParticular,
    );
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
        'p_id': res.user!.id,
        'p_nombre': nombre,
        'p_apellidos': apellidos,
        'p_email': email,
        'p_rol': 'registrado',
        'p_localidad': localidad,
        'p_provincia': provincia,
      });
      final usuario = _construirUsuario(
        id: res.user!.id,
        nombre: nombre,
        apellidos: apellidos,
        email: email,
        rol: RolUsuario.registrado,
        localidad: localidad,
        provincia: provincia,
      );
      _usuarioActual = usuario;
      return AuthResultado.ok(usuario);
    } on AuthException catch (e) {
      return AuthResultado.error(_mensajeAuth(e.message));
    } catch (e) {
      return AuthResultado.error('Error al crear la cuenta: $e');
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
        'p_id': res.user!.id,
        'p_nombre': nombre,
        'p_apellidos': apellidos,
        'p_email': email,
        'p_rol': 'particular',
        'p_localidad': localidad,
        'p_provincia': provincia,
        'p_relacion_fallecido': relacionFallecido,
        'p_documento_identidad': documentoIdentidad,
        'p_estado_pago': 'pendiente',
      });
      final usuario = _construirUsuario(
        id: res.user!.id,
        nombre: nombre,
        apellidos: apellidos,
        email: email,
        rol: RolUsuario.particular,
        localidad: localidad,
        provincia: provincia,
        datosParticular: DatosParticular(
          relacionFallecido: relacionFallecido,
          documentoIdentidad: documentoIdentidad,
          estadoPago: EstadoPagoParticular.pendiente,
        ),
      );
      _usuarioActual = usuario;
      return AuthResultado.ok(usuario);
    } on AuthException catch (e) {
      return AuthResultado.error(_mensajeAuth(e.message));
    } catch (e) {
      return AuthResultado.error('Error al crear la cuenta: $e');
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
        'p_id': res.user!.id,
        'p_nombre': nombre,
        'p_apellidos': apellidos,
        'p_email': email,
        'p_rol': 'tanatorio',
        'p_localidad': localidad,
        'p_provincia': provincia,
        'p_razon_social': razonSocial,
        'p_cif': cif,
        'p_direccion': direccion,
        'p_telefono': telefono,
        'p_web': web,
        'p_descripcion': descripcion,
      });
      final usuario = _construirUsuario(
        id: res.user!.id,
        nombre: nombre,
        apellidos: apellidos,
        email: email,
        rol: RolUsuario.tanatorio,
        localidad: localidad,
        provincia: provincia,
        datosTanatorio: DatosTanatorio(
          razonSocial: razonSocial,
          cif: cif,
          direccion: direccion,
          telefono: telefono,
          web: web,
          descripcion: descripcion,
        ),
      );
      _usuarioActual = usuario;
      return AuthResultado.ok(usuario);
    } on AuthException catch (e) {
      return AuthResultado.error(_mensajeAuth(e.message));
    } catch (e) {
      return AuthResultado.error('Error al crear la cuenta: $e');
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
