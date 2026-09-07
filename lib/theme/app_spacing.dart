import 'package:flutter/material.dart';

/// Espaciados y dimensiones consistentes en toda la app.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Padding horizontal de pantalla
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: md, vertical: md);

  static const EdgeInsets cardPadding =
      EdgeInsets.all(md);

  // Radio de esquinas
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 20.0;
  static const double radiusXL = 28.0;

  static BorderRadius get borderRadiusSm =>
      BorderRadius.circular(radiusSmall);
  static BorderRadius get borderRadiusMd =>
      BorderRadius.circular(radiusMedium);
  static BorderRadius get borderRadiusLg =>
      BorderRadius.circular(radiusLarge);

  // Altura de botones estándar
  static const double buttonHeight = 48.0;

  // Altura del card de feed
  static const double feedCardHeight = 380.0;

  // Avatar sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXL = 80.0;
}
