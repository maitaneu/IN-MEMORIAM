enum EstadoPost { pendienteRevision, aprobado, rechazado }

enum TipoPost { texto, imagen, video }

class PostRecuerdo {
  final String id;
  final String fallecidoId;
  final String autorId;
  final String autorNombre;
  final String? autorAvatarUrl;
  final TipoPost tipo;
  final String? texto;
  final List<String> imagenesUrls;
  final String? videoUrl;
  final DateTime fechaCreacion;
  final EstadoPost estado;
  final int likes;
  /// Si es true, solo lo ve la familia (autorizado por ella).
  final bool esPrivado;

  const PostRecuerdo({
    required this.id,
    required this.fallecidoId,
    required this.autorId,
    required this.autorNombre,
    this.autorAvatarUrl,
    required this.tipo,
    this.texto,
    this.imagenesUrls = const [],
    this.videoUrl,
    required this.fechaCreacion,
    this.estado = EstadoPost.pendienteRevision,
    this.likes = 0,
    this.esPrivado = false,
  });

  bool get estaAprobado => estado == EstadoPost.aprobado;

  PostRecuerdo copyWith({int? likes}) => PostRecuerdo(
        id: id,
        fallecidoId: fallecidoId,
        autorId: autorId,
        autorNombre: autorNombre,
        autorAvatarUrl: autorAvatarUrl,
        tipo: tipo,
        texto: texto,
        imagenesUrls: imagenesUrls,
        videoUrl: videoUrl,
        fechaCreacion: fechaCreacion,
        estado: estado,
        likes: likes ?? this.likes,
        esPrivado: esPrivado,
      );
}
