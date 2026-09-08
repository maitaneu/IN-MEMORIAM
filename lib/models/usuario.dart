enum RolUsuario { visitante, registrado, particular, tanatorio, administrador }

/// Datos extra solo para cuentas de funeraria/tanatorio.
class DatosTanatorio {
  final String razonSocial;
  final String cif;
  final String direccion;
  final String? web;
  final String? telefono;
  final String? descripcion;
  final List<String> servicios;
  final String? logoUrl;
  final double? latitud;
  final double? longitud;

  const DatosTanatorio({
    required this.razonSocial,
    required this.cif,
    required this.direccion,
    this.web,
    this.telefono,
    this.descripcion,
    this.servicios = const [],
    this.logoUrl,
    this.latitud,
    this.longitud,
  });
}

/// Datos extra solo para cuentas de particular que publican un fallecimiento.
class DatosParticular {
  /// Relación con el fallecido (hijo/a, cónyuge, amigo/a…).
  final String relacionFallecido;
  /// DNI u otro documento identificativo.
  final String? documentoIdentidad;
  /// Estado del pago requerido para publicar.
  final EstadoPagoParticular estadoPago;

  const DatosParticular({
    required this.relacionFallecido,
    this.documentoIdentidad,
    this.estadoPago = EstadoPagoParticular.pendiente,
  });
}

enum EstadoPagoParticular { pendiente, completado, fallido }

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

  /// Solo presente si rol == RolUsuario.tanatorio
  final DatosTanatorio? datosTanatorio;

  /// Solo presente si rol == RolUsuario.particular
  final DatosParticular? datosParticular;

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
    this.datosTanatorio,
    this.datosParticular,
  });

  String get nombreCompleto => '$nombre $apellidos';

  bool get esTanatorio => rol == RolUsuario.tanatorio;
  bool get esParticular => rol == RolUsuario.particular;
  bool get esAdmin => rol == RolUsuario.administrador;

  /// Nombre público: razón social para tanatorios, nombre completo para el resto.
  String get nombrePublico =>
      esTanatorio && datosTanatorio != null
          ? datosTanatorio!.razonSocial
          : nombreCompleto;

  Usuario copyWith({
    String? nombre,
    String? apellidos,
    String? avatarUrl,
    String? localidad,
    String? provincia,
    DatosTanatorio? datosTanatorio,
    DatosParticular? datosParticular,
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
      datosTanatorio: datosTanatorio ?? this.datosTanatorio,
      datosParticular: datosParticular ?? this.datosParticular,
    );
  }
}
