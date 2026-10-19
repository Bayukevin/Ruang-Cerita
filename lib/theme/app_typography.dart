import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  static TextStyle get display => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.64,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineLg => GoogleFonts.plusJakartaSans(
        fontSize: 26,
        height: 34 / 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.39,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMd => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        height: 30 / 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.22,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSm => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        height: 26 / 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.09,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLg => GoogleFonts.plusJakartaSans(
        fontSize: 17,
        height: 26 / 17,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMd => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySm => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        height: 22 / 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelLg => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.16,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMd => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.14,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelSm => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        height: 18 / 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.24,
        color: AppColors.textSecondary,
      );
}
