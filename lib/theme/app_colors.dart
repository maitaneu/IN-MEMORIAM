import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Paleta principal ──────────────────────────────────────────
  // Fondo muy claro, casi crema
  static const Color background = Color(0xFFF5F2ED);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEDE9E3);

  // Dorado apagado — acento elegante
  static const Color gold = Color(0xFFA48A60);
  static const Color goldLight = Color(0xFFD4B896);
  static const Color goldDark = Color(0xFF7A6240);

  // Textos
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6B6660);
  static const Color textHint = Color(0xFFB0A99F);

  // Bordes y divisores
  static const Color border = Color(0xFFDDD8D2);
  static const Color divider = Color(0xFFE8E4DF);

  // Estados
  static const Color error = Color(0xFF9B2335);
  static const Color success = Color(0xFF3D7A5A);
  static const Color pending = Color(0xFF8B6914);

  // Fondo oscuro para modales y overlays
  static const Color overlay = Color(0xCC1C1C1E);

  // Gradiente de portada
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0xCC000000)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
    colors: [Color(0x00000000), Color(0x44000000), Color(0xDD000000)],
  );
}
