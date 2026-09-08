class Fallecido {
  final String id;
  final String nombre;
  final String apellidos;
  final DateTime fechaNacimiento;
  final DateTime fechaFallecimiento;
  final String? fotoPrincipalUrl;
  final String localidad;
  final String provincia;
  final String pais;
  final String? resumenBiografia;
  final List<String> fotoGaleriaUrls;
  final InfoFuneral? infoFuneral;
  final List<String> etiquetas;
  /// ID del usuario tanatorio que gestiona esta publicación (opcional).
  final String? tanatorioId;

  const Fallecido({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.fechaFallecimiento,
    this.fotoPrincipalUrl,
    required this.localidad,
    required this.provincia,
    this.pais = 'España',
    this.resumenBiografia,
    this.fotoGaleriaUrls = const [],
    this.infoFuneral,
    this.etiquetas = const [],
    this.tanatorioId,
  });

  String get nombreCompleto => '$nombre $apellidos';

  int get edad {
    final diff = fechaFallecimiento.difference(fechaNacimiento);
    return (diff.inDays / 365).floor();
  }

  String get ubicacion => '$localidad, $provincia';
}

class InfoFuneral {
  final DateTime? fechaHora;
  final String? lugar;
  final String? direccion;
  final String? localidad;
  final String? tanatorio;
  final String? notaAdicional;

  const InfoFuneral({
    this.fechaHora,
    this.lugar,
    this.direccion,
    this.localidad,
    this.tanatorio,
    this.notaAdicional,
  });
}
