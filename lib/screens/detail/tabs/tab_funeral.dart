import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_utils.dart';

class TabFuneral extends StatelessWidget {
  final Fallecido fallecido;

  const TabFuneral({super.key, required this.fallecido});

  @override
  Widget build(BuildContext context) {
    final info = fallecido.infoFuneral;

    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        const SizedBox(height: AppSpacing.md),

        if (info == null)
          _buildSinInfo()
        else
          _buildInfoFuneral(info),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildSinInfo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
        child: Column(
          children: [
            const Icon(Icons.church_outlined, size: 56, color: AppColors.textHint),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No hay información disponible\nsobre el funeral',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoFuneral(InfoFuneral info) {
    return Column(
      children: [
        // Encabezado solemne
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg, horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          child: Column(
            children: [
              const Icon(Icons.church_outlined, color: Colors.white54, size: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Información del funeral',
                style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'D.E.P. ${fallecido.nombreCompleto}',
                style: AppTextStyles.esquelaCita.copyWith(color: Colors.white60),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Fecha y hora
        if (info.fechaHora != null)
          _InfoCard(
            icon: Icons.calendar_today_outlined,
            titulo: 'Fecha y hora',
            valor: IMDateUtils.fechaHora(info.fechaHora!),
            subtitulo: IMDateUtils.fechaCompleta(info.fechaHora!),
          ),

        // Lugar
        if (info.lugar != null)
          _InfoCard(
            icon: Icons.church_outlined,
            titulo: 'Lugar de la ceremonia',
            valor: info.lugar!,
            subtitulo: info.direccion != null
                ? '${info.direccion}${info.localidad != null ? ', ${info.localidad}' : ''}'
                : null,
          ),

        // Tanatorio
        if (info.tanatorio != null)
          _InfoCard(
            icon: Icons.home_outlined,
            titulo: 'Tanatorio',
            valor: info.tanatorio!,
          ),

        // Nota adicional
        if (info.notaAdicional != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.goldLight.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              border: Border.all(color: AppColors.goldLight, width: 0.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 18, color: AppColors.gold),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    info.notaAdicional!,
                    style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;
  final String? subtitulo;

  const _InfoCard({
    required this.icon,
    required this.titulo,
    required this.valor,
    this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.goldLight.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.gold),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo.toUpperCase(), style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(valor, style: AppTextStyles.bodyLarge),
                if (subtitulo != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitulo!, style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
