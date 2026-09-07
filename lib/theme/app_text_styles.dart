import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Serif — para nombres, títulos solemnes ─────────────────────
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineLarge => GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineMedium => GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get headlineSmall => GoogleFonts.playfairDisplay(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  // Itálica serif — para citas y esquelas
  static TextStyle get esquelaCita => GoogleFonts.playfairDisplay(
        fontSize: 15,
        fontStyle: FontStyle.italic,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  // ── Sans-serif — para texto de cuerpo e interfaz ──────────────
  static TextStyle get bodyLarge => GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get labelLarge => GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get labelMedium => GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      );

  static TextStyle get labelSmall => GoogleFonts.lato(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textHint,
        letterSpacing: 0.5,
      );

  // Uppercase — para etiquetas y categorías
  static TextStyle get caption => GoogleFonts.lato(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.gold,
        letterSpacing: 1.2,
      );

  // Nombre del fallecido sobre foto (blanco)
  static TextStyle get cardName => GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1.2,
        shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
      );

  static TextStyle get cardSubtitle => GoogleFonts.lato(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.white70,
        shadows: [Shadow(color: Colors.black45, blurRadius: 3)],
      );

  // Botones
  static TextStyle get button => GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      );
}
