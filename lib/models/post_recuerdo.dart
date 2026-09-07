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
  });

  bool get estaAprobado => estado == EstadoPost.aprobado;
}
