/// Categorías de evento en la cronología vital.
enum CategoriaEvento {
  nacimiento,
  infancia,
  educacion,
  trabajo,
  familia,
  viaje,
  logro,
  fallecimiento,
  otro,
}

extension CategoriaEventoExtension on CategoriaEvento {
  String get etiqueta {
    switch (this) {
      case CategoriaEvento.nacimiento:
        return 'Nacimiento';
      case CategoriaEvento.infancia:
        return 'Infancia';
      case CategoriaEvento.educacion:
        return 'Educación';
      case CategoriaEvento.trabajo:
        return 'Trabajo';
      case CategoriaEvento.familia:
        return 'Familia';
      case CategoriaEvento.viaje:
        return 'Viaje';
      case CategoriaEvento.logro:
        return 'Logro';
      case CategoriaEvento.fallecimiento:
        return 'Fallecimiento';
      case CategoriaEvento.otro:
        return 'Otro';
    }
  }

  String get emoji {
    switch (this) {
      case CategoriaEvento.nacimiento:
        return '🌟';
      case CategoriaEvento.infancia:
        return '🧒';
      case CategoriaEvento.educacion:
        return '🎓';
      case CategoriaEvento.trabajo:
        return '💼';
      case CategoriaEvento.familia:
        return '👨‍👩‍👧';
      case CategoriaEvento.viaje:
        return '✈️';
      case CategoriaEvento.logro:
        return '🏆';
      case CategoriaEvento.fallecimiento:
        return '🕊️';
      case CategoriaEvento.otro:
        return '📌';
    }
  }
}

/// Un acontecimiento importante en la cronología de la vida del fallecido.
class EventoCronologia {
  final String id;
  final String fallecidoId;
  final int anio;
  final int? mes;
  final String titulo;
  final String? descripcion;
  final String? imagenUrl;
  final CategoriaEvento categoria;
  final DateTime fechaCreacion;

  const EventoCronologia({
    required this.id,
    required this.fallecidoId,
    required this.anio,
    this.mes,
    required this.titulo,
    this.descripcion,
    this.imagenUrl,
    this.categoria = CategoriaEvento.otro,
    required this.fechaCreacion,
  });
}
