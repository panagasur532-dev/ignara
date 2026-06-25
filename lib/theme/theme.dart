import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LCColors {
  // Brand
  static const primary = Color(0xFF00E5A0);
  static const primaryDim = Color(0xFF00C48A);
  static const primaryDark = Color(0xFF009E72);

  // Backgrounds
  static const bg = Color(0xFF0A0A0F);
  static const surface = Color(0xFF13131A);
  static const surfaceAlt = Color(0xFF0F0F16);
  static const surfaceHigh = Color(0xFF1C1C26);

  // Borders
  static const border = Color(0xFF1E1E2A);
  static const borderHigh = Color(0xFF2A2A38);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8888AA);
  static const textDim = Color(0xFF555568);

  // Accent palette
  static const blue = Color(0xFF6B8CFF);
  static const blueDim = Color(0xFF4A6FE0);
  static const gold = Color(0xFFFFB800);
  static const red = Color(0xFFFF6B6B);
  static const purple = Color(0xFFC77DFF);
  static const orange = Color(0xFFFF8C42);

  // Semantic
  static const success = Color(0xFF00E5A0);
  static const warning = Color(0xFFFFB800);
  static const danger = Color(0xFFFF6B6B);
  static const info = Color(0xFF6B8CFF);

  // Rank colors
  static const gold1 = Color(0xFFFFB800);
  static const silver2 = Color(0xFFA0A8B8);
  static const bronze3 = Color(0xFFCD7F32);
}

class LCTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: LCColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: LCColors.primary,
      secondary: LCColors.blue,
      surface: LCColors.surface,
      error: LCColors.danger,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w600, color: LCColors.textPrimary),
      displayMedium: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w500, color: LCColors.textPrimary),
      headlineLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w500, color: LCColors.textPrimary),
      headlineMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500, color: LCColors.textPrimary),
      titleLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: LCColors.textPrimary),
      titleMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: LCColors.textPrimary),
      bodyLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: LCColors.textPrimary),
      bodyMedium: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: LCColors.textPrimary),
      bodySmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: LCColors.textSecondary),
      labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: LCColors.textDim, letterSpacing: 1.5),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: LCColors.bg,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: LCColors.textPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: LCColors.bg,
      selectedItemColor: LCColors.primary,
      unselectedItemColor: LCColors.textDim,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: const CardThemeData(
      color: LCColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        side: BorderSide(color: LCColors.border, width: 1),
      ),
    ),
    dividerTheme: const DividerThemeData(color: LCColors.border, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LCColors.surfaceAlt,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: LCColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: LCColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: LCColors.primary),
      ),
      labelStyle: const TextStyle(color: LCColors.textSecondary, fontSize: 13),
      hintStyle: const TextStyle(color: LCColors.textDim, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LCColors.primary,
        foregroundColor: LCColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) =>
        s.contains(WidgetState.selected) ? LCColors.primary : Colors.transparent),
      checkColor: WidgetStateProperty.all(LCColors.bg),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(color: LCColors.border, width: 1.5),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
