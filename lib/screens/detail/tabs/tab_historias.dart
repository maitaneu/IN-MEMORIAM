import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/models.dart';
import '../../../services/app_state.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/widgets.dart';

class TabHistorias extends StatefulWidget {
  final String fallecidoId;

  const TabHistorias({super.key, required this.fallecidoId});

  @override
  State<TabHistorias> createState() => _TabHistoriasState();
}

class _TabHistoriasState extends State<TabHistorias>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<List<Historia>> _future;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _future = context
        .read<AppState>()
        .fallecidosService
        .getHistorias(widget.fallecidoId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = context.read<AppState>();

    return FutureBuilder<List<Historia>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.gold),
          );
        }

        final historias = snap.data ?? [];

        return ListView(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: AppSpacing.xxl,
          ),
          children: [
            // ── Cabecera explicativa ─────────────────────────
            _HistoriasHeader(),
            const SizedBox(height: AppSpacing.md),

            // ── Botón compartir historia ─────────────────────
            LoginWall(
              accion: 'compartir una historia',
              estaLogueado: state.estaLogueado,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit_note),
                label: const Text('Contar una historia'),
                onPressed: state.estaLogueado
                    ? () => _mostrarDialogoHistoria(context, state)
                    : null,
              ),
            ),

            const IMSectionDivider(texto: 'Historias compartidas'),

            // ── Lista vacía ──────────────────────────────────
            if (historias.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Column(
                  children: [
                    const Text('📖',
                        style: TextStyle(fontSize: 52)),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Sé el primero en contar\nuna historia sobre él',
                      style: AppTextStyles.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Cómo lo conociste, una anécdota,\nalgo que aprendiste de él…',
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...historias.map(
                (h) => _HistoriaCard(
                  historia: h,
                  onLike: () => _toggleLike(h),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _toggleLike(Historia h) async {
    final svc = context.read<AppState>().fallecidosService;
    await svc.toggleLikeHistoria(h.id);
    setState(() => _cargar());
  }

  void _mostrarDialogoHistoria(BuildContext context, AppState state) {
    final tituloCtrl = TextEditingController();
    final textoCtrl = TextEditingController();
    final relacionCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.md,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Título sección
              Text('Cuenta tu historia',
                  style: AppTextStyles.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Tu historia será revisada antes de publicarse.',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),

              // Relación
              TextField(
                controller: relacionCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: '¿Cómo lo conociste?',
                  hintText: 'Ej: Éramos amigos de la infancia',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Título
              TextField(
                controller: tituloCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Título de tu historia *',
                  hintText: 'Ej: La vez que me enseñó a pescar',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Texto
              TextField(
                controller: textoCtrl,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Tu historia *',
                  hintText:
                      'Cuéntanos ese momento especial, una anécdota, algo que aprendiste de él o cómo cambió tu vida…',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final titulo = tituloCtrl.text.trim();
                    final texto = textoCtrl.text.trim();
                    if (titulo.isEmpty || texto.isEmpty) return;
                    await state.fallecidosService.publicarHistoria(
                      fallecidoId: widget.fallecidoId,
                      autor: state.usuarioActual!,
                      titulo: titulo,
                      texto: texto,
                      relacionAutor: relacionCtrl.text.trim().isEmpty
                          ? null
                          : relacionCtrl.text.trim(),
                    );
                    if (ctx.mounted) Navigator.pop(ctx);
                    setState(() => _cargar());
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Historia enviada — pendiente de revisión'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Enviar historia'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Cabecera explicativa de la sección ───────────────────────────────

class _HistoriasHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.goldLight.withOpacity(0.25),
            AppColors.goldLight.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.goldLight, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📖', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Historias que queremos recordar',
                  style: AppTextStyles.headlineSmall
                      .copyWith(color: AppColors.goldDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Cada persona que lo conoció guarda un momento único. '
            'Comparte cómo lo conociste, una anécdota que te marcó, '
            'algo que aprendiste de él o un instante que nunca olvidarás.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta de historia ───────────────────────────────────────────────

class _HistoriaCard extends StatelessWidget {
  final Historia historia;
  final VoidCallback onLike;

  const _HistoriaCard({required this.historia, required this.onLike});

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
          // ── Cabecera autor ──────────────────────────────────
          Padding(
            padding: AppSpacing.cardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IMAvatarWidget(
                  imageUrl: historia.autorAvatarUrl,
                  nombre: historia.autorNombre,
                  size: AppSpacing.avatarMd,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(historia.autorNombre,
                          style: AppTextStyles.labelLarge),
                      if (historia.relacionAutor != null)
                        Text(
                          historia.relacionAutor!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.gold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      Text(
                        IMDateUtils.fechaCorta(historia.fechaCreacion),
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Imagen si existe ────────────────────────────────
          if (historia.imagenUrl != null)
            IMNetworkImage(
              url: historia.imagenUrl!,
              width: double.infinity,
              height: 200,
            ),

          // ── Título ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Text(
              historia.titulo,
              style: AppTextStyles.headlineSmall,
            ),
          ),

          // ── Texto ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              historia.texto,
              style: AppTextStyles.bodyMedium.copyWith(
                height: 1.65,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // ── Footer: likes ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: onLike,
                  icon: const Icon(Icons.favorite_border,
                      size: 18, color: AppColors.textHint),
                  label: Text(
                    '${historia.likes}',
                    style: AppTextStyles.bodySmall,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
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
