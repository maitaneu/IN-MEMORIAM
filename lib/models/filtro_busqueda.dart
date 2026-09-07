class FiltroBusqueda {
  final String? provincia;
  final String? localidad;
  final int? edadMin;
  final int? edadMax;
  final DateTime? fechaDesde;
  final DateTime? fechaHasta;
  final String? textoBusqueda;

  const FiltroBusqueda({
    this.provincia,
    this.localidad,
    this.edadMin,
    this.edadMax,
    this.fechaDesde,
    this.fechaHasta,
    this.textoBusqueda,
  });

  bool get tieneFilrosActivos =>
      provincia != null ||
      localidad != null ||
      edadMin != null ||
      edadMax != null ||
      fechaDesde != null ||
      fechaHasta != null ||
      (textoBusqueda != null && textoBusqueda!.isNotEmpty);

  FiltroBusqueda copyWith({
    String? provincia,
    String? localidad,
    int? edadMin,
    int? edadMax,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    String? textoBusqueda,
    bool clearProvincia = false,
    bool clearLocalidad = false,
    bool clearEdades = false,
    bool clearFechas = false,
    bool clearTexto = false,
  }) {
    return FiltroBusqueda(
      provincia: clearProvincia ? null : (provincia ?? this.provincia),
      localidad: clearLocalidad ? null : (localidad ?? this.localidad),
      edadMin: clearEdades ? null : (edadMin ?? this.edadMin),
      edadMax: clearEdades ? null : (edadMax ?? this.edadMax),
      fechaDesde: clearFechas ? null : (fechaDesde ?? this.fechaDesde),
      fechaHasta: clearFechas ? null : (fechaHasta ?? this.fechaHasta),
      textoBusqueda: clearTexto ? null : (textoBusqueda ?? this.textoBusqueda),
    );
  }

  static const FiltroBusqueda vacio = FiltroBusqueda();
}
