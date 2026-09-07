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

  @override
  void initState() {
    super.initState();
    _future = context
        .read<AppState>()
        .fallecidosService
        .getPosts(widget.fallecidoId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = context.read<AppState>();

    return FutureBuilder<List<PostRecuerdo>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.gold));
        }
        final lista = snap.data ?? [];

        return ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Botón para añadir recuerdo
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
                    const Icon(Icons.photo_library_outlined, size: 52, color: AppColors.textHint),
                    const SizedBox(height: AppSpacing.md),
                    Text('Sé el primero en compartir un recuerdo', style: AppTextStyles.bodyLarge,
                        textAlign: TextAlign.center),
                  ],
                ),
              )
            else
              ...lista.map((p) => _PostCard(post: p)),

            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }

  void _mostrarDialogoRecuerdo(BuildContext context, AppState state) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge)),
      ),
      builder: (ctx) => Padding(
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
            Text('Compartir un recuerdo', style: AppTextStyles.headlineMedium),
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
                  );
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Recuerdo enviado — pendiente de revisión'),
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
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostRecuerdo post;

  const _PostCard({required this.post});

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
          // Cabecera autor
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
                Row(
                  children: [
                    const Icon(Icons.favorite_border, size: 16, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text('${post.likes}', style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),
          ),

          // Imagen
          if (post.imagenesUrls.isNotEmpty)
            IMNetworkImage(
              url: post.imagenesUrls.first,
              width: double.infinity,
              height: 220,
            ),

          // Texto
          if (post.texto != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
              child: Text(post.texto!, style: AppTextStyles.bodyMedium.copyWith(height: 1.6)),
            ),
        ],
      ),
    );
  }
}
