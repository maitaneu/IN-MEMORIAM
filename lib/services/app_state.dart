import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'auth_service.dart';
import 'fallecidos_service.dart';
import 'supabase_service.dart';

/// Provider central de la app. Gestiona sesión, filtros y seguimientos.
class AppState extends ChangeNotifier {
  final AuthService _auth = AuthService();
  final FallecidosService fallecidosService = FallecidosService();

  // Caché local
  final Set<String> _seguimientosIds = {};
  List<Fallecido> _fallecidosSeguidos = [];
  List<Comentario> _misCondolencias = [];
  List<PostRecuerdo> _misRecuerdos = [];
  List<FlorVirtual> _misFlores = [];

  // ── Auth ──────────────────────────────────────────────────────
  Usuario? get usuarioActual => _auth.usuarioActual;
  bool get estaLogueado => _auth.estaLogueado;

  bool _cargandoAuth = false;
  bool get cargandoAuth => _cargandoAuth;

  String? _errorAuth;
  String? get errorAuth => _errorAuth;

  /// Restaura sesión al arrancar la app.
  Future<void> inicializar() async {
    await _auth.restaurarSesion();
    if (estaLogueado) await _cargarDatosUsuario();
    notifyListeners();
  }

  Future<void> _cargarDatosUsuario() async {
    if (!estaLogueado) return;
    final uid = usuarioActual!.id;
    await Future.wait([
      _cargarSeguimientos(uid),
      _cargarActividad(uid),
    ]);
  }

  Future<void> _cargarSeguimientos(String uid) async {
    final rows = await SB.client
        .from('seguimientos')
        .select('fallecido_id')
        .eq('usuario_id', uid);
    _seguimientosIds.clear();
    for (final r in rows as List) {
      _seguimientosIds.add((r as Map<String, dynamic>)['fallecido_id'] as String);
    }
    final futures = _seguimientosIds
        .map((id) => fallecidosService.getDetalle(id))
        .toList();
    final resultados = await Future.wait(futures);
    _fallecidosSeguidos = resultados.whereType<Fallecido>().toList();
  }

  Future<void> _cargarActividad(String uid) async {
    final comentariosRows = await SB.client
        .from('comentarios')
        .select()
        .eq('autor_id', uid)
        .order('created_at', ascending: false);
    _misCondolencias = (comentariosRows as List)
        .map((r) => FallecidosService.rowToComentario(r as Map<String, dynamic>))
        .toList();

    final postsRows = await SB.client
        .from('posts')
        .select()
        .eq('autor_id', uid)
        .order('created_at', ascending: false);
    _misRecuerdos = (postsRows as List)
        .map((r) => FallecidosService.rowToPost(r as Map<String, dynamic>))
        .toList();

    final floresRows = await SB.client
        .from('flores')
        .select()
        .eq('usuario_id', uid)
        .order('created_at', ascending: false);
    _misFlores = (floresRows as List)
        .map((r) => FallecidosService.rowToFlor(r as Map<String, dynamic>))
        .toList();
  }

  Future<bool> login(String email, String password) async {
    _cargandoAuth = true;
    _errorAuth = null;
    notifyListeners();
    final resultado = await _auth.login(email, password);
    _cargandoAuth = false;
    if (resultado.exito) {
      await _cargarDatosUsuario();
    } else {
      _errorAuth = resultado.mensajeError;
    }
    notifyListeners();
    return resultado.exito;
  }

  Future<bool> registrar({
    required String nombre,
    required String apellidos,
    required String email,
    required String password,
    String? localidad,
    String? provincia,
  }) async {
    _cargandoAuth = true;
    _errorAuth = null;
    notifyListeners();
    final resultado = await _auth.registrar(
      nombre: nombre, apellidos: apellidos,
      email: email, password: password,
      localidad: localidad, provincia: provincia,
    );
    _cargandoAuth = false;
    if (!resultado.exito) _errorAuth = resultado.mensajeError;
    notifyListeners();
    return resultado.exito;
  }

  Future<bool> registrarParticular({
    required String nombre,
    required String apellidos,
    required String email,
    required String password,
    required String relacionFallecido,
    String? documentoIdentidad,
    String? localidad,
    String? provincia,
  }) async {
    _cargandoAuth = true;
    _errorAuth = null;
    notifyListeners();
    final resultado = await _auth.registrarParticular(
      nombre: nombre, apellidos: apellidos,
      email: email, password: password,
      relacionFallecido: relacionFallecido,
      documentoIdentidad: documentoIdentidad,
      localidad: localidad, provincia: provincia,
    );
    _cargandoAuth = false;
    if (!resultado.exito) _errorAuth = resultado.mensajeError;
    notifyListeners();
    return resultado.exito;
  }

  Future<bool> registrarTanatorio({
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
    _cargandoAuth = true;
    _errorAuth = null;
    notifyListeners();
    final resultado = await _auth.registrarTanatorio(
      nombre: nombre, apellidos: apellidos,
      email: email, password: password,
      razonSocial: razonSocial, cif: cif, direccion: direccion,
      telefono: telefono, web: web, descripcion: descripcion,
      localidad: localidad, provincia: provincia,
    );
    _cargandoAuth = false;
    if (!resultado.exito) _errorAuth = resultado.mensajeError;
    notifyListeners();
    return resultado.exito;
  }

  void logout() {
    _auth.logout();
    _seguimientosIds.clear();
    _fallecidosSeguidos = [];
    _misCondolencias = [];
    _misRecuerdos = [];
    _misFlores = [];
    notifyListeners();
  }

  void limpiarErrorAuth() {
    _errorAuth = null;
    notifyListeners();
  }

  // ── Filtros ───────────────────────────────────────────────────
  FiltroBusqueda _filtro = FiltroBusqueda.vacio;
  FiltroBusqueda get filtro => _filtro;

  void actualizarFiltro(FiltroBusqueda nuevo) {
    _filtro = nuevo;
    notifyListeners();
  }

  void limpiarFiltros() {
    _filtro = FiltroBusqueda.vacio;
    notifyListeners();
  }

  // ── Seguimientos ──────────────────────────────────────────────

  bool sigueA(String fallecidoId) => _seguimientosIds.contains(fallecidoId);

  /// Versión síncrona para compatibilidad con widgets (lanza async en background).
  bool toggleSeguir(String fallecidoId) {
    final yaSigue = _seguimientosIds.contains(fallecidoId);
    _toggleSeguirAsync(fallecidoId);
    return !yaSigue;
  }

  Future<void> _toggleSeguirAsync(String fallecidoId) async {
    if (!estaLogueado) return;
    final uid = usuarioActual!.id;
    if (_seguimientosIds.contains(fallecidoId)) {
      await SB.client
          .from('seguimientos')
          .delete()
          .eq('usuario_id', uid)
          .eq('fallecido_id', fallecidoId);
      _seguimientosIds.remove(fallecidoId);
      _fallecidosSeguidos.removeWhere((f) => f.id == fallecidoId);
    } else {
      await SB.client.from('seguimientos').insert({
        'usuario_id': uid,
        'fallecido_id': fallecidoId,
      });
      _seguimientosIds.add(fallecidoId);
      final f = await fallecidosService.getDetalle(fallecidoId);
      if (f != null) _fallecidosSeguidos.add(f);
    }
    notifyListeners();
  }

  List<Fallecido> get fallecidosSeguidos => List.unmodifiable(_fallecidosSeguidos);
  List<Comentario> get misCondolencias => List.unmodifiable(_misCondolencias);
  List<PostRecuerdo> get misRecuerdos => List.unmodifiable(_misRecuerdos);
  List<FlorVirtual> get misFlores => List.unmodifiable(_misFlores);
}
