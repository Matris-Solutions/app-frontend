import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color green = Color(0xFF4A7C59);
  static const Color greenDark = Color(0xFF28553A);
  static const Color greenPale = Color(0xFFEAF1EB);
  static const Color gold = Color(0xFFC4A46B);
  static const Color goldPale = Color(0xFFF5EFE3);
  static const Color parchment = Color(0xFFFDFBF7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1E2B23);
  static const Color muted = Color(0xFF68756D);
  static const Color line = Color(0xFFE8E7E1);
  static const Color background = Color(0xFFE6E8E3);
}

enum LiturgicalSeason { advent, christmas, ordinary, lent, triduum, easter, pentecost }

class LiturgicalCalendar {
  static DateTime calculateEaster(int year) {
    int a = year % 19, b = year ~/ 100, c = year % 100;
    int d = b ~/ 4, e = b % 4, f = (b + 8) ~/ 25, g = (b - f + 1) ~/ 3;
    int h = (19 * a + b - d - g + 15) % 30;
    int i = c ~/ 4, k = c % 4, l = (32 + 2 * e + 2 * i - h - k) % 7;
    int m = (a + 11 * h + 22 * l) ~/ 451;
    int month = (h + l - 7 * m + 114) ~/ 31;
    int day = ((h + l - 7 * m + 114) % 31) + 1;
    return DateTime(year, month, day);
  }

  static LiturgicalSeason getSeason(DateTime date) {
    int year = date.year;
    DateTime christmas = DateTime(year, 12, 25);
    
    int daysToSubtract = christmas.weekday == DateTime.sunday ? 28 : 21 + christmas.weekday;
    DateTime adventStart = christmas.subtract(Duration(days: daysToSubtract));
    
    DateTime easter = calculateEaster(year);
    DateTime ashWednesday = easter.subtract(const Duration(days: 46));
    DateTime pentecost = easter.add(const Duration(days: 49));

    if (date.isAfter(adventStart.subtract(const Duration(days: 1))) && date.isBefore(christmas)) {
      return LiturgicalSeason.advent;
    } else if (date.month == 12 && date.day >= 25 || date.isBefore(DateTime(year, 1, 13))) {
      return LiturgicalSeason.christmas;
    } else if (date.isAfter(ashWednesday.subtract(const Duration(days: 1))) && date.isBefore(easter.subtract(const Duration(days: 3)))) {
      return LiturgicalSeason.lent;
    } else if (date.isAfter(easter.subtract(const Duration(days: 4))) && date.isBefore(easter)) {
      return LiturgicalSeason.triduum;
    } else if (date.year == pentecost.year && date.month == pentecost.month && date.day == pentecost.day) {
      return LiturgicalSeason.pentecost;
    } else if (date.isAfter(easter.subtract(const Duration(days: 1))) && date.isBefore(pentecost)) {
      return LiturgicalSeason.easter;
    }
    return LiturgicalSeason.ordinary;
  }
}

class ParishTheme {
  static ThemeData getTheme(DateTime date) {
    // LiturgicalSeason season = LiturgicalCalendar.getSeason(date);
    // Keep it simple for the UI conversion: Use the green theme
    Color primaryColor = AppColors.green;
    
    final TextTheme baseTextTheme = GoogleFonts.dmSansTextTheme();

    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: AppColors.parchment,
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.newsreader(
          color: AppColors.ink,
          fontSize: 35,
          height: 1.05,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.025 * 35,
        ),
        displayMedium: GoogleFonts.newsreader(
          color: AppColors.ink,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.newsreader(
          color: AppColors.ink,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.newsreader(
          color: AppColors.ink,
          fontSize: 21,
          height: 1.15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: AppColors.ink,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.ink,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.ink,
        elevation: 0,
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: AppColors.gold,
        surface: AppColors.white,
      ),
      useMaterial3: true,
    );
  }
}
