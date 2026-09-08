import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/models.dart';
import '../../services/mock_data.dart';
import '../../theme/theme.dart';
import '../../utils/date_utils.dart';

/// Card de feed estilo Instagram: foto de fondo con gradiente,
/// nombre grande, fechas y localidad superpuestos.
class FeedCard extends StatelessWidget {
  final Fallecido fallecido;

  const FeedCard({super.key, required this.fallecido});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/fallecido/${fallecido.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        height: AppSpacing.feedCardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Foto de fondo ─────────────────────────────────
            _buildBackground(),

            // ── Gradiente oscuro inferior ─────────────────────
            Container(decoration: const BoxDecoration(gradient: AppColors.heroGradient)),

            // ── Contenido superpuesto ─────────────────────────
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: _buildInfo(),
            ),

            // ── Etiqueta de localidad (esquina superior) ──────
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              child: _buildLocationBadge(context),
            ),

            // ── Badge de tanatorio (debajo de localidad) ──────
            if (fallecido.tanatorioId != null)
              Positioned(
                top: AppSpacing.md + 32,
                left: AppSpacing.md,
                child: _buildTanatorioBadge(context),
              ),

            // ── Indicador de esquelas disponibles ─────────────
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: _buildEsquelasBadge(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (fallecido.fotoPrincipalUrl != null) {
      return CachedNetworkImage(
        imageUrl: fallecido.fotoPrincipalUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.surfaceVariant,
          highlightColor: AppColors.border,
          child: Container(color: AppColors.surfaceVariant),
        ),
        errorWidget: (_, __, ___) => _buildPlaceholderBg(),
      );
    }
    return _buildPlaceholderBg();
  }

  Widget _buildPlaceholderBg() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(Icons.person, size: 80, color: AppColors.textHint),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nombre
        Text(
          fallecido.nombreCompleto,
          style: AppTextStyles.cardName.copyWith(fontSize: 22),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // Rango de años
        Text(
          IMDateUtils.rangoAnios(fallecido.fechaNacimiento, fallecido.fechaFallecimiento),
          style: AppTextStyles.cardSubtitle.copyWith(
            fontSize: 15,
            color: AppColors.goldLight,
          ),
        ),
        const SizedBox(height: 8),

        // Fechas + edad
        Row(
          children: [
            const Icon(Icons.cake_outlined, size: 14, color: Colors.white60),
            const SizedBox(width: 4),
            Text(
              IMDateUtils.fechaCorta(fallecido.fechaNacimiento),
              style: AppTextStyles.cardSubtitle,
            ),
            const SizedBox(width: 12),
            const Icon(Icons.favorite_border, size: 14, color: Colors.white60),
            const SizedBox(width: 4),
            Text(
              IMDateUtils.fechaCorta(fallecido.fechaFallecimiento),
              style: AppTextStyles.cardSubtitle,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white30),
              ),
              child: Text(
                '${fallecido.edad} años',
                style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),

        // Funeral próximo si existe
        if (fallecido.infoFuneral?.fechaHora != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.church_outlined, size: 13, color: Colors.white54),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Funeral: ${IMDateUtils.fechaHora(fallecido.infoFuneral!.fechaHora!)}',
                  style: AppTextStyles.cardSubtitle.copyWith(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLocationBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            fallecido.ubicacion,
            style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTanatorioBadge(BuildContext context) {
    final tanatorio = MockData.tanatorioPorId(fallecido.tanatorioId!);
    if (tanatorio == null) return const SizedBox.shrink();
    final nombre = tanatorio.datosTanatorio?.razonSocial ?? tanatorio.nombreCompleto;
    return GestureDetector(
      onTap: () => context.push('/tanatorio/${fallecido.tanatorioId}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.75),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified, size: 11, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              nombre,
              style: AppTextStyles.cardSubtitle.copyWith(
                  fontSize: 11, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEsquelasBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.article_outlined, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            'Ver esquelas',
            style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
