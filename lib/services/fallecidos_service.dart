import '../models/models.dart';
import 'supabase_service.dart';

/// Capa de servicio que lee y escribe en Supabase.
/// La interfaz pública es idéntica a la versión mock — las pantallas no cambian.
class FallecidosService {
  // ── Conversores fila → modelo (públicos para AppState) ────────

  static Fallecido rowToFallecido(Map<String, dynamic> r) {
    InfoFuneral? funeral;
    if (r['funeral_lugar'] != null || r['funeral_fecha_hora'] != null) {
      funeral = InfoFuneral(
        fechaHora: r['funeral_fecha_hora'] != null
            ? DateTime.parse(r['funeral_fecha_hora'] as String)
            : null,
        lugar: r['funeral_lugar'] as String?,
        direccion: r['funeral_direccion'] as String?,
        localidad: r['funeral_localidad'] as String?,
        tanatorio: r['funeral_tanatorio'] as String?,
        notaAdicional: r['funeral_nota'] as String?,
      );
    }
    return Fallecido(
      id: r['id'] as String,
      nombre: r['nombre'] as String,
      apellidos: r['apellidos'] as String,
      fechaNacimiento: DateTime.parse(r['fecha_nacimiento'] as String),
      fechaFallecimiento: DateTime.parse(r['fecha_fallecimiento'] as String),
      fotoPrincipalUrl: r['foto_principal_url'] as String?,
      fotoGaleriaUrls: List<String>.from(r['foto_galeria_urls'] ?? []),
      videoUrls: List<String>.from(r['video_urls'] ?? []),
      localidad: r['localidad'] as String,
      provincia: r['provincia'] as String,
      pais: r['pais'] as String? ?? 'España',
      lugarNacimiento: r['lugar_nacimiento'] as String?,
      lugarResidencia: r['lugar_residencia'] as String?,
      resumenBiografia: r['resumen_biografia'] as String?,
      etiquetas: List<String>.from(r['etiquetas'] ?? []),
      tanatorioId: r['tanatorio_id'] as String?,
      infoFuneral: funeral,
    );
  }

  // ── Conversor EventoCronologia ────────────────────────────────

  static EventoCronologia rowToEvento(Map<String, dynamic> r) =>
      EventoCronologia(
        id: r['id'] as String,
        fallecidoId: r['fallecido_id'] as String,
        anio: r['anio'] as int,
        mes: r['mes'] as int?,
        titulo: r['titulo'] as String,
        descripcion: r['descripcion'] as String?,
        imagenUrl: r['imagen_url'] as String?,
        categoria: CategoriaEvento.values.firstWhere(
          (c) => c.name == (r['categoria'] as String? ?? 'otro'),
          orElse: () => CategoriaEvento.otro,
        ),
        fechaCreacion: DateTime.parse(r['created_at'] as String),
      );

  // ── Conversor Historia ────────────────────────────────────────

  static Historia rowToHistoria(Map<String, dynamic> r) => Historia(
        id: r['id'] as String,
        fallecidoId: r['fallecido_id'] as String,
        autorId: r['autor_id'] as String,
        autorNombre: r['autor_nombre'] as String,
        autorAvatarUrl: r['autor_avatar_url'] as String?,
        relacionAutor: r['relacion_autor'] as String?,
        titulo: r['titulo'] as String,
        texto: r['texto'] as String,
        imagenUrl: r['imagen_url'] as String?,
        likes: r['likes'] as int? ?? 0,
        fechaCreacion: DateTime.parse(r['created_at'] as String),
        estado: EstadoHistoria.values.firstWhere(
          (e) => e.name == (r['estado'] as String? ?? 'pendienteRevision'),
          orElse: () => EstadoHistoria.pendienteRevision,
        ),
      );

  static Esquela rowToEsquela(Map<String, dynamic> r) => Esquela(
        id: r['id'] as String,
        fallecidoId: r['fallecido_id'] as String,
        autorId: r['autor_id'] as String,
        autorNombre: r['autor_nombre'] as String,
        autorEsTanatorio: r['autor_tanatorio'] as bool? ?? false,
        titulo: r['titulo'] as String,
        texto: r['texto'] as String,
        imagenUrl: r['imagen_url'] as String?,
        firmantes: List<String>.from(r['firmantes'] ?? []),
        fechaPublicacion: DateTime.parse(r['created_at'] as String),
        estado: EstadoEsquela.values.firstWhere(
          (e) => e.name == (r['estado'] as String),
          orElse: () => EstadoEsquela.pendiente,
        ),
      );

  static Comentario rowToComentario(Map<String, dynamic> r) => Comentario(
        id: r['id'] as String,
        fallecidoId: r['fallecido_id'] as String,
        autorId: r['autor_id'] as String,
        autorNombre: r['autor_nombre'] as String,
        texto: r['texto'] as String,
        fechaCreacion: DateTime.parse(r['created_at'] as String),
        estado: EstadoComentario.values.firstWhere(
          (e) => e.name == (r['estado'] as String? ?? 'pendiente_revision'),
          orElse: () => EstadoComentario.pendienteRevision,
        ),
      );

  static FlorVirtual rowToFlor(Map<String, dynamic> r) => FlorVirtual(
        id: r['id'] as String,
        fallecidoId: r['fallecido_id'] as String,
        usuarioId: r['usuario_id'] as String,
        usuarioNombre: r['usuario_nombre'] as String,
        tipo: TipoFlor.values.firstWhere(
          (t) => t.name == (r['tipo'] as String),
          orElse: () => TipoFlor.rosa,
        ),
        mensaje: r['mensaje'] as String?,
        fecha: DateTime.parse(r['created_at'] as String),
      );

  static PostRecuerdo rowToPost(Map<String, dynamic> r) => PostRecuerdo(
        id: r['id'] as String,
        fallecidoId: r['fallecido_id'] as String,
        autorId: r['autor_id'] as String,
        autorNombre: r['autor_nombre'] as String,
        tipo: TipoPost.values.firstWhere(
          (t) => t.name == (r['tipo'] as String? ?? 'texto'),
          orElse: () => TipoPost.texto,
        ),
        texto: r['texto'] as String?,
        imagenesUrls: List<String>.from(r['imagenes_urls'] ?? []),
        videoUrl: r['video_url'] as String?,
        esPrivado: r['es_privado'] as bool? ?? false,
        likes: r['likes'] as int? ?? 0,
        fechaCreacion: DateTime.parse(r['created_at'] as String),
        estado: EstadoPost.values.firstWhere(
          (e) => e.name == (r['estado'] as String? ?? 'pendiente_revision'),
          orElse: () => EstadoPost.pendienteRevision,
        ),
      );

  // ── Operaciones públicas ──────────────────────────────────────

  Future<List<Fallecido>> getFeed(FiltroBusqueda filtro) async {
    var query = SB.client.from('fallecidos').select();

    if (filtro.provincia != null) {
      query = query.eq('provincia', filtro.provincia!);
    }
    if (filtro.localidad != null) {
      query = query.eq('localidad', filtro.localidad!);
    }
    if (filtro.fechaDesde != null) {
      query = query.gte(
          'fecha_fallecimiento', filtro.fechaDesde!.toIso8601String());
    }
    if (filtro.fechaHasta != null) {
      query = query.lte(
          'fecha_fallecimiento', filtro.fechaHasta!.toIso8601String());
    }
    if (filtro.textoBusqueda != null && filtro.textoBusqueda!.isNotEmpty) {
      query = query.or(
        'nombre.ilike.%${filtro.textoBusqueda}%,'
        'apellidos.ilike.%${filtro.textoBusqueda}%,'
        'localidad.ilike.%${filtro.textoBusqueda}%',
      );
    }

    final rows = await query.order('fecha_fallecimiento', ascending: false);
    var lista = (rows as List)
        .map((r) => rowToFallecido(r as Map<String, dynamic>))
        .toList();

    if (filtro.edadMin != null) {
      lista = lista.where((f) => f.edad >= filtro.edadMin!).toList();
    }
    if (filtro.edadMax != null) {
      lista = lista.where((f) => f.edad <= filtro.edadMax!).toList();
    }
    return lista;
  }

  Future<Fallecido?> getDetalle(String id) async {
    final row =
        await SB.client.from('fallecidos').select().eq('id', id).maybeSingle();
    if (row == null) return null;
    return rowToFallecido(row);
  }

  Future<List<Esquela>> getEsquelas(String fallecidoId) async {
    final rows = await SB.client
        .from('esquelas')
        .select()
        .eq('fallecido_id', fallecidoId)
        .eq('estado', 'aprobada')
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => rowToEsquela(r as Map<String, dynamic>))
        .toList();
  }

  Future<Esquela> publicarEsquela({
    required String fallecidoId,
    required Usuario autor,
    required String titulo,
    required String texto,
    String? imagenUrl,
    List<String> firmantes = const [],
  }) async {
    final datos = <String, dynamic>{
      'fallecido_id': fallecidoId,
      'autor_id': autor.id,
      'autor_nombre': autor.nombrePublico,
      'autor_tanatorio': autor.esTanatorio,
      'titulo': titulo.trim(),
      'texto': texto.trim(),
      'firmantes': firmantes,
      'estado': 'pendiente',
    };
    if (imagenUrl != null && imagenUrl.trim().isNotEmpty) {
      datos['imagen_url'] = imagenUrl.trim();
    }

    final row =
        await SB.client.from('esquelas').insert(datos).select().single();
    return rowToEsquela(row as Map<String, dynamic>);
  }

  Future<List<Comentario>> getComentarios(String fallecidoId) async {
    final rows = await SB.client
        .from('comentarios')
        .select()
        .eq('fallecido_id', fallecidoId)
        .eq('estado', 'aprobado')
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => rowToComentario(r as Map<String, dynamic>))
        .toList();
  }

  Future<List<FlorVirtual>> getFlores(String fallecidoId) async {
    final rows = await SB.client
        .from('flores')
        .select()
        .eq('fallecido_id', fallecidoId)
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => rowToFlor(r as Map<String, dynamic>))
        .toList();
  }

  Future<List<PostRecuerdo>> getPosts(String fallecidoId) async {
    final rows = await SB.client
        .from('posts')
        .select()
        .eq('fallecido_id', fallecidoId)
        .eq('estado', 'aprobado')
        .eq('es_privado', false)
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => rowToPost(r as Map<String, dynamic>))
        .toList();
  }

  Future<Comentario> enviarComentario({
    required String fallecidoId,
    required Usuario autor,
    required String texto,
  }) async {
    final row = await SB.client
        .from('comentarios')
        .insert({
          'fallecido_id': fallecidoId,
          'autor_id': autor.id,
          'autor_nombre': autor.nombreCompleto,
          'texto': texto,
          'estado': 'pendiente_revision',
        })
        .select()
        .single();
    return rowToComentario(row as Map<String, dynamic>);
  }

  Future<FlorVirtual> enviarFlor({
    required String fallecidoId,
    required Usuario usuario,
    required TipoFlor tipo,
    String? mensaje,
  }) async {
    final row = await SB.client
        .from('flores')
        .insert({
          'fallecido_id': fallecidoId,
          'usuario_id': usuario.id,
          'usuario_nombre': usuario.nombreCompleto,
          'tipo': tipo.name,
          'mensaje': mensaje,
        })
        .select()
        .single();
    return rowToFlor(row as Map<String, dynamic>);
  }

  Future<PostRecuerdo> publicarRecuerdo({
    required String fallecidoId,
    required Usuario autor,
    required String texto,
    List<String> imagenesUrls = const [],
    bool esPrivado = false,
  }) async {
    final tipo = imagenesUrls.isNotEmpty ? TipoPost.imagen : TipoPost.texto;
    final row = await SB.client
        .from('posts')
        .insert({
          'fallecido_id': fallecidoId,
          'autor_id': autor.id,
          'autor_nombre': autor.nombreCompleto,
          'tipo': tipo.name,
          'texto': texto,
          'imagenes_urls': imagenesUrls,
          'es_privado': esPrivado,
          'estado': 'pendiente_revision',
        })
        .select()
        .single();
    return rowToPost(row as Map<String, dynamic>);
  }

  Future<int> toggleLike(String postId) async {
    // Incrementa el contador de likes con una función SQL en Supabase
    await SB.client.rpc('incrementar_likes', params: {'post_id': postId});
    final row =
        await SB.client.from('posts').select('likes').eq('id', postId).single();
    return (row as Map<String, dynamic>)['likes'] as int? ?? 0;
  }

  // ── Velas virtuales ───────────────────────────────────────────

  Future<int> getNumVelas(String fallecidoId) async {
    final result = await SB.client
        .from('velas')
        .select('id')
        .eq('fallecido_id', fallecidoId);
    return (result as List).length;
  }

  Future<void> encenderVela({
    required String fallecidoId,
    required Usuario usuario,
    String? mensaje,
  }) async {
    await SB.client.from('velas').insert({
      'fallecido_id': fallecidoId,
      'usuario_id': usuario.id,
      'usuario_nombre': usuario.nombreCompleto,
      if (mensaje != null && mensaje.isNotEmpty) 'mensaje': mensaje,
    });
  }

  // ── Cronología ────────────────────────────────────────────────

  Future<List<EventoCronologia>> getCronologia(String fallecidoId) async {
    final rows = await SB.client
        .from('cronologia')
        .select()
        .eq('fallecido_id', fallecidoId)
        .order('anio', ascending: true);
    return (rows as List)
        .map((r) => rowToEvento(r as Map<String, dynamic>))
        .toList();
  }

  Future<EventoCronologia> publicarEvento({
    required String fallecidoId,
    required int anio,
    int? mes,
    required String titulo,
    String? descripcion,
    String? imagenUrl,
    CategoriaEvento categoria = CategoriaEvento.otro,
  }) async {
    final row = await SB.client
        .from('cronologia')
        .insert({
          'fallecido_id': fallecidoId,
          'anio': anio,
          if (mes != null) 'mes': mes,
          'titulo': titulo.trim(),
          if (descripcion != null && descripcion.isNotEmpty)
            'descripcion': descripcion.trim(),
          if (imagenUrl != null && imagenUrl.isNotEmpty)
            'imagen_url': imagenUrl.trim(),
          'categoria': categoria.name,
        })
        .select()
        .single();
    return rowToEvento(row as Map<String, dynamic>);
  }

  // ── Historias ─────────────────────────────────────────────────

  Future<List<Historia>> getHistorias(String fallecidoId) async {
    final rows = await SB.client
        .from('historias')
        .select()
        .eq('fallecido_id', fallecidoId)
        .eq('estado', 'aprobada')
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => rowToHistoria(r as Map<String, dynamic>))
        .toList();
  }

  Future<Historia> publicarHistoria({
    required String fallecidoId,
    required Usuario autor,
    required String titulo,
    required String texto,
    String? relacionAutor,
    String? imagenUrl,
  }) async {
    final row = await SB.client
        .from('historias')
        .insert({
          'fallecido_id': fallecidoId,
          'autor_id': autor.id,
          'autor_nombre': autor.nombreCompleto,
          'titulo': titulo.trim(),
          'texto': texto.trim(),
          if (relacionAutor != null && relacionAutor.isNotEmpty)
            'relacion_autor': relacionAutor.trim(),
          if (imagenUrl != null && imagenUrl.isNotEmpty)
            'imagen_url': imagenUrl.trim(),
          'estado': 'pendienteRevision',
        })
        .select()
        .single();
    return rowToHistoria(row as Map<String, dynamic>);
  }

  Future<int> toggleLikeHistoria(String historiaId) async {
    await SB.client
        .rpc('incrementar_likes_historia', params: {'historia_id': historiaId});
    final row = await SB.client
        .from('historias')
        .select('likes')
        .eq('id', historiaId)
        .single();
    return (row as Map<String, dynamic>)['likes'] as int? ?? 0;
  }

  List<String> get provinciasDisponibles => [];
}
