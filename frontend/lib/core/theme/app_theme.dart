import 'package:flutter/material.dart';
import 'app_theme_constants.dart';

class AppTheme {
  AppTheme._();

  static const Color lightBackground = Color(0xFFF5F1E8);
  static const Color lightSurface = Color(0xFFFFFBF5);
  static const Color lightSurfaceVariant = Color(0xFFF0EBE0);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF4A4A4A);
  static const Color lightTextTertiary = Color(0xFF6B6B6B);
  static const Color lightBorder = Color(0xFFD4D0C8);
  static const Color lightDivider = Color(0xFFE5E0D8);
  static const Color lightCrimson = Color(0xFF8B1538);
  static const Color lightCrimsonVariant = Color(0xFFA01D42);
  static const Color lightViolet = Color(0xFF6B2C91);
  static const Color lightVioletVariant = Color(0xFF7D3AA3);
  static const Color lightArcaneBlue = Color(0xFF4A7FB8);
  static const Color lightIronGray = Color(0xFF5A5A5A);
  static const Color lightParchment = Color(0xFFF9F6F0);

  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkSurfaceVariant = Color(0xFF252525);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFCCCCCC);
  static const Color darkTextTertiary = Color(0xFF999999);
  static const Color darkBorder = Color(0xFF333333);
  static const Color darkDivider = Color(0xFF2A2A2A);
  static const Color darkCrimson = Color(0xFFC41E3A);
  static const Color darkCrimsonGlow = Color(0xFFE63950);
  static const Color darkViolet = Color(0xFF8B4FC7);
  static const Color darkVioletGlow = Color(0xFFA66DD9);
  static const Color darkArcaneBlue = Color(0xFF4A90E2);
  static const Color darkIronGray = Color(0xFF3A3A3A);
  static const Color darkObsidian = Color(0xFF151515);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: ColorScheme.light(
        primary: lightCrimson,
        onPrimary: Colors.white,
        primaryContainer: lightCrimsonVariant,
        onPrimaryContainer: Colors.white,
        secondary: lightViolet,
        onSecondary: Colors.white,
        secondaryContainer: lightVioletVariant,
        onSecondaryContainer: Colors.white,
        tertiary: lightArcaneBlue,
        onTertiary: Colors.white,
        error: const Color(0xFFBA1A1A),
        onError: Colors.white,
        errorContainer: const Color(0xFFFFDAD6),
        onErrorContainer: const Color(0xFF410002),
        surface: lightSurface,
        onSurface: lightTextPrimary,
        onSurfaceVariant: lightTextSecondary,
        outline: lightBorder,
        outlineVariant: lightDivider,
        shadow: Colors.black.withOpacity(0.1),
        scrim: Colors.black.withOpacity(0.5),
        inverseSurface: darkSurface,
        onInverseSurface: darkTextPrimary,
        inversePrimary: darkCrimson,
        surfaceTint: lightCrimson.withOpacity(0.1),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightTextPrimary,
        elevation: AppThemeConstants.elevation0,
        scrolledUnderElevation: AppThemeConstants.elevation2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize20,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        iconTheme: IconThemeData(
          color: lightCrimson,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: lightCrimson,
          size: 24,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: AppThemeConstants.elevation2,
        shadowColor: Colors.black.withOpacity(AppThemeConstants.shadowOpacity),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          side: BorderSide(
            color: lightBorder,
            width: 1,
          ),
        ),
        margin: EdgeInsets.all(AppThemeConstants.spacing8),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize48,
          fontWeight: AppThemeConstants.fontWeightBold,
          letterSpacing: AppThemeConstants.letterSpacingTight,
          height: AppThemeConstants.lineHeightTight,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        displayMedium: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize40,
          fontWeight: AppThemeConstants.fontWeightBold,
          letterSpacing: AppThemeConstants.letterSpacingTight,
          height: AppThemeConstants.lineHeightTight,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        displaySmall: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize36,
          fontWeight: AppThemeConstants.fontWeightBold,
          letterSpacing: AppThemeConstants.letterSpacingTight,
          height: AppThemeConstants.lineHeightTight,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        headlineLarge: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize32,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        headlineMedium: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize28,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        headlineSmall: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize24,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        titleLarge: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize20,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        titleMedium: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize18,
          fontWeight: AppThemeConstants.fontWeightMedium,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        titleSmall: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize16,
          fontWeight: AppThemeConstants.fontWeightMedium,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        bodyLarge: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize16,
          fontWeight: AppThemeConstants.fontWeightRegular,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightRelaxed,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        bodyMedium: TextStyle(
          color: lightTextSecondary,
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightRegular,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightRelaxed,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        bodySmall: TextStyle(
          color: lightTextTertiary,
          fontSize: AppThemeConstants.fontSize12,
          fontWeight: AppThemeConstants.fontWeightRegular,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        labelLarge: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightMedium,
          letterSpacing: AppThemeConstants.letterSpacingWide,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        labelMedium: TextStyle(
          color: lightTextSecondary,
          fontSize: AppThemeConstants.fontSize12,
          fontWeight: AppThemeConstants.fontWeightMedium,
          letterSpacing: AppThemeConstants.letterSpacingWide,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        labelSmall: TextStyle(
          color: lightTextTertiary,
          fontSize: AppThemeConstants.fontSize10,
          fontWeight: AppThemeConstants.fontWeightMedium,
          letterSpacing: AppThemeConstants.letterSpacingWide,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightCrimson,
          foregroundColor: Colors.white,
          elevation: AppThemeConstants.elevation4,
          shadowColor: lightCrimson.withOpacity(0.3),
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConstants.spacing24,
            vertical: AppThemeConstants.spacing12,
          ),
          minimumSize: Size(0, AppThemeConstants.minTapTargetSize),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          ),
          textStyle: TextStyle(
            fontSize: AppThemeConstants.fontSize16,
            fontWeight: AppThemeConstants.fontWeightMedium,
            letterSpacing: AppThemeConstants.letterSpacingWide,
            fontFamily: AppThemeConstants.fontFamilyPrimary,
          ),
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) return AppThemeConstants.elevation0;
              if (states.contains(MaterialState.pressed)) return AppThemeConstants.elevation2;
              if (states.contains(MaterialState.hovered)) return AppThemeConstants.elevation8;
              return AppThemeConstants.elevation4;
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return lightIronGray.withOpacity(0.3);
              }
              if (states.contains(MaterialState.pressed)) {
                return lightCrimsonVariant;
              }
              return lightCrimson;
            },
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightCrimson,
          side: BorderSide(
            color: lightCrimson,
            width: 1.5,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConstants.spacing24,
            vertical: AppThemeConstants.spacing12,
          ),
          minimumSize: Size(0, AppThemeConstants.minTapTargetSize),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          ),
          textStyle: TextStyle(
            fontSize: AppThemeConstants.fontSize16,
            fontWeight: AppThemeConstants.fontWeightMedium,
            letterSpacing: AppThemeConstants.letterSpacingWide,
            fontFamily: AppThemeConstants.fontFamilyPrimary,
          ),
        ).copyWith(
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return BorderSide(
                  color: lightBorder,
                  width: 1,
                );
              }
              if (states.contains(MaterialState.pressed)) {
                return BorderSide(
                  color: lightCrimsonVariant,
                  width: 2,
                );
              }
              return BorderSide(
                color: lightCrimson,
                width: 1.5,
              );
            },
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightCrimson,
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConstants.spacing16,
            vertical: AppThemeConstants.spacing12,
          ),
          minimumSize: Size(0, AppThemeConstants.minTapTargetSize),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeConstants.radius8),
          ),
          textStyle: TextStyle(
            fontSize: AppThemeConstants.fontSize16,
            fontWeight: AppThemeConstants.fontWeightMedium,
            letterSpacing: AppThemeConstants.letterSpacingWide,
            fontFamily: AppThemeConstants.fontFamilyPrimary,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: lightCrimson,
        unselectedItemColor: lightTextTertiary,
        selectedLabelStyle: TextStyle(
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          fontSize: AppThemeConstants.fontSize12,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: AppThemeConstants.fontWeightRegular,
          fontSize: AppThemeConstants.fontSize12,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: AppThemeConstants.elevation8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: lightCrimson,
        unselectedLabelColor: lightTextTertiary,
        labelStyle: TextStyle(
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightRegular,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: lightCrimson,
            width: 2,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceVariant,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeConstants.spacing16,
          vertical: AppThemeConstants.spacing16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: lightBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: lightBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: lightCrimson,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: const Color(0xFFBA1A1A),
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: const Color(0xFFBA1A1A),
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: lightBorder,
            width: 1,
          ),
        ),
        labelStyle: TextStyle(
          color: lightTextSecondary,
          fontSize: AppThemeConstants.fontSize14,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        hintStyle: TextStyle(
          color: lightTextTertiary,
          fontSize: AppThemeConstants.fontSize14,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: lightDivider,
        thickness: 1,
        space: AppThemeConstants.spacing16,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeConstants.spacing16,
          vertical: AppThemeConstants.spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius8),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightSurfaceVariant,
        deleteIconColor: lightTextSecondary,
        disabledColor: lightSurfaceVariant.withOpacity(0.5),
        selectedColor: lightCrimson.withOpacity(0.2),
        secondarySelectedColor: lightViolet.withOpacity(0.2),
        padding: EdgeInsets.symmetric(
          horizontal: AppThemeConstants.spacing12,
          vertical: AppThemeConstants.spacing8,
        ),
        labelStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightRegular,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        secondaryLabelStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightRegular,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius8),
        ),
      ),
      iconTheme: IconThemeData(
        color: lightTextPrimary,
        size: 24,
      ),
      primaryIconTheme: IconThemeData(
        color: lightCrimson,
        size: 24,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.dark(
        primary: darkCrimson,
        onPrimary: Colors.white,
        primaryContainer: darkCrimsonGlow,
        onPrimaryContainer: Colors.white,
        secondary: darkViolet,
        onSecondary: Colors.white,
        secondaryContainer: darkVioletGlow,
        onSecondaryContainer: Colors.white,
        tertiary: darkArcaneBlue,
        onTertiary: Colors.white,
        error: const Color(0xFFFF5449),
        onError: Colors.white,
        errorContainer: const Color(0xFF93000A),
        onErrorContainer: const Color(0xFFFFDAD6),
        surface: darkSurface,
        onSurface: darkTextPrimary,
        onSurfaceVariant: darkTextSecondary,
        outline: darkBorder,
        outlineVariant: darkDivider,
        shadow: Colors.black.withOpacity(0.3),
        scrim: Colors.black.withOpacity(0.7),
        inverseSurface: lightSurface,
        onInverseSurface: lightTextPrimary,
        inversePrimary: lightCrimson,
        surfaceTint: darkCrimson.withOpacity(0.1),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkTextPrimary,
        elevation: AppThemeConstants.elevation0,
        scrolledUnderElevation: AppThemeConstants.elevation2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize20,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        iconTheme: IconThemeData(
          color: darkCrimsonGlow,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: darkCrimsonGlow,
          size: 24,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: AppThemeConstants.elevation4,
        shadowColor: Colors.black.withOpacity(AppThemeConstants.shadowOpacity * 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          side: BorderSide(
            color: darkBorder,
            width: 1,
          ),
        ),
        margin: EdgeInsets.all(AppThemeConstants.spacing8),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize48,
          fontWeight: AppThemeConstants.fontWeightBold,
          letterSpacing: AppThemeConstants.letterSpacingTight,
          height: AppThemeConstants.lineHeightTight,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        displayMedium: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize40,
          fontWeight: AppThemeConstants.fontWeightBold,
          letterSpacing: AppThemeConstants.letterSpacingTight,
          height: AppThemeConstants.lineHeightTight,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        displaySmall: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize36,
          fontWeight: AppThemeConstants.fontWeightBold,
          letterSpacing: AppThemeConstants.letterSpacingTight,
          height: AppThemeConstants.lineHeightTight,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        headlineLarge: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize32,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        headlineMedium: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize28,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        headlineSmall: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize24,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        titleLarge: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize20,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        titleMedium: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize18,
          fontWeight: AppThemeConstants.fontWeightMedium,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        titleSmall: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize16,
          fontWeight: AppThemeConstants.fontWeightMedium,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        bodyLarge: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize16,
          fontWeight: AppThemeConstants.fontWeightRegular,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightRelaxed,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        bodyMedium: TextStyle(
          color: darkTextSecondary,
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightRegular,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightRelaxed,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        bodySmall: TextStyle(
          color: darkTextTertiary,
          fontSize: AppThemeConstants.fontSize12,
          fontWeight: AppThemeConstants.fontWeightRegular,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        labelLarge: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightMedium,
          letterSpacing: AppThemeConstants.letterSpacingWide,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        labelMedium: TextStyle(
          color: darkTextSecondary,
          fontSize: AppThemeConstants.fontSize12,
          fontWeight: AppThemeConstants.fontWeightMedium,
          letterSpacing: AppThemeConstants.letterSpacingWide,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        labelSmall: TextStyle(
          color: darkTextTertiary,
          fontSize: AppThemeConstants.fontSize10,
          fontWeight: AppThemeConstants.fontWeightMedium,
          letterSpacing: AppThemeConstants.letterSpacingWide,
          height: AppThemeConstants.lineHeightNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkCrimson,
          foregroundColor: Colors.white,
          elevation: AppThemeConstants.elevation4,
          shadowColor: darkCrimsonGlow.withOpacity(AppThemeConstants.glowOpacity),
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConstants.spacing24,
            vertical: AppThemeConstants.spacing12,
          ),
          minimumSize: Size(0, AppThemeConstants.minTapTargetSize),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          ),
          textStyle: TextStyle(
            fontSize: AppThemeConstants.fontSize16,
            fontWeight: AppThemeConstants.fontWeightMedium,
            letterSpacing: AppThemeConstants.letterSpacingWide,
            fontFamily: AppThemeConstants.fontFamilyPrimary,
          ),
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) return AppThemeConstants.elevation0;
              if (states.contains(MaterialState.pressed)) return AppThemeConstants.elevation2;
              if (states.contains(MaterialState.hovered)) return AppThemeConstants.elevation8;
              return AppThemeConstants.elevation4;
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return darkIronGray.withOpacity(0.3);
              }
              if (states.contains(MaterialState.pressed)) {
                return darkCrimsonGlow;
              }
              return darkCrimson;
            },
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkCrimsonGlow,
          side: BorderSide(
            color: darkCrimson,
            width: 1.5,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConstants.spacing24,
            vertical: AppThemeConstants.spacing12,
          ),
          minimumSize: Size(0, AppThemeConstants.minTapTargetSize),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          ),
          textStyle: TextStyle(
            fontSize: AppThemeConstants.fontSize16,
            fontWeight: AppThemeConstants.fontWeightMedium,
            letterSpacing: AppThemeConstants.letterSpacingWide,
            fontFamily: AppThemeConstants.fontFamilyPrimary,
          ),
        ).copyWith(
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return BorderSide(
                  color: darkBorder,
                  width: 1,
                );
              }
              if (states.contains(MaterialState.pressed)) {
                return BorderSide(
                  color: darkCrimsonGlow,
                  width: 2,
                );
              }
              if (states.contains(MaterialState.hovered)) {
                return BorderSide(
                  color: darkCrimsonGlow,
                  width: 2,
                );
              }
              return BorderSide(
                color: darkCrimson,
                width: 1.5,
              );
            },
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkCrimsonGlow,
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConstants.spacing16,
            vertical: AppThemeConstants.spacing12,
          ),
          minimumSize: Size(0, AppThemeConstants.minTapTargetSize),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeConstants.radius8),
          ),
          textStyle: TextStyle(
            fontSize: AppThemeConstants.fontSize16,
            fontWeight: AppThemeConstants.fontWeightMedium,
            letterSpacing: AppThemeConstants.letterSpacingWide,
            fontFamily: AppThemeConstants.fontFamilyPrimary,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkCrimsonGlow,
        unselectedItemColor: darkTextTertiary,
        selectedLabelStyle: TextStyle(
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          fontSize: AppThemeConstants.fontSize12,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: AppThemeConstants.fontWeightRegular,
          fontSize: AppThemeConstants.fontSize12,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: AppThemeConstants.elevation8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: darkCrimsonGlow,
        unselectedLabelColor: darkTextTertiary,
        labelStyle: TextStyle(
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightRegular,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: darkCrimsonGlow,
            width: 2,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeConstants.spacing16,
          vertical: AppThemeConstants.spacing16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: darkBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: darkBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: darkCrimsonGlow,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: const Color(0xFFFF5449),
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: const Color(0xFFFF5449),
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          borderSide: BorderSide(
            color: darkBorder,
            width: 1,
          ),
        ),
        labelStyle: TextStyle(
          color: darkTextSecondary,
          fontSize: AppThemeConstants.fontSize14,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        hintStyle: TextStyle(
          color: darkTextTertiary,
          fontSize: AppThemeConstants.fontSize14,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: darkDivider,
        thickness: 1,
        space: AppThemeConstants.spacing16,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeConstants.spacing16,
          vertical: AppThemeConstants.spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius8),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceVariant,
        deleteIconColor: darkTextSecondary,
        disabledColor: darkSurfaceVariant.withOpacity(0.5),
        selectedColor: darkCrimson.withOpacity(0.3),
        secondarySelectedColor: darkViolet.withOpacity(0.3),
        padding: EdgeInsets.symmetric(
          horizontal: AppThemeConstants.spacing12,
          vertical: AppThemeConstants.spacing8,
        ),
        labelStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightRegular,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        secondaryLabelStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: AppThemeConstants.fontSize14,
          fontWeight: AppThemeConstants.fontWeightRegular,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius8),
        ),
      ),
      iconTheme: IconThemeData(
        color: darkTextPrimary,
        size: 24,
      ),
      primaryIconTheme: IconThemeData(
        color: darkCrimsonGlow,
        size: 24,
      ),
    );
  }

  static BoxShadow getGlowShadow(Color color) {
    return BoxShadow(
      color: color.withOpacity(AppThemeConstants.glowOpacity),
      blurRadius: AppThemeConstants.glowBlurRadius,
      spreadRadius: AppThemeConstants.glowSpreadRadius,
    );
  }

  static BoxShadow getSoftShadow(Color color) {
    return BoxShadow(
      color: color.withOpacity(AppThemeConstants.shadowOpacity),
      blurRadius: AppThemeConstants.shadowBlurRadius,
      spreadRadius: AppThemeConstants.shadowSpreadRadius,
    );
  }

  static List<BoxShadow> getAccentGlow(Color color) {
    return [
      BoxShadow(
        color: color.withOpacity(AppThemeConstants.glowOpacity * 0.5),
        blurRadius: AppThemeConstants.glowBlurRadius * 2,
        spreadRadius: AppThemeConstants.glowSpreadRadius,
      ),
      BoxShadow(
        color: color.withOpacity(AppThemeConstants.glowOpacity),
        blurRadius: AppThemeConstants.glowBlurRadius,
        spreadRadius: 0,
      ),
    ];
  }

  static const Color primaryDark = darkBackground;
  static const Color secondaryDark = darkSurface;
  static const Color accentGold = darkCrimsonGlow;
  static const Color accentDarkGold = darkCrimson;
  static const Color accentCrimson = darkCrimson;
  static const Color accentBrown = darkIronGray;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color gold = darkCrimsonGlow;
  static const Color silver = darkTextSecondary;
  static const Color bronze = darkIronGray;

  static const LinearGradient darkGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [darkBackground, darkSurface],
      );

  static const LinearGradient goldGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [darkCrimsonGlow, darkCrimson],
      );

  static const LinearGradient brownGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [darkIronGray, darkBackground],
      );

  static const LinearGradient medievalGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [darkCrimsonGlow, darkCrimson, darkIronGray],
      );

  static Color getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey;
      case 'rare':
        return darkIronGray;
      case 'epic':
        return darkCrimson;
      case 'legendary':
        return darkCrimsonGlow;
      default:
        return Colors.grey;
    }
  }
}
