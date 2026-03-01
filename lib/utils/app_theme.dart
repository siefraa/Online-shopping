import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF1B5E20);
  static const primaryLight = Color(0xFF4CAF50);
  static const accent = Color(0xFFFF8F00);
  static const accentRed = Color(0xFFE53935);
  static const background = Color(0xFFF5F3EE);
  static const cardBg = Colors.white;
  static const textDark = Color(0xFF1C1C1E);
  static const textGrey = Color(0xFF8A8A8A);
  static const textLight = Color(0xFFABABAB);
  static const divider = Color(0xFFE5E5EA);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFB800);
  static const error = Color(0xFFFF3B30);
  static const adminPrimary = Color(0xFF1A237E);
  static const adminAccent = Color(0xFF3F51B5);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary, background: AppColors.background),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.dmSansTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.textDark),
        displayMedium: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textDark),
        headlineMedium: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark),
        headlineSmall: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textDark),
        titleLarge: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
        bodyLarge: GoogleFonts.dmSans(fontSize: 15, color: AppColors.textDark),
        bodyMedium: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textDark),
        bodySmall: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textGrey),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background, elevation: 0, scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.dmSans(color: AppColors.textLight, fontSize: 14),
      ),
      cardTheme: CardThemeData(elevation: 0, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    );
  }

  static ThemeData get admin {
    return light.copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.adminPrimary, primary: AppColors.adminPrimary),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.adminPrimary, elevation: 0,
        titleTextStyle: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.adminPrimary, foregroundColor: Colors.white, elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

String formatTZS(double amount) {
  final val = amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  return 'TZS $val';
}

String timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}