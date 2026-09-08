import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../theme/theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/widgets.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        if (!state.estaLogueado) {
          return _buildNoLogueado(context);
        }
        return _PerfilLogueado(state: state);
      },
    );
  }

  // ── Estado sin sesión ─────────────────────────────────────────
  Widget _buildNoLogueado(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi perfil'),
        backgroundColor: AppColors.surface,
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.surfaceVariant,
                ),
                child: const Icon(Icons.person_outline, size: 40, color: AppColors.textHint),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('No has iniciado sesión',
                  style: AppTextStyles.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Inicia sesión o regístrate para acceder a tu perfil y poder interactuar con la comunidad.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => context.push('/login'),
                  child: const Text('Iniciar sesión'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: OutlinedButton(
                  onPressed: () => context.push('/registro'),
                  child: const Text('Crear cuenta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Perfil logueado: StatefulWidget para TabController manual ─────
class _PerfilLogueado extends StatefulWidget {
  final AppState state;
  const _PerfilLogueado({required this.state});

  @override
  State<_PerfilLogueado> createState() => _PerfilLogueadoState();
}

class _PerfilLogueadoState extends State<_PerfilLogueado>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final usuario = state.usuarioActual!;
    final seguidos = state.fallecidosSeguidos;
    final condolencias = state.misCondolencias;
    final recuerdos = state.misRecuerdos;
    final flores = state.misFlores;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header fijo ───────────────────────────────────
            Container(
              color: AppColors.surface,
              child: Column(
                children: [
                  // Fila de acciones (⋮)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        tooltip: 'Opciones',
                        onPressed: () => _mostrarOpciones(context, state),
                      ),
                    ],
                  ),
                  // Avatar + info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                    child: Column(
                      children: [
                        IMAvatarWidget(
                          imageUrl: usuario.avatarUrl,
                          nombre: usuario.nombreCompleto,
                          size: AppSpacing.avatarXL,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(usuario.nombreCompleto,
                            style: AppTextStyles.headlineLarge),
                        const SizedBox(height: 4),
                        _RolBadge(rol: usuario.rol),
                        if (usuario.localidad != null ||
                            usuario.provincia != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 14, color: AppColors.textHint),
                              const SizedBox(width: 4),
                              Text(
                                [usuario.localidad, usuario.provincia]
                                    .where((s) => s != null)
                                    .join(', '),
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        // Contadores — clicables para cambiar de tab
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => _tabController.animateTo(0),
                              child: _Contador(
                                  valor: seguidos.length,
                                  etiqueta: 'Siguiendo'),
                            ),
                            _ContadorDivider(),
                            GestureDetector(
                              onTap: () => _tabController.animateTo(1),
                              child: _Contador(
                                  valor: condolencias.length + flores.length,
                                  etiqueta: 'Condolencias'),
                            ),
                            _ContadorDivider(),
                            GestureDetector(
                              onTap: () => _tabController.animateTo(2),
                              child: _Contador(
                                  valor: recuerdos.length,
                                  etiqueta: 'Recuerdos'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // TabBar — solo iconos, el texto ya está en los contadores
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(icon: Icon(Icons.notifications_none, size: 22)),
                      Tab(icon: Icon(Icons.favorite_border, size: 22)),
                      Tab(icon: Icon(Icons.photo_library_outlined, size: 22)),
                    ],
                  ),
                ],
              ),
            ),
            // ── Contenido de tabs ─────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _TabSeguidos(seguidos: seguidos),
                  _TabCondolencias(condolencias: condolencias, flores: flores),
                  _TabRecuerdos(recuerdos: recuerdos),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarOpciones(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              leading: const Icon(Icons.help_outline, color: AppColors.textSecondary),
              title: Text('Ayuda', style: AppTextStyles.bodyMedium),
              onTap: () { Navigator.pop(context); context.push('/ayuda'); },
            ),
            ListTile(
              leading: const Icon(Icons.gavel_outlined, color: AppColors.textSecondary),
              title: Text('Aviso legal y privacidad', style: AppTextStyles.bodyMedium),
              onTap: () { Navigator.pop(context); context.push('/legal'); },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: AppColors.textSecondary),
              title: Text('Sobre IN MEMORIAM', style: AppTextStyles.bodyMedium),
              onTap: () { Navigator.pop(context); context.push('/sobre'); },
            ),
            const Divider(color: AppColors.divider),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: Text('Cerrar sesión',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                _confirmarLogout(context, state);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  void _confirmarLogout(BuildContext context, AppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        title: Text('Cerrar sesión', style: AppTextStyles.headlineMedium),
        content: Text('¿Seguro que quieres cerrar sesión?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); state.logout(); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}

// ── Tab 1: Fallecimientos seguidos ────────────────────────────────
class _TabSeguidos extends StatelessWidget {
  final List<Fallecido> seguidos;
  const _TabSeguidos({required this.seguidos});

  @override
  Widget build(BuildContext context) {
    if (seguidos.isEmpty) {
      return _buildVacio(
        icono: Icons.notifications_none,
        titulo: 'Aún no sigues ningún fallecimiento',
        subtitulo:
            'Cuando sigas uno, aparecerá aquí y podrás estar al tanto de nuevos recuerdos.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: seguidos.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) => _FallecidoSeguidoTile(fallecido: seguidos[i]),
    );
  }
}

class _FallecidoSeguidoTile extends StatelessWidget {
  final Fallecido fallecido;
  const _FallecidoSeguidoTile({required this.fallecido});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/fallecido/${fallecido.id}'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: IMNetworkImage(url: fallecido.fotoPrincipalUrl, width: 60, height: 60),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fallecido.nombreCompleto, style: AppTextStyles.labelLarge),
                  const SizedBox(height: 2),
                  Text(
                    IMDateUtils.rangoAnios(
                        fallecido.fechaNacimiento, fallecido.fechaFallecimiento),
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold),
                  ),
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textHint),
                    const SizedBox(width: 3),
                    Text(fallecido.ubicacion, style: AppTextStyles.labelSmall),
                  ]),
                ],
              ),
            ),
            Consumer<AppState>(
              builder: (context, state, _) => IconButton(
                icon: const Icon(Icons.notifications_active,
                    color: AppColors.gold, size: 20),
                tooltip: 'Dejar de seguir',
                onPressed: () {
                  state.toggleSeguir(fallecido.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Has dejado de seguir a ${fallecido.nombreCompleto}'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ));
                },
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

// ── Tab 2: Condolencias enviadas ──────────────────────────────────
class _TabCondolencias extends StatelessWidget {
  final List<Comentario> condolencias;
  final List<FlorVirtual> flores;
  const _TabCondolencias({required this.condolencias, required this.flores});

  @override
  Widget build(BuildContext context) {
    if (condolencias.isEmpty && flores.isEmpty) {
      return _buildVacio(
        icono: Icons.favorite_border,
        titulo: 'Aún no has enviado condolencias',
        subtitulo: 'Las condolencias y flores virtuales que envíes aparecerán aquí.',
      );
    }
    final items = <_ActividadItem>[
      ...condolencias.map(_ActividadItem.comentario),
      ...flores.map(_ActividadItem.flor),
    ]..sort((a, b) => b.fecha.compareTo(a.fecha));

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) => _ActividadTile(item: items[i]),
    );
  }
}

// ── Tab 3: Recuerdos publicados ───────────────────────────────────
class _TabRecuerdos extends StatelessWidget {
  final List<PostRecuerdo> recuerdos;
  const _TabRecuerdos({required this.recuerdos});

  @override
  Widget build(BuildContext context) {
    if (recuerdos.isEmpty) {
      return _buildVacio(
        icono: Icons.photo_library_outlined,
        titulo: 'Aún no has compartido recuerdos',
        subtitulo: 'Los recuerdos que publiques en los fallecimientos aparecerán aquí.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: recuerdos.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) => _RecuerdoTile(recuerdo: recuerdos[i]),
    );
  }
}

// ── Actividad item ────────────────────────────────────────────────
class _ActividadItem {
  final DateTime fecha;
  final String fallecidoId;
  final Comentario? comentario;
  final FlorVirtual? flor;

  _ActividadItem.comentario(Comentario c)
      : fecha = c.fechaCreacion,
        fallecidoId = c.fallecidoId,
        comentario = c,
        flor = null;

  _ActividadItem.flor(FlorVirtual f)
      : fecha = f.fecha,
        fallecidoId = f.fallecidoId,
        comentario = null,
        flor = f;
}

class _ActividadTile extends StatelessWidget {
  final _ActividadItem item;
  const _ActividadTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final esFlor = item.flor != null;
    final icono = esFlor ? item.flor!.tipo.emoji : '💬';
    final texto = esFlor
        ? 'Enviaste ${item.flor!.tipo.nombre.toLowerCase()}${item.flor!.mensaje != null ? ' · "${item.flor!.mensaje}"' : ''}'
        : item.comentario!.texto;
    final estado = item.comentario?.estado;

    return GestureDetector(
      onTap: () => context.push('/fallecido/${item.fallecidoId}'),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Text(icono, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(texto,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    Text(IMDateUtils.fechaCorta(item.fecha),
                        style: AppTextStyles.labelSmall),
                    if (estado != null) ...[
                      const SizedBox(width: 8),
                      _EstadoBadge(estado: estado),
                    ],
                  ]),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class _RecuerdoTile extends StatelessWidget {
  final PostRecuerdo recuerdo;
  const _RecuerdoTile({required this.recuerdo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/fallecido/${recuerdo.fallecidoId}'),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recuerdo.imagenesUrls.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: IMNetworkImage(
                  url: recuerdo.imagenesUrls.first,
                  height: 140,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (recuerdo.texto != null && recuerdo.texto!.isNotEmpty)
              Text(recuerdo.texto!,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              Text(IMDateUtils.fechaCorta(recuerdo.fechaCreacion),
                  style: AppTextStyles.labelSmall),
              const SizedBox(width: 8),
              _EstadoBadge(estado: recuerdo.estado),
              if (recuerdo.esPrivado) ...[
                const SizedBox(width: 8),
                const _PrivadoBadge(),
              ],
              const Spacer(),
              const Icon(Icons.favorite_border, size: 13, color: AppColors.textHint),
              const SizedBox(width: 3),
              Text('${recuerdo.likes}', style: AppTextStyles.labelSmall),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.textHint),
            ]),
          ],
        ),
      ),
    );
  }
}

// ── Estado vacío genérico ─────────────────────────────────────────
Widget _buildVacio({
  required IconData icono,
  required String titulo,
  required String subtitulo,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 48, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.md),
          Text(titulo, style: AppTextStyles.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitulo,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

// ── Badges ────────────────────────────────────────────────────────
class _EstadoBadge extends StatelessWidget {
  final dynamic estado;
  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final bool pendiente = estado.toString().contains('pendiente');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: pendiente
            ? AppColors.pending.withOpacity(0.12)
            : AppColors.success.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: pendiente
              ? AppColors.pending.withOpacity(0.4)
              : AppColors.success.withOpacity(0.4),
        ),
      ),
      child: Text(
        pendiente ? 'Pendiente' : 'Publicado',
        style: AppTextStyles.labelSmall.copyWith(
          color: pendiente ? AppColors.pending : AppColors.success,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _PrivadoBadge extends StatelessWidget {
  const _PrivadoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.textHint.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.textHint.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, size: 9, color: AppColors.textHint),
          const SizedBox(width: 3),
          Text('Privado',
              style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textHint, fontSize: 10)),
        ],
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────
class _RolBadge extends StatelessWidget {
  final RolUsuario rol;
  const _RolBadge({required this.rol});

  String get _label {
    switch (rol) {
      case RolUsuario.tanatorio: return 'Tanatorio verificado';
      case RolUsuario.administrador: return 'Administrador';
      case RolUsuario.particular: return 'Particular';
      default: return 'Miembro';
    }
  }

  IconData get _icon {
    switch (rol) {
      case RolUsuario.tanatorio: return Icons.verified;
      case RolUsuario.administrador: return Icons.admin_panel_settings;
      case RolUsuario.particular: return Icons.person_pin;
      default: return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.goldLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: AppColors.gold),
          const SizedBox(width: 4),
          Text(_label, style: AppTextStyles.caption.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

class _Contador extends StatelessWidget {
  final int valor;
  final String etiqueta;
  const _Contador({required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('$valor',
          style: AppTextStyles.headlineMedium.copyWith(color: AppColors.gold)),
      Text(etiqueta, style: AppTextStyles.labelSmall),
    ]);
  }
}

class _ContadorDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 30, width: 1, color: AppColors.border);
}
