enum EstadoComentario { pendienteRevision, aprobado, rechazado }

class Comentario {
  final String id;
  final String fallecidoId;
  final String autorId;
  final String autorNombre;
  final String? autorAvatarUrl;
  final String texto;
  final DateTime fechaCreacion;
  final EstadoComentario estado;

  const Comentario({
    required this.id,
    required this.fallecidoId,
    required this.autorId,
    required this.autorNombre,
    this.autorAvatarUrl,
    required this.texto,
    required this.fechaCreacion,
    this.estado = EstadoComentario.pendienteRevision,
  });

  bool get estaAprobado => estado == EstadoComentario.aprobado;
}
