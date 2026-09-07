import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/widgets.dart';

class TabInfo extends StatelessWidget {
  final Fallecido fallecido;

  const TabInfo({super.key, required this.fallecido});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        const SizedBox(height: AppSpacing.md),

        // Datos personales
        _SectionCard(
          titulo: 'Datos personales',
          icon: Icons.person_outline,
          children: [
            _InfoRow(
              icono: Icons.cake_outlined,
              etiqueta: 'Fecha de nacimiento',
              valor: IMDateUtils.fechaLarga(fallecido.fechaNacimiento),
            ),
            _InfoRow(
              icono: Icons.favorite_border,
              etiqueta: 'Fecha de fallecimiento',
              valor: IMDateUtils.fechaLarga(fallecido.fechaFallecimiento),
            ),
            _InfoRow(
              icono: Icons.timelapse,
              etiqueta: 'Edad',
              valor: '${fallecido.edad} años',
            ),
            _InfoRow(
              icono: Icons.location_on_outlined,
              etiqueta: 'Localidad',
              valor: fallecido.ubicacion,
            ),
            _InfoRow(
              icono: Icons.flag_outlined,
              etiqueta: 'País',
              valor: fallecido.pais,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // Biografía
        if (fallecido.resumenBiografia != null) ...[
          _SectionCard(
            titulo: 'Sobre ${fallecido.nombre}',
            icon: Icons.menu_book_outlined,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  fallecido.resumenBiografia!,
                  style: AppTextStyles.bodyLarge.copyWith(height: 1.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // Galería de fotos
        if (fallecido.fotoGaleriaUrls.isNotEmpty) ...[
          _SectionCard(
            titulo: 'Galería de fotos',
            icon: Icons.photo_library_outlined,
            children: [
              const SizedBox(height: AppSpacing.sm),
              _GaleriaGrid(urls: fallecido.fotoGaleriaUrls),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // Etiquetas
        if (fallecido.etiquetas.isNotEmpty) ...[
          _SectionCard(
            titulo: 'Etiquetas',
            icon: Icons.label_outline,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: fallecido.etiquetas
                    .map((e) => Chip(
                          label: Text(e),
                          backgroundColor: AppColors.goldLight.withOpacity(0.2),
                          side: const BorderSide(color: AppColors.goldLight),
                          labelStyle: AppTextStyles.labelMedium,
                        ))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String titulo;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.titulo,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.gold),
              const SizedBox(width: 8),
              Text(titulo.toUpperCase(), style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.divider),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;

  const _InfoRow({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 16, color: AppColors.textHint),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiqueta, style: AppTextStyles.labelSmall),
                const SizedBox(height: 2),
                Text(valor, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GaleriaGrid extends StatelessWidget {
  final List<String> urls;

  const _GaleriaGrid({required this.urls});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: urls.length,
      itemBuilder: (context, i) => ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        child: IMNetworkImage(url: urls[i]),
      ),
    );
  }
}
