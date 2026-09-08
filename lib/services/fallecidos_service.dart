import '../models/models.dart';
import 'mock_data.dart';

/// Capa de servicio que expone operaciones sobre fallecidos.
/// Cuando haya un backend real, solo cambia esta clase.
class FallecidosService {
  /// Devuelve todos los fallecidos, opcionalmente filtrados.
  Future<List<Fallecido>> getFeed(FiltroBusqueda filtro) async {
    await Future.delayed(const Duration(milliseconds: 400)); // simula latencia
    var lista = List<Fallecido>.from(MockData.fallecidos);

    if (filtro.textoBusqueda != null && filtro.textoBusqueda!.isNotEmpty) {
      final q = filtro.textoBusqueda!.toLowerCase();
      lista = lista
          .where((f) =>
              f.nombreCompleto.toLowerCase().contains(q) ||
              f.localidad.toLowerCase().contains(q) ||
              f.provincia.toLowerCase().contains(q))
          .toList();
    }

    if (filtro.provincia != null) {
      lista = lista.where((f) => f.provincia == filtro.provincia).toList();
    }

    if (filtro.localidad != null) {
      lista = lista.where((f) => f.localidad == filtro.localidad).toList();
    }

    if (filtro.edadMin != null) {
      lista = lista.where((f) => f.edad >= filtro.edadMin!).toList();
    }

    if (filtro.edadMax != null) {
      lista = lista.where((f) => f.edad <= filtro.edadMax!).toList();
    }

    if (filtro.fechaDesde != null) {
      lista = lista
          .where((f) => f.fechaFallecimiento.isAfter(filtro.fechaDesde!))
          .toList();
    }

    if (filtro.fechaHasta != null) {
      lista = lista
          .where((f) => f.fechaFallecimiento.isBefore(filtro.fechaHasta!))
          .toList();
    }

    // Orden: más recientes primero
    lista.sort((a, b) => b.fechaFallecimiento.compareTo(a.fechaFallecimiento));
    return lista;
  }

  Future<Fallecido?> getDetalle(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.fallecidoPorId(id);
  }

  Future<List<Esquela>> getEsquelas(String fallecidoId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.esquelasDeF(fallecidoId);
  }

  Future<List<Comentario>> getComentarios(String fallecidoId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.comentariosDeF(fallecidoId);
  }

  Future<List<FlorVirtual>> getFlores(String fallecidoId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.floresDeF(fallecidoId);
  }

  Future<List<PostRecuerdo>> getPosts(String fallecidoId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.postsDeF(fallecidoId);
  }

  /// Envía un comentario (queda en estado pendienteRevision).
  Future<Comentario> enviarComentario({
    required String fallecidoId,
    required Usuario autor,
    required String texto,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final nuevo = Comentario(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      fallecidoId: fallecidoId,
      autorId: autor.id,
      autorNombre: autor.nombreCompleto,
      autorAvatarUrl: autor.avatarUrl,
      texto: texto,
      fechaCreacion: DateTime.now(),
      estado: EstadoComentario.pendienteRevision,
    );
    MockData.comentarios.add(nuevo);
    return nuevo;
  }

  /// Envía una flor virtual.
  Future<FlorVirtual> enviarFlor({
    required String fallecidoId,
    required Usuario usuario,
    required TipoFlor tipo,
    String? mensaje,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final nueva = FlorVirtual(
      id: 'fl_${DateTime.now().millisecondsSinceEpoch}',
      fallecidoId: fallecidoId,
      usuarioId: usuario.id,
      usuarioNombre: usuario.nombreCompleto,
      tipo: tipo,
      mensaje: mensaje,
      fecha: DateTime.now(),
    );
    MockData.flores.add(nueva);
    return nueva;
  }

  /// Publica un recuerdo (queda pendiente de revisión).
  Future<PostRecuerdo> publicarRecuerdo({
    required String fallecidoId,
    required Usuario autor,
    required String texto,
    List<String> imagenesUrls = const [],
    bool esPrivado = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final tipo = imagenesUrls.isNotEmpty ? TipoPost.imagen : TipoPost.texto;
    final nuevo = PostRecuerdo(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      fallecidoId: fallecidoId,
      autorId: autor.id,
      autorNombre: autor.nombreCompleto,
      autorAvatarUrl: autor.avatarUrl,
      tipo: tipo,
      texto: texto,
      imagenesUrls: imagenesUrls,
      fechaCreacion: DateTime.now(),
      estado: EstadoPost.pendienteRevision,
      esPrivado: esPrivado,
    );
    MockData.posts.add(nuevo);
    return nuevo;
  }

  /// Da like a un recuerdo (toggle en memoria).
  Future<int> toggleLike(String postId) async {
    final idx = MockData.posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return 0;
    final post = MockData.posts[idx];
    final nuevosLikes = post.likes + 1;
    MockData.posts[idx] = post.copyWith(likes: nuevosLikes);
    return nuevosLikes;
  }

  List<String> get provinciasDisponibles =>
      MockData.fallecidos.map((f) => f.provincia).toSet().toList()..sort();
}
