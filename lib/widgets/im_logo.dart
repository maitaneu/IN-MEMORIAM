import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Logo oficial de IN MEMORIAM.
/// Usa el asset PNG cuando está disponible; si no, muestra el fallback de texto.
class IMLogo extends StatelessWidget {
  final double size;
  final bool conTexto;
  final Color? colorFallback;

  const IMLogo({
    super.key,
    this.size = 48,
    this.conTexto = false,
    this.colorFallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo_inmemoriam.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _fallback(),
        ),
        if (conTexto) ...[
          const SizedBox(height: 8),
          _textoLogo(),
        ],
      ],
    );
  }

  Widget _fallback() {
    // Mientras no esté el PNG, muestra un tulipán esquematizado
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorFallback ?? AppColors.textPrimary,
      ),
      child: Center(
        child: Text(
          '🌷',
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }

  Widget _textoLogo() {
    return Text(
      'IN MEMORIAM',
      style: AppTextStyles.headlineSmall.copyWith(
        letterSpacing: 2,
        color: colorFallback ?? AppColors.textPrimary,
      ),
    );
  }
}

/// Versión horizontal: icono + texto lado a lado (para AppBar)
class IMLogoHorizontal extends StatelessWidget {
  final double iconSize;
  final Color? color;

  const IMLogoHorizontal({
    super.key,
    this.iconSize = 28,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo_inmemoriam.png',
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Text(
            '🌷',
            style: TextStyle(fontSize: iconSize * 0.85),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'IN MEMORIAM',
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: iconSize * 0.72,
            letterSpacing: 1,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
