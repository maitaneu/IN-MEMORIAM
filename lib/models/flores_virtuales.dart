enum TipoFlor {
  rosa,
  lirio,
  crisantemo,
  tulipan,
  margarita,
  orquidea,
  ramo,
}

extension TipoFlorExtension on TipoFlor {
  String get nombre {
    switch (this) {
      case TipoFlor.rosa:
        return 'Rosa';
      case TipoFlor.lirio:
        return 'Lirio';
      case TipoFlor.crisantemo:
        return 'Crisantemo';
      case TipoFlor.tulipan:
        return 'Tulipán';
      case TipoFlor.margarita:
        return 'Margarita';
      case TipoFlor.orquidea:
        return 'Orquídea';
      case TipoFlor.ramo:
        return 'Ramo';
    }
  }

  String get emoji {
    switch (this) {
      case TipoFlor.rosa:
        return '🌹';
      case TipoFlor.lirio:
        return '⚜️';
      case TipoFlor.crisantemo:
        return '🌸';
      case TipoFlor.tulipan:
        return '🌷';
      case TipoFlor.margarita:
        return '🌼';
      case TipoFlor.orquidea:
        return '🪷';
      case TipoFlor.ramo:
        return '💐';
    }
  }
}

class FlorVirtual {
  final String id;
  final String fallecidoId;
  final String usuarioId;
  final String usuarioNombre;
  final TipoFlor tipo;
  final String? mensaje;
  final DateTime fecha;

  const FlorVirtual({
    required this.id,
    required this.fallecidoId,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.tipo,
    this.mensaje,
    required this.fecha,
  });
}
