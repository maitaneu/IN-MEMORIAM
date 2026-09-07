enum RolUsuario { visitante, registrado, tanatorio, administrador }

class Usuario {
  final String id;
  final String nombre;
  final String apellidos;
  final String email;
  final String? avatarUrl;
  final RolUsuario rol;
  final DateTime fechaRegistro;
  final String? localidad;
  final String? provincia;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.email,
    this.avatarUrl,
    this.rol = RolUsuario.registrado,
    required this.fechaRegistro,
    this.localidad,
    this.provincia,
  });

  String get nombreCompleto => '$nombre $apellidos';

  bool get esTanatorio => rol == RolUsuario.tanatorio;
  bool get esAdmin => rol == RolUsuario.administrador;

  Usuario copyWith({
    String? nombre,
    String? apellidos,
    String? avatarUrl,
    String? localidad,
    String? provincia,
  }) {
    return Usuario(
      id: id,
      nombre: nombre ?? this.nombre,
      apellidos: apellidos ?? this.apellidos,
      email: email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rol: rol,
      fechaRegistro: fechaRegistro,
      localidad: localidad ?? this.localidad,
      provincia: provincia ?? this.provincia,
    );
  }
}
