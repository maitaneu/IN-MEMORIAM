import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/models.dart';
import '../../services/mock_data.dart';
import '../../theme/theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/widgets.dart';

class TanatorioScreen extends StatelessWidget {
  final String tanatorioId;

  const TanatorioScreen({super.key, required this.tanatorioId});

  @override
  Widget build(BuildContext context) {
    final tanatorio = MockData.tanatorioPorId(tanatorioId);

    if (tanatorio == null || tanatorio.datosTanatorio == null) {
      return _buildNotFound(context);
    }

    final datos = tanatorio.datosTanatorio!;
    final fallecidos = MockData.fallecidosDeTanatorio(tanatorioId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildHeroAppBar(context, tanatorio, datos),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),

                  // ── Descripción ──────────────────────────────
                  if (datos.descripcion != null) ...[
                    _buildSeccion(
                      icono: Icons.info_outline,
                      titulo: 'Sobre nosotros',
                      child: Text(
                        datos.descripcion!,
                        style: AppTextStyles.bodyMedium.copyWith(height: 1.7),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // ── Contacto ─────────────────────────────────
                  _buildSeccion(
                    icono: Icons.contact_phone_outlined,
                    titulo: 'Contacto',
                    child: Column(
                      children: [
                        _ContactTile(
                          icono: Icons.location_on_outlined,
                          etiqueta: 'Dirección',
                          valor: datos.direccion,
                          subtitulo: [tanatorio.localidad, tanatorio.provincia]
                              .where((s) => s != null)
                              .join(', '),
                        ),
                        if (datos.telefono != null)
                          _ContactTile(
                            icono: Icons.phone_outlined,
                            etiqueta: 'Teléfono',
                            valor: datos.telefono!,
                          ),
                        if (tanatorio.email.isNotEmpty)
                          _ContactTile(
                            icono: Icons.email_outlined,
                            etiqueta: 'Email',
                            valor: tanatorio.email,
                          ),
                        if (datos.web != null)
                          _ContactTile(
                            icono: Icons.language_outlined,
                            etiqueta: 'Web',
                            valor: datos.web!,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Mapa estático placeholder ─────────────────
                  if (datos.latitud != null && datos.longitud != null) ...[
                    _buildSeccion(
                      icono: Icons.map_outlined,
                      titulo: 'Localización',
                      child: _MapPlaceholder(
                        latitud: datos.latitud!,
                        longitud: datos.longitud!,
                        direccion: datos.direccion,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // ── Servicios ─────────────────────────────────
                  if (datos.servicios.isNotEmpty) ...[
                    _buildSeccion(
                      icono: Icons.checklist_outlined,
                      titulo: 'Servicios',
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: datos.servicios
                            .map((s) => _ServicioChip(servicio: s))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // ── Publicaciones gestionadas ─────────────────
                  if (fallecidos.isNotEmpty) ...[
                    _buildSeccion(
                      icono: Icons.article_outlined,
                      titulo: 'Publicaciones recientes',
                      child: Column(
                        children: fallecidos
                            .map((f) => _FallecidoTile(fallecido: f))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // ── Datos legales ─────────────────────────────
                  _buildSeccion(
                    icono: Icons.gavel_outlined,
                    titulo: 'Datos legales',
                    child: Column(
                      children: [
                        _ContactTile(
                          icono: Icons.business_outlined,
                          etiqueta: 'Razón social',
                          valor: datos.razonSocial,
                        ),
                        _ContactTile(
                          icono: Icons.badge_outlined,
                          etiqueta: 'CIF',
                          valor: datos.cif,
                        ),
                        _ContactTile(
                          icono: Icons.calendar_today_outlined,
                          etiqueta: 'Miembro desde',
                          valor: IMDateUtils.fechaLarga(tanatorio.fechaRegistro),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero con logo y nombre ──────────────────────────────────────
  SliverAppBar _buildHeroAppBar(
      BuildContext context, Usuario tanatorio, DatosTanatorio datos) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.surface,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              // Logo / avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldLight.withOpacity(0.2),
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
                clipBehavior: Clip.hardEdge,
                child: datos.logoUrl != null
                    ? IMNetworkImage(url: datos.logoUrl, fit: BoxFit.cover)
                    : const Icon(Icons.business, size: 36, color: AppColors.gold),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(datos.razonSocial, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 4),
              // Badge verificado
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.goldLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.gold),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified, size: 12, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text('Funeraria verificada',
                        style: AppTextStyles.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.surface),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.business_outlined,
                size: 64, color: AppColors.textHint),
            const SizedBox(height: AppSpacing.md),
            Text('Funeraria no encontrada',
                style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sección con cabecera ──────────────────────────────────────────
Widget _buildSeccion({
  required IconData icono,
  required String titulo,
  required Widget child,
}) {
  return Container(
    width: double.infinity,
    padding: AppSpacing.cardPadding,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      border: Border.all(color: AppColors.border, width: 0.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icono, size: 15, color: AppColors.gold),
          const SizedBox(width: 6),
          Text(titulo.toUpperCase(), style: AppTextStyles.caption),
        ]),
        const SizedBox(height: AppSpacing.sm),
        const Divider(color: AppColors.divider),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    ),
  );
}

// ── Fila de contacto ─────────────────────────────────────────────
class _ContactTile extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;
  final String? subtitulo;

  const _ContactTile({
    required this.icono,
    required this.etiqueta,
    required this.valor,
    this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 16, color: AppColors.textHint),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiqueta, style: AppTextStyles.labelSmall),
                Text(valor,
                    style: AppTextStyles.bodyMedium),
                if (subtitulo != null && subtitulo!.isNotEmpty)
                  Text(subtitulo!, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chip de servicio ─────────────────────────────────────────────
class _ServicioChip extends StatelessWidget {
  final String servicio;
  const _ServicioChip({required this.servicio});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.goldLight.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline,
              size: 12, color: AppColors.gold),
          const SizedBox(width: 5),
          Text(servicio,
              style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.goldDark, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ── Placeholder de mapa ───────────────────────────────────────────
class _MapPlaceholder extends StatelessWidget {
  final double latitud;
  final double longitud;
  final String direccion;

  const _MapPlaceholder({
    required this.latitud,
    required this.longitud,
    required this.direccion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(color: AppColors.border),
        color: AppColors.surfaceVariant,
      ),
      child: Stack(
        children: [
          // Imagen estática de mapa vía API pública
          Image.network(
            'https://static-maps.yandex.ru/1.x/?lang=es_ES'
            '&ll=$longitud,$latitud&z=15&l=map&size=650,300'
            '&pt=$longitud,$latitud,pm2rdm',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.map_outlined,
                      size: 36, color: AppColors.textHint),
                  const SizedBox(height: 8),
                  Text(direccion,
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          // Pin superpuesto
          const Center(
            child: Icon(Icons.location_on, size: 32, color: AppColors.error),
          ),
          // Etiqueta de coordenadas
          Positioned(
            bottom: 6, right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${latitud.toStringAsFixed(4)}, ${longitud.toStringAsFixed(4)}',
                style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white, fontSize: 9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tile de fallecido gestionado ──────────────────────────────────
class _FallecidoTile extends StatelessWidget {
  final Fallecido fallecido;
  const _FallecidoTile({required this.fallecido});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/fallecido/${fallecido.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: IMNetworkImage(
                  url: fallecido.fotoPrincipalUrl, width: 48, height: 48),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fallecido.nombreCompleto,
                      style: AppTextStyles.labelLarge),
                  Text(
                    IMDateUtils.rangoAnios(
                        fallecido.fechaNacimiento, fallecido.fechaFallecimiento),
                    style:
                        AppTextStyles.bodySmall.copyWith(color: AppColors.gold),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
