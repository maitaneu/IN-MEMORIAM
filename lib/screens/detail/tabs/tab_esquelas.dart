import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/models.dart';
import '../../../services/app_state.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/widgets.dart';

class TabEsquelas extends StatefulWidget {
  final String fallecidoId;

  const TabEsquelas({super.key, required this.fallecidoId});

  @override
  State<TabEsquelas> createState() => _TabEsquelasState();
}

class _TabEsquelasState extends State<TabEsquelas>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<List<Esquela>> _future;

  @override
  void initState() {
    super.initState();
    _future = context
        .read<AppState>()
        .fallecidosService
        .getEsquelas(widget.fallecidoId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Esquela>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.gold));
        }
        final lista = snap.data ?? [];
        if (lista.isEmpty) {
          return _buildVacio();
        }
        return ListView.separated(
          padding: AppSpacing.screenPadding,
          itemCount: lista.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (_, i) => _EsquelaCard(esquela: lista[i]),
        );
      },
    );
  }

  Widget _buildVacio() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.article_outlined, size: 52, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.md),
          Text('Aún no hay esquelas publicadas', style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }
}

class _EsquelaCard extends StatelessWidget {
  final Esquela esquela;

  const _EsquelaCard({required this.esquela});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen opcional
          if (esquela.imagenUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusMedium)),
              child: IMNetworkImage(
                url: esquela.imagenUrl,
                height: 180,
                width: double.infinity,
              ),
            ),

          Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Autor + fecha
                Row(
                  children: [
                    if (esquela.autorEsTanatorio)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.goldLight.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.gold),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.business, size: 12, color: AppColors.gold),
                            const SizedBox(width: 4),
                            Text('Tanatorio', style: AppTextStyles.caption.copyWith(fontSize: 10)),
                          ],
                        ),
                      )
                    else
                      const Icon(Icons.person_outline, size: 16, color: AppColors.textHint),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        esquela.autorNombre,
                        style: AppTextStyles.labelMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      IMDateUtils.fechaCorta(esquela.fechaPublicacion),
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.sm),
                const Divider(color: AppColors.divider),
                const SizedBox(height: AppSpacing.sm),

                // Título
                Text(esquela.titulo, style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.sm),

                // Texto de la esquela
                Text(
                  esquela.texto,
                  style: AppTextStyles.esquelaCita,
                ),

                // Firmantes
                if (esquela.firmantes.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Firmado por', style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  ...esquela.firmantes.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text('• $f', style: AppTextStyles.bodySmall),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
