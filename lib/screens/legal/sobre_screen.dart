import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Sobre IN MEMORIAM'),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SizedBox(height: AppSpacing.lg),

          // ── Logo y versión ─────────────────────────────────
          Center(
            child: Column(
              children: [
                IMLogo(size: 100, conTexto: false),
                const SizedBox(height: AppSpacing.md),
                Text('IN MEMORIAM', style: AppTextStyles.displayMedium),
                const SizedBox(height: 4),
                Text('Versión 1.0.0 (demo)', style: AppTextStyles.bodySmall),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Misión ─────────────────────────────────────────
          _Bloque(
            icon: Icons.favorite_border,
            titulo: 'Nuestra misión',
            contenido:
                'IN MEMORIAM nació con la vocación de digitalizar el duelo de una manera digna, respetuosa e íntima. Creemos que los recuerdos merecen un espacio donde perdurar, y las familias merecen un lugar donde unirse aunque estén lejos.',
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Valores ────────────────────────────────────────
          _Bloque(
            icon: Icons.balance_outlined,
            titulo: 'Nuestros valores',
            contenido: '',
            widget: Column(
              children: [
                _ValorTile(
                  emoji: '🕊️',
                  titulo: 'Dignidad',
                  descripcion: 'Cada publicación se trata con el máximo respeto.',
                ),
                _ValorTile(
                  emoji: '🔒',
                  titulo: 'Privacidad',
                  descripcion: 'Solo publicamos lo que la familia ha autorizado.',
                ),
                _ValorTile(
                  emoji: '🌍',
                  titulo: 'Comunidad',
                  descripcion: 'Conectamos a personas que comparten el dolor de una pérdida.',
                ),
                _ValorTile(
                  emoji: '✅',
                  titulo: 'Moderación',
                  descripcion: 'Todo el contenido es revisado antes de publicarse.',
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Contacto ───────────────────────────────────────
          _Bloque(
            icon: Icons.email_outlined,
            titulo: 'Contacto',
            contenido:
                '• General: hola@inmemoriam.es\n'
                '• Soporte: soporte@inmemoriam.es\n'
                '• Privacidad: privacidad@inmemoriam.es\n'
                '• Tanatorios: partners@inmemoriam.es',
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Links ──────────────────────────────────────────
          Container(
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
                  const Icon(Icons.link, size: 16, color: AppColors.gold),
                  const SizedBox(width: 8),
                  Text('ENLACES'.toUpperCase(), style: AppTextStyles.caption),
                ]),
                const SizedBox(height: AppSpacing.sm),
                _LinkTile(
                  label: 'Aviso legal y Privacidad',
                  onTap: () => context.push('/legal'),
                ),
                _LinkTile(
                  label: 'Ayuda y preguntas frecuentes',
                  onTap: () => context.push('/ayuda'),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          Center(
            child: Text(
              '© 2026 IN MEMORIAM S.L. Todos los derechos reservados.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _Bloque extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String contenido;
  final Widget? widget;

  const _Bloque({
    required this.icon,
    required this.titulo,
    required this.contenido,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Icon(icon, size: 16, color: AppColors.gold),
            const SizedBox(width: 8),
            Text(titulo.toUpperCase(), style: AppTextStyles.caption),
          ]),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.divider),
          const SizedBox(height: AppSpacing.sm),
          if (contenido.isNotEmpty)
            Text(contenido, style: AppTextStyles.bodyMedium.copyWith(height: 1.7)),
          if (widget != null) widget!,
        ],
      ),
    );
  }
}

class _ValorTile extends StatelessWidget {
  final String emoji;
  final String titulo;
  final String descripcion;

  const _ValorTile({
    required this.emoji,
    required this.titulo,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: AppTextStyles.labelLarge),
                Text(descripcion, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LinkTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gold)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textHint),
      onTap: onTap,
    );
  }
}
