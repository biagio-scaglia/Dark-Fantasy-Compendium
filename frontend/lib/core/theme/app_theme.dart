import 'package:flutter/material.dart';

class AppTheme {
  // Medieval Color Palette - Marrone e Dorato
  static const Color primaryDark = Color(0xFF2C1810);
  static const Color secondaryDark = Color(0xFF3D2818);
  static const Color accentBrown = Color(0xFF6B4423);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentDarkGold = Color(0xFFB8941F);
  static const Color accentLightGold = Color(0xFFF4D03F);
  static const Color accentCrimson = Color(0xFF8B4513);
  static const Color textPrimary = Color(0xFFE8D5B7);
  static const Color textSecondary = Color(0xFFC9A87C);
  static const Color gold = Color(0xFFD4AF37);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFF8B6914);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accentGold,
      scaffoldBackgroundColor: primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        secondary: accentBrown,
        tertiary: accentDarkGold,
        surface: secondaryDark,
        onPrimary: primaryDark,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        error: accentCrimson,
      ),
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: accentGold,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          fontFamily: 'OldLondon',
        ),
        iconTheme: IconThemeData(color: accentGold),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: secondaryDark,
        elevation: 8,
        shadowColor: accentGold.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: accentGold, width: 2),
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: accentGold,
          fontSize: 36,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          fontFamily: 'OldLondon',
        ),
        displayMedium: TextStyle(
          color: accentGold,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.8,
          fontFamily: 'OldLondon',
        ),
        displaySmall: TextStyle(
          color: accentGold,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          fontFamily: 'OldLondon',
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          fontFamily: 'OldLondon',
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: textSecondary,
          fontSize: 12,
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGold,
          foregroundColor: primaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          shadowColor: accentGold.withOpacity(0.5),
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return 2;
              if (states.contains(MaterialState.hovered)) return 8;
              return 6;
            },
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentGold,
          side: const BorderSide(color: accentGold, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ).copyWith(
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return const BorderSide(color: accentGold, width: 2.5);
              }
              if (states.contains(MaterialState.hovered)) {
                return const BorderSide(color: accentGold, width: 2.5);
              }
              return const BorderSide(color: accentGold, width: 2);
            },
          ),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: secondaryDark,
        selectedItemColor: accentGold,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentGold),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentGold, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentGold, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
      ),
    );
  }

  // Gradient presets
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, secondaryDark],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGold, accentDarkGold],
  );

  static const LinearGradient brownGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentBrown, primaryDark],
  );
  
  static const LinearGradient medievalGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentGold, accentDarkGold, accentBrown],
  );

  // Rarity colors
  static Color getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey;
      case 'rare':
        return accentBrown;
      case 'epic':
        return accentDarkGold;
      case 'legendary':
        return accentGold;
      default:
        return Colors.grey;
    }
  }
}


