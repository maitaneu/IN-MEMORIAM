import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'auth_service.dart';
import 'fallecidos_service.dart';
import 'mock_data.dart';

/// Provider central de la app. Gestiona sesión, filtros y seguimientos.
class AppState extends ChangeNotifier {
  final AuthService _auth = AuthService();
  final FallecidosService fallecidosService = FallecidosService();

  // ── Autenticación ─────────────────────────────────────────────
  Usuario? get usuarioActual => _auth.usuarioActual;
  bool get estaLogueado => _auth.estaLogueado;

  bool _cargandoAuth = false;
  bool get cargandoAuth => _cargandoAuth;

  String? _errorAuth;
  String? get errorAuth => _errorAuth;

  Future<bool> login(String email, String password) async {
    _cargandoAuth = true;
    _errorAuth = null;
    notifyListeners();

    final resultado = await _auth.login(email, password);

    _cargandoAuth = false;
    if (!resultado.exito) {
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
      nombre: nombre,
      apellidos: apellidos,
      email: email,
      password: password,
      localidad: localidad,
      provincia: provincia,
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
      nombre: nombre,
      apellidos: apellidos,
      email: email,
      password: password,
      relacionFallecido: relacionFallecido,
      documentoIdentidad: documentoIdentidad,
      localidad: localidad,
      provincia: provincia,
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
      nombre: nombre,
      apellidos: apellidos,
      email: email,
      password: password,
      razonSocial: razonSocial,
      cif: cif,
      direccion: direccion,
      telefono: telefono,
      web: web,
      descripcion: descripcion,
      localidad: localidad,
      provincia: provincia,
    );

    _cargandoAuth = false;
    if (!resultado.exito) _errorAuth = resultado.mensajeError;
    notifyListeners();
    return resultado.exito;
  }

  void logout() {
    _auth.logout();
    notifyListeners();
  }

  void limpiarErrorAuth() {
    _errorAuth = null;
    notifyListeners();
  }

  // ── Filtros del feed ──────────────────────────────────────────
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

  /// Devuelve true si el usuario actual sigue el fallecido dado.
  bool sigueA(String fallecidoId) {
    if (!estaLogueado) return false;
    return MockData.sigueA(usuarioActual!.id, fallecidoId);
  }

  /// Alterna el seguimiento. Devuelve el nuevo estado (true = siguiendo).
  bool toggleSeguir(String fallecidoId) {
    if (!estaLogueado) return false;
    final uid = usuarioActual!.id;
    if (MockData.sigueA(uid, fallecidoId)) {
      MockData.dejarDeSeguir(uid, fallecidoId);
      notifyListeners();
      return false;
    } else {
      MockData.seguir(uid, fallecidoId);
      notifyListeners();
      return true;
    }
  }

  /// Lista de fallecidos que sigue el usuario actual.
  List<Fallecido> get fallecidosSeguidos {
    if (!estaLogueado) return [];
    final ids = MockData.seguimientosDeUsuario(usuarioActual!.id);
    return ids
        .map((id) => MockData.fallecidoPorId(id))
        .whereType<Fallecido>()
        .toList();
  }

  // ── Actividad del usuario ─────────────────────────────────────

  /// Condolencias (comentarios) enviadas por el usuario actual.
  List<Comentario> get misCondolencias {
    if (!estaLogueado) return [];
    return MockData.condolenciasDeUsuario(usuarioActual!.id);
  }

  /// Recuerdos (posts) publicados por el usuario actual.
  List<PostRecuerdo> get misRecuerdos {
    if (!estaLogueado) return [];
    return MockData.recuerdosDeUsuario(usuarioActual!.id);
  }

  /// Flores enviadas por el usuario actual.
  List<FlorVirtual> get misFlores {
    if (!estaLogueado) return [];
    return MockData.floresDeUsuario(usuarioActual!.id);
  }
}
