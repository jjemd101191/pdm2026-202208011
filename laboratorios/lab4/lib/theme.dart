import 'package:flutter/material.dart';

import 'models/tarea.dart';

/// Paleta de TaskU (tomada del mockup del equipo).
const Color kIndigo = Color(0xFF4F46E5);
const Color kIndigoDark = Color(0xFF4338CA);
const Color kIndigoSoft = Color(0xFFEEF2FF);
const Color kInk = Color(0xFF0F172A);
const Color kMuted = Color(0xFF64748B);
const Color kLine = Color(0xFFE8EDF3);
const Color kSoftBg = Color(0xFFF8FAFC);
const Color kRed = Color(0xFFDC2626);
const Color kRedSoft = Color(0xFFFEE2E2);
const Color kGreen = Color(0xFF10B981);
const Color kGreenSoft = Color(0xFFECFDF5);
const Color kGreenDark = Color(0xFF047857);
const Color kAmber = Color(0xFFF59E0B);
const Color kAmberSoft = Color(0xFFFEF3C7);

/// Iconos y colores por categoría, solo para la capa visual.
extension CategoriaTareaUi on CategoriaTarea {
  IconData get icono => switch (this) {
    CategoriaTarea.universidad => Icons.school_outlined,
    CategoriaTarea.trabajo => Icons.work_outline,
    CategoriaTarea.personal => Icons.person_outline,
    CategoriaTarea.hogar => Icons.home_outlined,
  };

  Color get color => switch (this) {
    CategoriaTarea.universidad => kIndigo,
    CategoriaTarea.trabajo => const Color(0xFF0EA5E9),
    CategoriaTarea.personal => const Color(0xFFEC4899),
    CategoriaTarea.hogar => const Color(0xFFB45309),
  };

  Color get colorSuave => switch (this) {
    CategoriaTarea.universidad => kIndigoSoft,
    CategoriaTarea.trabajo => const Color(0xFFE0F2FE),
    CategoriaTarea.personal => const Color(0xFFFCE7F3),
    CategoriaTarea.hogar => kAmberSoft,
  };
}

ThemeData buildTaskuTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: kIndigo);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Color(0xFF334155)),
      titleTextStyle: TextStyle(
        color: kInk,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Color(0xFFE0E7FF),
      height: 66,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: kInk,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSoftBg,
      hintStyle: const TextStyle(color: kMuted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kLine),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kLine),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kIndigo, width: 1.4),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: kSoftBg,
      selectedColor: kIndigoSoft,
      side: const BorderSide(color: kLine),
      labelStyle: const TextStyle(fontSize: 13, color: kInk),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
