import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Logo completo: símbolo + texto "IN MEMORIAM" (PNG con ambos).
/// Usado en login, splash y pantallas de presentación.
class IMLogo extends StatelessWidget {
  final double size;
  final Color? colorFallback;

  const IMLogo({
    super.key,
    this.size = 200,
    this.colorFallback,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_inmemoriam.png',
      width: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * 0.6,
          height: size * 0.6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorFallback ?? AppColors.gold,
          ),
          child: Center(
            child: Text('🌷', style: TextStyle(fontSize: size * 0.3)),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'IN MEMORIAM',
          style: AppTextStyles.headlineSmall.copyWith(
            letterSpacing: 2,
            color: colorFallback ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Solo el símbolo (sin texto), para el AppBar del feed y espacios reducidos.
/// Usa logo_inmemoriam_icon.png.
class IMLogoIcon extends StatelessWidget {
  final double size;
  final Color? colorFallback;

  const IMLogoIcon({
    super.key,
    this.size = 32,
    this.colorFallback,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_inmemoriam_icon.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Text(
        '🌷',
        style: TextStyle(fontSize: size * 0.85),
      ),
    );
  }
}

/// Versión horizontal: icono solo + texto "IN MEMORIAM" en código (para AppBar).
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
          'assets/images/logo_inmemoriam_icon.png',
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Text(
            '🌷',
            style: TextStyle(fontSize: iconSize * 0.85),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'IN MEMORIAM',
          style: AppTextStyles.logoAppBar(
            fontSize: iconSize * 0.68,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
