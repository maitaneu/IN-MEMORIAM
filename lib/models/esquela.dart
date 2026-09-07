enum EstadoEsquela { pendiente, aprobada, rechazada }

class Esquela {
  final String id;
  final String fallecidoId;
  final String autorId; // usuario o tanatorio que la publica
  final String autorNombre;
  final bool autorEsTanatorio;
  final String titulo;
  final String texto;
  final String? imagenUrl;
  final DateTime fechaPublicacion;
  final EstadoEsquela estado;
  final List<String> firmantes; // "La familia García..."

  const Esquela({
    required this.id,
    required this.fallecidoId,
    required this.autorId,
    required this.autorNombre,
    this.autorEsTanatorio = false,
    required this.titulo,
    required this.texto,
    this.imagenUrl,
    required this.fechaPublicacion,
    this.estado = EstadoEsquela.aprobada,
    this.firmantes = const [],
  });
}
