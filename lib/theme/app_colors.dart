import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF4D41DF);
  static const Color primaryContainer = Color(0xFF675DF9);
  static const Color primarySoft = Color(0xFFEFEDFF);
  static const Color secondary = Color(0xFF006B5F);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Surface & Background
  static const Color background = Color(0xFFF9F9FF);
  static const Color surfaceBase = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFFFF9F2);
  static const Color surfaceContainerLow = Color(0xFFF0F3FF);
  static const Color surfaceContainer = Color(0xFFE7EEFF);
  static const Color surfaceContainerHighest = Color(0xFFD7E3FD);
  static const Color inverseSurface = Color(0xFF253145);
  static const Color borderSubtle = Color(0xFFE7EAF0);
  static const Color outlineVariant = Color(0xFFC7C4D8);
  static const Color tertiary = Color(0xFFA33631);

  // Text
  static const Color textPrimary = Color(0xFF243044);
  static const Color textSecondary = Color(0xFF667085);

  // Emotional Coupling
  static const Color tealAccent = Color(0xFF27B7A5); // Tenang / Calm
  static const Color tealSoft = Color(0xFFE4F8F4);

  static const Color coralAccent = Color(0xFFFF7A70); // Sedih / Sorrow
  static const Color coralSoft = Color(0xFFFFF0ED);

  static const Color yellowAccent = Color(0xFFFFC857); // Senang / Relief
  static const Color yellowSoft = Color(0xFFFFF7DF);

  static const Color blueAccent = Color(0xFF63A9F8); // Reflektif
  static const Color blueSoft = Color(0xFFEAF4FF);

  static const Color pinkAccent = Color(0xFFF29BC2); // Lelah / Care
  static const Color pinkSoft = Color(0xFFFFF0F6);

  // Safety & Feedback
  static const Color feedbackDanger = Color(0xFFC83F49); // Hotlines 119 only
  static const Color feedbackSuccess = Color(0xFF23856D);
  static const Color feedbackWarning = Color(0xFFA86708);
}
