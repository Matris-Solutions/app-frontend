import 'package:flutter/material.dart';

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
    LiturgicalSeason season = LiturgicalCalendar.getSeason(date);
    
    Color primaryColor = const Color(0xFF4A7C59); 
    Color secondaryColor = const Color(0xFFC4A46B); 
    
    switch (season) {
      case LiturgicalSeason.advent:
      case LiturgicalSeason.lent:
        primaryColor = const Color(0xFF5E2D79); 
        break;
      case LiturgicalSeason.christmas:
      case LiturgicalSeason.easter:
        primaryColor = const Color(0xFFD4AF37); 
        secondaryColor = const Color(0xFFF9F6EE);
        break;
      case LiturgicalSeason.triduum:
      case LiturgicalSeason.pentecost:
        primaryColor = const Color(0xFFB31B1B); 
        break;
      case LiturgicalSeason.ordinary:
        primaryColor = const Color(0xFFC4A46B); 
        break;
    }

    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFFFDFBF7),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
      ),
      useMaterial3: true,
    );
  }
}