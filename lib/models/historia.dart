/// Estado de moderación de una Historia.
enum EstadoHistoria { pendienteRevision, aprobada, rechazada }

/// Una historia personal compartida por alguien que conoció al fallecido.
/// Es la funcionalidad «Historias que queremos recordar»: el autor cuenta
/// cómo lo conoció, una anécdota, algo que aprendió, o un momento especial.
class Historia {
  final String id;
  final String fallecidoId;
  final String autorId;
  final String autorNombre;
  final String? autorAvatarUrl;

  /// Cómo se conocieron / relación con el fallecido.
  final String? relacionAutor;

  /// El título breve de la historia.
  final String titulo;

  /// El cuerpo de la historia.
  final String texto;

  /// Foto opcional que acompaña a la historia.
  final String? imagenUrl;

  final int likes;
  final DateTime fechaCreacion;
  final EstadoHistoria estado;

  const Historia({
    required this.id,
    required this.fallecidoId,
    required this.autorId,
    required this.autorNombre,
    this.autorAvatarUrl,
    this.relacionAutor,
    required this.titulo,
    required this.texto,
    this.imagenUrl,
    this.likes = 0,
    required this.fechaCreacion,
    this.estado = EstadoHistoria.pendienteRevision,
  });

  bool get estaAprobada => estado == EstadoHistoria.aprobada;

  Historia copyWith({int? likes}) => Historia(
        id: id,
        fallecidoId: fallecidoId,
        autorId: autorId,
        autorNombre: autorNombre,
        autorAvatarUrl: autorAvatarUrl,
        relacionAutor: relacionAutor,
        titulo: titulo,
        texto: texto,
        imagenUrl: imagenUrl,
        likes: likes ?? this.likes,
        fechaCreacion: fechaCreacion,
        estado: estado,
      );
}
