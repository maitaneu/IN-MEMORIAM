import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/models.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/widgets.dart';

class TabInfo extends StatelessWidget {
  final Fallecido fallecido;

  const TabInfo({super.key, required this.fallecido});

  @override
  Widget build(BuildContext context) {
    final f = fallecido;

    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        const SizedBox(height: AppSpacing.md),

        // ── Datos personales ─────────────────────────────────
        _SectionCard(
          titulo: 'Datos personales',
          icon: Icons.person_outline,
          children: [
            _InfoRow(
              icono: Icons.cake_outlined,
              etiqueta: 'Fecha de nacimiento',
              valor: IMDateUtils.fechaLarga(f.fechaNacimiento),
            ),
            if (f.lugarNacimiento != null)
              _InfoRow(
                icono: Icons.location_on_outlined,
                etiqueta: 'Lugar de nacimiento',
                valor: f.lugarNacimiento!,
              ),
            _InfoRow(
              icono: Icons.favorite_border,
              etiqueta: 'Fecha de fallecimiento',
              valor: IMDateUtils.fechaLarga(f.fechaFallecimiento),
            ),
            _InfoRow(
              icono: Icons.timelapse,
              etiqueta: 'Edad',
              valor: '${f.edad} años',
            ),
            if (f.lugarResidencia != null)
              _InfoRow(
                icono: Icons.home_outlined,
                etiqueta: 'Última residencia',
                valor: f.lugarResidencia!,
              )
            else
              _InfoRow(
                icono: Icons.location_on_outlined,
                etiqueta: 'Localidad',
                valor: f.ubicacion,
              ),
            _InfoRow(
              icono: Icons.flag_outlined,
              etiqueta: 'País',
              valor: f.pais,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Biografía ────────────────────────────────────────
        if (f.resumenBiografia != null) ...[
          _SectionCard(
            titulo: 'Sobre ${f.nombre}',
            icon: Icons.menu_book_outlined,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  f.resumenBiografia!,
                  style: AppTextStyles.bodyLarge.copyWith(height: 1.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // ── Galería de fotos ─────────────────────────────────
        if (f.fotoGaleriaUrls.isNotEmpty) ...[
          _SectionCard(
            titulo: 'Galería de fotos',
            icon: Icons.photo_library_outlined,
            children: [
              const SizedBox(height: AppSpacing.sm),
              _GaleriaGrid(urls: f.fotoGaleriaUrls),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // ── Vídeos ───────────────────────────────────────────
        if (f.videoUrls.isNotEmpty) ...[
          _SectionCard(
            titulo: 'Vídeos',
            icon: Icons.play_circle_outline,
            children: [
              const SizedBox(height: AppSpacing.sm),
              ...f.videoUrls.map((url) => _VideoTile(url: url)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // ── Etiquetas ────────────────────────────────────────
        if (f.etiquetas.isNotEmpty) ...[
          _SectionCard(
            titulo: 'Etiquetas',
            icon: Icons.label_outline,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: f.etiquetas
                    .map(
                      (e) => Chip(
                        label: Text(e),
                        backgroundColor:
                            AppColors.goldLight.withOpacity(0.2),
                        side: const BorderSide(color: AppColors.goldLight),
                        labelStyle: AppTextStyles.labelMedium,
                      ),
                    )
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

// ── SectionCard ────────────────────────────────────────────────────────

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

// ── InfoRow ────────────────────────────────────────────────────────────

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

// ── GaleriaGrid con visor al pulsar ──────────────────────────────────

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
      itemBuilder: (context, i) => GestureDetector(
        onTap: () => _abrirVisor(context, urls, i),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          child: IMNetworkImage(url: urls[i]),
        ),
      ),
    );
  }

  void _abrirVisor(BuildContext context, List<String> urls, int inicial) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, __, ___) =>
            _VisorFotos(urls: urls, inicial: inicial),
      ),
    );
  }
}

// ── Visor de fotos a pantalla completa ────────────────────────────────

class _VisorFotos extends StatefulWidget {
  final List<String> urls;
  final int inicial;

  const _VisorFotos({required this.urls, required this.inicial});

  @override
  State<_VisorFotos> createState() => _VisorFotosState();
}

class _VisorFotosState extends State<_VisorFotos> {
  late PageController _ctrl;
  late int _actual;

  @override
  void initState() {
    super.initState();
    _actual = widget.inicial;
    _ctrl = PageController(initialPage: widget.inicial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          '${_actual + 1} / ${widget.urls.length}',
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _ctrl,
        itemCount: widget.urls.length,
        onPageChanged: (i) => setState(() => _actual = i),
        itemBuilder: (_, i) => Center(
          child: InteractiveViewer(
            child: IMNetworkImage(
              url: widget.urls[i],
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}

// ── VideoTile ─────────────────────────────────────────────────────────

class _VideoTile extends StatelessWidget {
  final String url;

  const _VideoTile({required this.url});

  /// Extrae el ID de un vídeo de YouTube de distintos formatos de URL.
  String? _youtubeId(String url) {
    final patterns = [
      RegExp(r'youtube\.com/watch\?v=([^&]+)'),
      RegExp(r'youtu\.be/([^?]+)'),
      RegExp(r'youtube\.com/embed/([^?]+)'),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(url);
      if (m != null) return m.group(1);
    }
    return null;
  }

  String _etiquetaUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceFirst('www.', '');
    } catch (_) {
      return url;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ytId = _youtubeId(url);
    final thumbnailUrl = ytId != null
        ? 'https://img.youtube.com/vi/$ytId/hqdefault.jpg'
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          // Miniatura o ícono genérico
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusMedium),
              bottomLeft: Radius.circular(AppSpacing.radiusMedium),
            ),
            child: thumbnailUrl != null
                ? Stack(
                    children: [
                      IMNetworkImage(
                          url: thumbnailUrl, width: 100, height: 68),
                      const Positioned.fill(
                        child: Center(
                          child: Icon(Icons.play_circle_fill,
                              color: Colors.white, size: 32),
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: 100,
                    height: 68,
                    color: AppColors.textPrimary,
                    child: const Icon(Icons.play_circle_outline,
                        color: Colors.white54, size: 36),
                  ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ytId != null ? 'Vídeo de YouTube' : 'Vídeo',
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _etiquetaUrl(url),
                    style: AppTextStyles.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // Botón abrir
          IconButton(
            icon: const Icon(Icons.open_in_new,
                size: 18, color: AppColors.gold),
            tooltip: 'Abrir vídeo',
            onPressed: () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
    );
  }
}
