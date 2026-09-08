import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/models.dart';
import '../../../services/app_state.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/widgets.dart';

class TabRecuerdos extends StatefulWidget {
  final String fallecidoId;

  const TabRecuerdos({super.key, required this.fallecidoId});

  @override
  State<TabRecuerdos> createState() => _TabRecuerdosState();
}

class _TabRecuerdosState extends State<TabRecuerdos>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<List<PostRecuerdo>> _future;
  // Mapa local de likes y estado liked para UI inmediata
  final Map<String, int> _likesLocal = {};
  final Set<String> _likedIds = {};

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _future = context
        .read<AppState>()
        .fallecidosService
        .getPosts(widget.fallecidoId);
  }

  Future<void> _toggleLike(PostRecuerdo post) async {
    if (_likedIds.contains(post.id)) return; // ya dado like
    setState(() {
      _likedIds.add(post.id);
      _likesLocal[post.id] = (_likesLocal[post.id] ?? post.likes) + 1;
    });
    await context
        .read<AppState>()
        .fallecidosService
        .toggleLike(post.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = context.read<AppState>();

    return FutureBuilder<List<PostRecuerdo>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.gold));
        }
        final lista = snap.data ?? [];

        return ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // ── Botón añadir recuerdo ──────────────────────────
            LoginWall(
              accion: 'compartir un recuerdo',
              estaLogueado: state.estaLogueado,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Compartir un recuerdo'),
                onPressed: state.estaLogueado
                    ? () => _mostrarDialogoRecuerdo(context, state)
                    : null,
              ),
            ),

            const IMSectionDivider(texto: 'Recuerdos compartidos'),

            if (lista.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Column(
                  children: [
                    const Icon(Icons.photo_library_outlined,
                        size: 52, color: AppColors.textHint),
                    const SizedBox(height: AppSpacing.md),
                    Text('Sé el primero en compartir un recuerdo',
                        style: AppTextStyles.bodyLarge,
                        textAlign: TextAlign.center),
                  ],
                ),
              )
            else
              ...lista.map((p) => _PostCard(
                    post: p,
                    likes: _likesLocal[p.id] ?? p.likes,
                    yaLiked: _likedIds.contains(p.id),
                    onLike: () => _toggleLike(p),
                    onVerImagen: p.imagenesUrls.isNotEmpty
                        ? () => _abrirVisorImagen(context, p.imagenesUrls, 0)
                        : null,
                  )),

            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }

  void _abrirVisorImagen(
      BuildContext context, List<String> urls, int indiceInicial) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, __, ___) =>
            _ImageViewer(urls: urls, indiceInicial: indiceInicial),
      ),
    );
  }

  void _mostrarDialogoRecuerdo(BuildContext context, AppState state) {
    final controller = TextEditingController();
    bool esPrivado = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLarge)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Compartir un recuerdo',
                  style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Tu recuerdo será revisado antes de publicarse.',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Escribe aquí tu recuerdo...',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Toggle privado/público
              GestureDetector(
                onTap: () => setModalState(() => esPrivado = !esPrivado),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40, height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: esPrivado ? AppColors.gold : AppColors.border,
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: esPrivado
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          width: 20, height: 20,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      esPrivado ? Icons.lock_outline : Icons.public_outlined,
                      size: 16,
                      color: esPrivado ? AppColors.gold : AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      esPrivado ? 'Privado (solo familia)' : 'Público',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: esPrivado
                            ? AppColors.gold
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (controller.text.trim().isEmpty) return;
                    await state.fallecidosService.publicarRecuerdo(
                      fallecidoId: widget.fallecidoId,
                      autor: state.usuarioActual!,
                      texto: controller.text.trim(),
                      esPrivado: esPrivado,
                    );
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Recuerdo enviado — pendiente de revisión'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Enviar recuerdo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Card de recuerdo ──────────────────────────────────────────────
class _PostCard extends StatelessWidget {
  final PostRecuerdo post;
  final int likes;
  final bool yaLiked;
  final VoidCallback onLike;
  final VoidCallback? onVerImagen;

  const _PostCard({
    required this.post,
    required this.likes,
    required this.yaLiked,
    required this.onLike,
    this.onVerImagen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Cabecera ────────────────────────────────────────
          Padding(
            padding: AppSpacing.cardPadding,
            child: Row(
              children: [
                IMAvatarWidget(
                  imageUrl: post.autorAvatarUrl,
                  nombre: post.autorNombre,
                  size: AppSpacing.avatarMd,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.autorNombre, style: AppTextStyles.labelLarge),
                      Text(
                        IMDateUtils.fechaCorta(post.fechaCreacion),
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                // Badge privado
                if (post.esPrivado)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.textHint.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: AppColors.textHint.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline,
                            size: 10, color: AppColors.textHint),
                        const SizedBox(width: 3),
                        Text('Privado',
                            style: AppTextStyles.labelSmall
                                .copyWith(fontSize: 10)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // ── Imagen clicable ─────────────────────────────────
          if (post.imagenesUrls.isNotEmpty)
            GestureDetector(
              onTap: onVerImagen,
              child: Stack(
                children: [
                  IMNetworkImage(
                    url: post.imagenesUrls.first,
                    width: double.infinity,
                    height: 220,
                  ),
                  // Indicador de que hay más imágenes
                  if (post.imagenesUrls.length > 1)
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '+${post.imagenesUrls.length - 1}',
                          style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white),
                        ),
                      ),
                    ),
                  // Icono de zoom
                  Positioned(
                    bottom: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.zoom_out_map,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

          // ── Texto ───────────────────────────────────────────
          if (post.texto != null && post.texto!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
              child: Text(post.texto!,
                  style:
                      AppTextStyles.bodyMedium.copyWith(height: 1.6)),
            ),

          // ── Barra de acciones ───────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
            child: Row(
              children: [
                // Like
                GestureDetector(
                  onTap: onLike,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      yaLiked ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(yaLiked),
                      size: 18,
                      color: yaLiked ? AppColors.error : AppColors.textHint,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    '$likes',
                    key: ValueKey(likes),
                    style: AppTextStyles.bodySmall.copyWith(
                      color:
                          yaLiked ? AppColors.error : AppColors.textHint,
                      fontWeight: yaLiked
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Visor de imágenes a pantalla completa ─────────────────────────
class _ImageViewer extends StatefulWidget {
  final List<String> urls;
  final int indiceInicial;

  const _ImageViewer({required this.urls, required this.indiceInicial});

  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer> {
  late PageController _pageCtrl;
  late int _indice;

  @override
  void initState() {
    super.initState();
    _indice = widget.indiceInicial;
    _pageCtrl = PageController(initialPage: widget.indiceInicial);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Fondo negro
            Container(color: Colors.black87),

            // Imágenes con PageView
            PageView.builder(
              controller: _pageCtrl,
              itemCount: widget.urls.length,
              onPageChanged: (i) => setState(() => _indice = i),
              itemBuilder: (_, i) => InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: IMNetworkImage(
                    url: widget.urls[i],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Botón cerrar
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.close,
                      color: Colors.white, size: 20),
                ),
              ),
            ),

            // Indicador de página
            if (widget.urls.length > 1)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                left: 0, right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.urls.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _indice ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _indice
                            ? AppColors.goldLight
                            : Colors.white38,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
