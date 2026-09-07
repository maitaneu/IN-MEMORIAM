import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'auth_service.dart';
import 'fallecidos_service.dart';

/// Provider central de la app. Gestiona sesión y filtros activos.
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
    if (!resultado.exito) {
      _errorAuth = resultado.mensajeError;
    }
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
}
