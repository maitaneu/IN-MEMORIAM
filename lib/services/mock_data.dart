import '../models/models.dart';

/// Datos mock estáticos que simulan una base de datos real.
/// Cuando se integre un backend, este archivo se reemplaza por llamadas HTTP.
class MockData {
  // ─── USUARIOS ────────────────────────────────────────────────────────────

  static final List<Usuario> usuarios = [
    Usuario(
      id: 'u1',
      nombre: 'María',
      apellidos: 'López García',
      email: 'maria.lopez@email.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      rol: RolUsuario.registrado,
      fechaRegistro: DateTime(2024, 1, 15),
      localidad: 'Madrid',
      provincia: 'Madrid',
    ),
    Usuario(
      id: 'u2',
      nombre: 'Carlos',
      apellidos: 'Martínez Ruiz',
      email: 'carlos.martinez@email.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      rol: RolUsuario.registrado,
      fechaRegistro: DateTime(2024, 2, 3),
      localidad: 'Sevilla',
      provincia: 'Sevilla',
    ),
    Usuario(
      id: 'u3',
      nombre: 'Tanatorio',
      apellidos: 'San Salvador',
      email: 'info@tanatoriosansalvador.es',
      avatarUrl: 'https://i.pravatar.cc/150?img=60',
      rol: RolUsuario.tanatorio,
      fechaRegistro: DateTime(2023, 6, 10),
      localidad: 'Madrid',
      provincia: 'Madrid',
    ),
    Usuario(
      id: 'u4',
      nombre: 'Ana',
      apellidos: 'Fernández Vega',
      email: 'ana.fernandez@email.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
      rol: RolUsuario.registrado,
      fechaRegistro: DateTime(2024, 3, 20),
      localidad: 'Barcelona',
      provincia: 'Barcelona',
    ),
    Usuario(
      id: 'u5',
      nombre: 'Pedro',
      apellidos: 'Sánchez Morales',
      email: 'pedro.sanchez@email.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=7',
      rol: RolUsuario.registrado,
      fechaRegistro: DateTime(2024, 4, 5),
      localidad: 'Valencia',
      provincia: 'Valencia',
    ),
  ];

  // ─── FALLECIDOS ───────────────────────────────────────────────────────────

  static final List<Fallecido> fallecidos = [
    Fallecido(
      id: 'f1',
      nombre: 'Antonio',
      apellidos: 'García Hernández',
      fechaNacimiento: DateTime(1942, 3, 14),
      fechaFallecimiento: DateTime(2026, 9, 1),
      fotoPrincipalUrl: 'https://randomuser.me/api/portraits/men/75.jpg',
      localidad: 'Madrid',
      provincia: 'Madrid',
      resumenBiografia:
          'Maestro de escuela durante más de 30 años, amante de la lectura y la música clásica. Dedicó su vida a la educación de cientos de niños en el barrio de Salamanca.',
      fotoGaleriaUrls: [
        'https://picsum.photos/seed/ant1/400/300',
        'https://picsum.photos/seed/ant2/400/300',
        'https://picsum.photos/seed/ant3/400/300',
      ],
      infoFuneral: InfoFuneral(
        fechaHora: DateTime(2026, 9, 3, 11, 0),
        lugar: 'Iglesia de San Agustín',
        direccion: 'Calle Alcalá, 45',
        localidad: 'Madrid',
        tanatorio: 'Tanatorio San Salvador',
        notaAdicional: 'Velatorio desde las 18:00 h del día 2 de septiembre.',
      ),
      etiquetas: ['maestro', 'Madrid', 'jubilado'],
    ),
    Fallecido(
      id: 'f2',
      nombre: 'Carmen',
      apellidos: 'Rodríguez Pérez',
      fechaNacimiento: DateTime(1955, 7, 22),
      fechaFallecimiento: DateTime(2026, 8, 28),
      fotoPrincipalUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
      localidad: 'Sevilla',
      provincia: 'Sevilla',
      resumenBiografia:
          'Enfermera vocacional y madre ejemplar de tres hijos. Su sonrisa y generosidad iluminaban cada habitación que pisaba.',
      fotoGaleriaUrls: [
        'https://picsum.photos/seed/car1/400/300',
        'https://picsum.photos/seed/car2/400/300',
      ],
      infoFuneral: InfoFuneral(
        fechaHora: DateTime(2026, 8, 30, 10, 30),
        lugar: 'Parroquia Nuestra Señora del Carmen',
        direccion: 'Av. de la Constitución, 12',
        localidad: 'Sevilla',
        tanatorio: 'Funeraria Losada',
        notaAdicional: 'La familia agradece la discreción y el respeto.',
      ),
      etiquetas: ['enfermera', 'Sevilla', 'sanitaria'],
    ),
    Fallecido(
      id: 'f3',
      nombre: 'Manuel',
      apellidos: 'Torres Jiménez',
      fechaNacimiento: DateTime(1938, 11, 5),
      fechaFallecimiento: DateTime(2026, 9, 4),
      fotoPrincipalUrl: 'https://randomuser.me/api/portraits/men/62.jpg',
      localidad: 'Barcelona',
      provincia: 'Barcelona',
      resumenBiografia:
          'Ingeniero industrial retirado, apasionado de la fotografía y el senderismo. Recorrió los principales picos del Pirineo.',
      fotoGaleriaUrls: [
        'https://picsum.photos/seed/man1/400/300',
        'https://picsum.photos/seed/man2/400/300',
        'https://picsum.photos/seed/man3/400/300',
        'https://picsum.photos/seed/man4/400/300',
      ],
      infoFuneral: InfoFuneral(
        fechaHora: DateTime(2026, 9, 6, 12, 0),
        lugar: 'Tanatori Les Corts',
        direccion: 'Carrer de Numància, 35',
        localidad: 'Barcelona',
        tanatorio: 'Tanatori Les Corts',
      ),
      etiquetas: ['ingeniero', 'Barcelona', 'jubilado', 'deporte'],
    ),
    Fallecido(
      id: 'f4',
      nombre: 'Pilar',
      apellidos: 'Navarro Castillo',
      fechaNacimiento: DateTime(1948, 4, 18),
      fechaFallecimiento: DateTime(2026, 9, 3),
      fotoPrincipalUrl: 'https://randomuser.me/api/portraits/women/52.jpg',
      localidad: 'Valencia',
      provincia: 'Valencia',
      resumenBiografia:
          'Pintora autodidacta y profesora de bellas artes durante 25 años en la Escuela de Artes y Oficios de Valencia.',
      fotoGaleriaUrls: [
        'https://picsum.photos/seed/pil1/400/300',
        'https://picsum.photos/seed/pil2/400/300',
      ],
      infoFuneral: InfoFuneral(
        fechaHora: DateTime(2026, 9, 5, 10, 0),
        lugar: 'Iglesia de los Santos Juanes',
        direccion: 'Plaza del Mercado, s/n',
        localidad: 'Valencia',
        tanatorio: 'Funeraria Valenciagrup',
      ),
      etiquetas: ['artista', 'Valencia', 'profesora'],
    ),
    Fallecido(
      id: 'f5',
      nombre: 'José Luis',
      apellidos: 'Moreno Alonso',
      fechaNacimiento: DateTime(1960, 9, 30),
      fechaFallecimiento: DateTime(2026, 9, 5),
      fotoPrincipalUrl: 'https://randomuser.me/api/portraits/men/44.jpg',
      localidad: 'Zaragoza',
      provincia: 'Zaragoza',
      resumenBiografia:
          'Médico de familia durante más de 30 años en el Centro de Salud Delicias. Reconocido por su cercanía y dedicación a los pacientes.',
      fotoGaleriaUrls: [
        'https://picsum.photos/seed/jos1/400/300',
      ],
      infoFuneral: InfoFuneral(
        fechaHora: DateTime(2026, 9, 7, 11, 30),
        lugar: 'Tanatorio Municipal de Zaragoza',
        direccion: 'Av. de Cataluña, 235',
        localidad: 'Zaragoza',
        tanatorio: 'Tanatorio Municipal',
      ),
      etiquetas: ['médico', 'Zaragoza', 'sanitario'],
    ),
  ];

  // ─── ESQUELAS ─────────────────────────────────────────────────────────────

  static final List<Esquela> esquelas = [
    // Esquelas de f1 - Antonio García
    Esquela(
      id: 'e1',
      fallecidoId: 'f1',
      autorId: 'u3',
      autorNombre: 'Tanatorio San Salvador',
      autorEsTanatorio: true,
      titulo: 'D.E.P. Antonio García Hernández',
      texto:
          'El Tanatorio San Salvador comunica con profundo pesar el fallecimiento de D. Antonio García Hernández, acaecido el día 1 de septiembre de 2026. Su familia ruega una oración por su alma.',
      imagenUrl: 'https://picsum.photos/seed/esq1/600/400',
      fechaPublicacion: DateTime(2026, 9, 1, 18, 0),
      estado: EstadoEsquela.aprobada,
      firmantes: ['Su esposa, Isabel', 'Sus hijos, Marta y Roberto', 'Toda la familia'],
    ),
    Esquela(
      id: 'e2',
      fallecidoId: 'f1',
      autorId: 'u1',
      autorNombre: 'María López García',
      autorEsTanatorio: false,
      titulo: 'Para mi querido abuelo',
      texto:
          'Abuelo, tu recuerdo vivirá siempre en nuestros corazones. Gracias por enseñarnos el valor del esfuerzo y la honestidad. Te echamos de menos cada día.',
      fechaPublicacion: DateTime(2026, 9, 2, 10, 30),
      estado: EstadoEsquela.aprobada,
      firmantes: ['Tus nietos', 'María, Roberto, Lucía y Pablo'],
    ),

    // Esquelas de f2 - Carmen Rodríguez
    Esquela(
      id: 'e3',
      fallecidoId: 'f2',
      autorId: 'u3',
      autorNombre: 'Funeraria Losada',
      autorEsTanatorio: true,
      titulo: 'Fallecimiento de Dña. Carmen Rodríguez Pérez',
      texto:
          'Funeraria Losada comunica el sensible fallecimiento de Dña. Carmen Rodríguez Pérez. La misa funeral tendrá lugar el próximo lunes a las 10:30 h.',
      imagenUrl: 'https://picsum.photos/seed/esq3/600/400',
      fechaPublicacion: DateTime(2026, 8, 28, 20, 0),
      estado: EstadoEsquela.aprobada,
      firmantes: ['Su marido, Juan', 'Sus hijos, Elena, Miguel y Laura'],
    ),

    // Esquelas de f3 - Manuel Torres
    Esquela(
      id: 'e4',
      fallecidoId: 'f3',
      autorId: 'u4',
      autorNombre: 'Ana Fernández Vega',
      autorEsTanatorio: false,
      titulo: 'En recuerdo de Manuel',
      texto:
          'Compañero de innumerables rutas de montaña, fotógrafo apasionado y mejor amigo. El Pirineo te echará de menos.',
      fechaPublicacion: DateTime(2026, 9, 4, 15, 0),
      estado: EstadoEsquela.aprobada,
      firmantes: ['El Club de Montaña Pirineos', 'Todos tus compañeros de senderismo'],
    ),

    // Esquelas de f4 - Pilar Navarro
    Esquela(
      id: 'e5',
      fallecidoId: 'f4',
      autorId: 'u3',
      autorNombre: 'Funeraria Valenciagrup',
      autorEsTanatorio: true,
      titulo: 'D.E.P. Pilar Navarro Castillo',
      texto:
          'Con profundo dolor comunicamos el fallecimiento de nuestra querida Pilar. Sus pinturas seguirán llenando de color el mundo que tanto amó.',
      imagenUrl: 'https://picsum.photos/seed/esq5/600/400',
      fechaPublicacion: DateTime(2026, 9, 3, 19, 0),
      estado: EstadoEsquela.aprobada,
      firmantes: ['La Escuela de Artes y Oficios de Valencia', 'Sus alumnos y compañeros'],
    ),
  ];

  // ─── COMENTARIOS ─────────────────────────────────────────────────────────

  static final List<Comentario> comentarios = [
    Comentario(
      id: 'c1',
      fallecidoId: 'f1',
      autorId: 'u2',
      autorNombre: 'Carlos Martínez',
      autorAvatarUrl: 'https://i.pravatar.cc/150?img=12',
      texto:
          'Don Antonio fue mi profesor en el colegio Guadalquivir. Nunca olvidaré sus clases de lengua. Un abrazo enorme a toda la familia.',
      fechaCreacion: DateTime(2026, 9, 2, 9, 15),
      estado: EstadoComentario.aprobado,
    ),
    Comentario(
      id: 'c2',
      fallecidoId: 'f1',
      autorId: 'u4',
      autorNombre: 'Ana Fernández',
      autorAvatarUrl: 'https://i.pravatar.cc/150?img=32',
      texto:
          'Mi más sentido pésame a la familia García. Que descanse en paz.',
      fechaCreacion: DateTime(2026, 9, 2, 11, 40),
      estado: EstadoComentario.aprobado,
    ),
    Comentario(
      id: 'c3',
      fallecidoId: 'f1',
      autorId: 'u5',
      autorNombre: 'Pedro Sánchez',
      autorAvatarUrl: 'https://i.pravatar.cc/150?img=7',
      texto:
          'Le conocí en la asociación de vecinos. Siempre dispuesto a ayudar. Descansa en paz, maestro.',
      fechaCreacion: DateTime(2026, 9, 3, 8, 0),
      estado: EstadoComentario.aprobado,
    ),
    Comentario(
      id: 'c4',
      fallecidoId: 'f2',
      autorId: 'u1',
      autorNombre: 'María López',
      autorAvatarUrl: 'https://i.pravatar.cc/150?img=47',
      texto:
          'Carmen fue la enfermera que cuidó a mi madre durante su enfermedad. Una persona excepcional. Todo mi cariño a su familia.',
      fechaCreacion: DateTime(2026, 8, 29, 14, 20),
      estado: EstadoComentario.aprobado,
    ),
    Comentario(
      id: 'c5',
      fallecidoId: 'f3',
      autorId: 'u5',
      autorNombre: 'Pedro Sánchez',
      autorAvatarUrl: 'https://i.pravatar.cc/150?img=7',
      texto:
          'Compartimos muchas rutas juntos por los Pirineos. Un grandísimo compañero. DEP, Manuel.',
      fechaCreacion: DateTime(2026, 9, 4, 18, 5),
      estado: EstadoComentario.aprobado,
    ),
    Comentario(
      id: 'c6',
      fallecidoId: 'f4',
      autorId: 'u2',
      autorNombre: 'Carlos Martínez',
      autorAvatarUrl: 'https://i.pravatar.cc/150?img=12',
      texto:
          'Tuve el honor de asistir a varias de sus exposiciones. Sus cuadros transmitían una paz increíble. Descanse en paz.',
      fechaCreacion: DateTime(2026, 9, 4, 9, 30),
      estado: EstadoComentario.aprobado,
    ),
  ];

  // ─── FLORES VIRTUALES ─────────────────────────────────────────────────────

  static final List<FlorVirtual> flores = [
    FlorVirtual(
      id: 'fl1',
      fallecidoId: 'f1',
      usuarioId: 'u1',
      usuarioNombre: 'María López',
      tipo: TipoFlor.rosa,
      mensaje: 'Con todo mi cariño',
      fecha: DateTime(2026, 9, 2, 10, 0),
    ),
    FlorVirtual(
      id: 'fl2',
      fallecidoId: 'f1',
      usuarioId: 'u2',
      usuarioNombre: 'Carlos Martínez',
      tipo: TipoFlor.lirio,
      fecha: DateTime(2026, 9, 2, 12, 0),
    ),
    FlorVirtual(
      id: 'fl3',
      fallecidoId: 'f1',
      usuarioId: 'u4',
      usuarioNombre: 'Ana Fernández',
      tipo: TipoFlor.ramo,
      mensaje: 'DEP',
      fecha: DateTime(2026, 9, 3, 8, 30),
    ),
    FlorVirtual(
      id: 'fl4',
      fallecidoId: 'f2',
      usuarioId: 'u1',
      usuarioNombre: 'María López',
      tipo: TipoFlor.crisantemo,
      mensaje: 'Por todo lo que hizo por mi madre',
      fecha: DateTime(2026, 8, 29, 16, 0),
    ),
    FlorVirtual(
      id: 'fl5',
      fallecidoId: 'f3',
      usuarioId: 'u5',
      usuarioNombre: 'Pedro Sánchez',
      tipo: TipoFlor.tulipan,
      fecha: DateTime(2026, 9, 5, 10, 0),
    ),
    FlorVirtual(
      id: 'fl6',
      fallecidoId: 'f4',
      usuarioId: 'u2',
      usuarioNombre: 'Carlos Martínez',
      tipo: TipoFlor.orquidea,
      mensaje: 'Por su arte y generosidad',
      fecha: DateTime(2026, 9, 4, 11, 0),
    ),
  ];

  // ─── POSTS / RECUERDOS ────────────────────────────────────────────────────

  static final List<PostRecuerdo> posts = [
    PostRecuerdo(
      id: 'p1',
      fallecidoId: 'f1',
      autorId: 'u1',
      autorNombre: 'María López',
      autorAvatarUrl: 'https://i.pravatar.cc/150?img=47',
      tipo: TipoPost.imagen,
      texto: 'Una foto de aquella excursión a Segovia que hicimos hace 10 años. Siempre sonriendo.',
      imagenesUrls: ['https://picsum.photos/seed/post1/600/400'],
      fechaCreacion: DateTime(2026, 9, 2, 14, 0),
      estado: EstadoPost.aprobado,
      likes: 12,
    ),
    PostRecuerdo(
      id: 'p2',
      fallecidoId: 'f1',
      autorId: 'u2',
      autorNombre: 'Carlos Martínez',
      autorAvatarUrl: 'https://i.pravatar.cc/150?img=12',
      tipo: TipoPost.texto,
      texto:
          '"La educación es el arma más poderosa que puedes usar para cambiar el mundo." Una de las frases que Don Antonio nos repetía cada año el primer día de clase. Nunca la he olvidado.',
      fechaCreacion: DateTime(2026, 9, 3, 9, 0),
      estado: EstadoPost.aprobado,
      likes: 24,
    ),
    PostRecuerdo(
      id: 'p3',
      fallecidoId: 'f2',
      autorId: 'u4',
      autorNombre: 'Ana Fernández',
      autorAvatarUrl: 'https://i.pravatar.cc/150?img=32',
      tipo: TipoPost.imagen,
      texto: 'Carmen en la fiesta de jubilación. Siempre rodeada de los que la querían.',
      imagenesUrls: ['https://picsum.photos/seed/post3/600/400'],
      fechaCreacion: DateTime(2026, 8, 30, 10, 0),
      estado: EstadoPost.aprobado,
      likes: 18,
    ),
    PostRecuerdo(
      id: 'p4',
      fallecidoId: 'f3',
      autorId: 'u5',
      autorNombre: 'Pedro Sánchez',
      autorAvatarUrl: 'https://i.pravatar.cc/150?img=7',
      tipo: TipoPost.imagen,
      texto: 'Manuel en la cima del Aneto, verano de 2019. Le encantaba ese pico.',
      imagenesUrls: ['https://picsum.photos/seed/post4/600/400'],
      fechaCreacion: DateTime(2026, 9, 5, 12, 0),
      estado: EstadoPost.aprobado,
      likes: 31,
    ),
  ];

  // ─── HELPERS ──────────────────────────────────────────────────────────────

  static List<Esquela> esquelasDeF(String fallecidoId) =>
      esquelas.where((e) => e.fallecidoId == fallecidoId && e.estado == EstadoEsquela.aprobada).toList();

  static List<Comentario> comentariosDeF(String fallecidoId) =>
      comentarios.where((c) => c.fallecidoId == fallecidoId && c.estaAprobado).toList();

  static List<FlorVirtual> floresDeF(String fallecidoId) =>
      flores.where((f) => f.fallecidoId == fallecidoId).toList();

  static List<PostRecuerdo> postsDeF(String fallecidoId) =>
      posts.where((p) => p.fallecidoId == fallecidoId && p.estaAprobado).toList();

  static Fallecido? fallecidoPorId(String id) =>
      fallecidos.where((f) => f.id == id).firstOrNull;
}
