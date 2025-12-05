import 'package:flutter/material.dart';
import 'app_theme_constants.dart';
import '../design_system/app_colors.dart';

class AppTheme {
  AppTheme._();

  // Legacy color constants for backward compatibility
  // These now reference the new AppColors system
  static Color get lightBackground => AppColors.lightBackground;
  static Color get lightSurface => AppColors.lightSurface;
  static Color get lightSurfaceVariant => AppColors.lightSurfaceVariant;
  static Color get lightTextPrimary => AppColors.lightTextPrimary;
  static Color get lightTextSecondary => AppColors.lightTextSecondary;
  static Color get lightTextTertiary => AppColors.lightTextTertiary;
  static Color get lightBorder => AppColors.lightBorder;
  static Color get lightDivider => AppColors.lightDivider;
  static Color get lightGold => AppColors.lightGold;
  static Color get lightGoldVariant => AppColors.lightGoldVariant;
  static Color get lightBrown => AppColors.lightBrown;
  static Color get lightBrownVariant => AppColors.lightBrownVariant;
  static Color get lightCrimson => AppColors.lightCrimson;
  static Color get lightCrimsonVariant => AppColors.lightCrimsonVariant;
  static Color get lightViolet => AppColors.lightViolet;
  static Color get lightVioletVariant => AppColors.lightVioletVariant;
  static Color get lightArcaneBlue => AppColors.lightArcaneBlue;
  static Color get lightIronGray => AppColors.lightIronGray;
  static Color get lightParchment => AppColors.lightParchment;

  static Color get darkBackground => AppColors.darkBackground;
  static Color get darkSurface => AppColors.darkSurface;
  static Color get darkSurfaceVariant => AppColors.darkSurfaceVariant;
  static Color get darkTextPrimary => AppColors.darkTextPrimary;
  static Color get darkTextSecondary => AppColors.darkTextSecondary;
  static Color get darkTextTertiary => AppColors.darkTextTertiary;
  static Color get darkBorder => AppColors.darkBorder;
  static Color get darkDivider => AppColors.darkDivider;
  static Color get darkCrimson => AppColors.darkCrimson;
  static Color get darkCrimsonGlow => AppColors.darkCrimsonGlow;
  static Color get darkViolet => AppColors.darkViolet;
  static Color get darkVioletGlow => AppColors.darkVioletGlow;
  static Color get darkArcaneBlue => AppColors.darkArcaneBlue;
  static Color get darkIronGray => AppColors.darkIronGray;
  static Color get darkObsidian => AppColors.darkObsidian;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: ColorScheme.light(
        primary: AppColors.lightGold,
        onPrimary: Colors.white,
        primaryContainer: AppColors.lightGoldVariant,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.lightBrown,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.lightBrownVariant,
        onSecondaryContainer: Colors.white,
        tertiary: AppColors.lightBrown,
        onTertiary: Colors.white,
        error: AppColors.errorLight,
        onError: Colors.white,
        errorContainer: AppColors.errorContainerLight,
        onErrorContainer: const Color(0xFF410002),
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        onSurfaceVariant: AppColors.lightTextSecondary,
        outline: AppColors.lightBorder,
        outlineVariant: AppColors.lightDivider,
        shadow: Colors.black.withOpacity(0.1),
        scrim: Colors.black.withOpacity(0.5),
        inverseSurface: AppColors.darkSurface,
        onInverseSurface: AppColors.darkTextPrimary,
        inversePrimary: AppColors.darkCrimson,
        surfaceTint: AppColors.lightGold.withOpacity(0.1),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: AppThemeConstants.elevation0,
        scrolledUnderElevation: AppThemeConstants.elevation2,
        centerTitle: true,
        shadowColor: Colors.black.withOpacity(0.08),
        titleTextStyle: TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: AppThemeConstants.fontSize20,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppColors.lightGold,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.lightGold,
          size: 24,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: AppThemeConstants.elevation2,
        shadowColor: Colors.black.withOpacity(AppThemeConstants.shadowOpacity),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          side: BorderSide(
            color: AppColors.lightBorder,
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
          backgroundColor: lightGold,
          foregroundColor: Colors.white,
          elevation: AppThemeConstants.elevation4,
          shadowColor: lightGold.withOpacity(0.3),
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
                return lightGoldVariant;
              }
              return lightGold;
            },
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightGold,
          side: BorderSide(
            color: lightGold,
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
                  color: lightGoldVariant,
                  width: 2,
                );
              }
              return BorderSide(
                color: lightGold,
                width: 1.5,
              );
            },
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightGold,
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
        selectedItemColor: lightGold,
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
        labelColor: lightGold,
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
            color: lightGold,
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
            color: lightGold,
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
        selectedColor: lightGold.withOpacity(0.2),
        secondarySelectedColor: lightBrown.withOpacity(0.2),
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
        color: lightGold,
        size: 24,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkCrimson,
        onPrimary: Colors.white,
        primaryContainer: AppColors.darkCrimsonGlow,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.darkViolet,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.darkVioletGlow,
        onSecondaryContainer: Colors.white,
        tertiary: AppColors.darkArcaneBlue,
        onTertiary: Colors.white,
        error: AppColors.errorDark,
        onError: Colors.white,
        errorContainer: AppColors.errorContainerDark,
        onErrorContainer: const Color(0xFFFFDAD6),
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        onSurfaceVariant: AppColors.darkTextSecondary,
        outline: AppColors.darkBorder,
        outlineVariant: AppColors.darkDivider,
        shadow: Colors.black.withOpacity(0.3),
        scrim: Colors.black.withOpacity(0.7),
        inverseSurface: AppColors.lightSurface,
        onInverseSurface: AppColors.lightTextPrimary,
        inversePrimary: AppColors.lightCrimson,
        surfaceTint: AppColors.darkCrimson.withOpacity(0.1),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: AppThemeConstants.elevation0,
        scrolledUnderElevation: AppThemeConstants.elevation2,
        centerTitle: true,
        shadowColor: Colors.black.withOpacity(0.3),
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: AppThemeConstants.fontSize20,
          fontWeight: AppThemeConstants.fontWeightSemiBold,
          letterSpacing: AppThemeConstants.letterSpacingNormal,
          fontFamily: AppThemeConstants.fontFamilyPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppColors.darkCrimsonGlow,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.darkCrimsonGlow,
          size: 24,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: AppThemeConstants.elevation4,
        shadowColor: Colors.black.withOpacity(AppThemeConstants.shadowOpacity * 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radius12),
          side: BorderSide(
            color: AppColors.darkBorder,
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

  // Legacy constants (for backward compatibility, default to dark)
  // Note: These are not const because they reference getters
  static Color get primaryDark => darkBackground;
  static Color get secondaryDark => darkSurface;
  // Light mode colors
  static Color get accentGoldLight => lightGold;
  static Color get accentDarkGoldLight => lightGoldVariant;
  static Color get accentBrownLight => lightBrown;
  // Dark mode colors (unchanged)
  static Color get accentGoldDark => darkCrimsonGlow;
  static Color get accentDarkGoldDark => darkCrimson;
  static Color get accentBrownDark => darkIronGray;
  // Legacy constants (for backward compatibility, default to dark)
  static Color get accentGold => darkCrimsonGlow;
  static Color get accentDarkGold => darkCrimson;
  static Color get accentCrimson => darkCrimson;
  static Color get accentBrown => darkIronGray;
  static Color get textPrimary => darkTextPrimary;
  static Color get textSecondary => darkTextSecondary;
  static Color get gold => darkCrimsonGlow;
  static Color get silver => darkTextSecondary;
  static Color get bronze => darkIronGray;
  
  // Helper functions to get theme-aware colors
  static Color getAccentGold(Brightness brightness) {
    return AppColors.getAccentPrimary(brightness);
  }
  
  static Color getAccentDarkGold(Brightness brightness) {
    return brightness == Brightness.light 
        ? AppColors.lightGoldDark 
        : AppColors.darkCrimsonDark;
  }
  
  static Color getAccentBrown(Brightness brightness) {
    return AppColors.getAccentSecondary(brightness);
  }
  
  // Helper functions that use BuildContext for easier widget usage
  static Color getAccentGoldFromContext(BuildContext context) {
    return AppColors.getAccentPrimaryFromContext(context);
  }
  
  static Color getAccentDarkGoldFromContext(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? AppColors.lightGoldDark 
        : AppColors.darkCrimsonDark;
  }
  
  static Color getAccentBrownFromContext(BuildContext context) {
    return AppColors.getAccentSecondaryFromContext(context);
  }
  
  static LinearGradient getGoldGradientFromContext(BuildContext context) {
    return getGoldGradient(Theme.of(context).brightness);
  }
  
  static LinearGradient getBrownGradientFromContext(BuildContext context) {
    return getBrownGradient(Theme.of(context).brightness);
  }
  
  static LinearGradient getMedievalGradientFromContext(BuildContext context) {
    return getMedievalGradient(Theme.of(context).brightness);
  }
  
  // Helper functions for background and surface colors
  static Color getPrimaryBackground(Brightness brightness) {
    return AppColors.getBackground(brightness);
  }
  
  static Color getSecondaryBackground(Brightness brightness) {
    return AppColors.getSurface(brightness);
  }
  
  static Color getTextPrimary(Brightness brightness) {
    return AppColors.getTextPrimary(brightness);
  }
  
  static Color getTextSecondary(Brightness brightness) {
    return AppColors.getTextSecondary(brightness);
  }
  
  static LinearGradient getBackgroundGradient(Brightness brightness) {
    if (brightness == Brightness.light) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.lightBackground, AppColors.lightSurface],
      );
    }
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.darkBackground, AppColors.darkSurface],
    );
  }
  
  // Helper functions that use BuildContext
  static Color getPrimaryBackgroundFromContext(BuildContext context) {
    return AppColors.getBackgroundFromContext(context);
  }
  
  static Color getSecondaryBackgroundFromContext(BuildContext context) {
    return AppColors.getSurfaceFromContext(context);
  }
  
  static Color getTextPrimaryFromContext(BuildContext context) {
    return AppColors.getTextPrimaryFromContext(context);
  }
  
  static Color getTextSecondaryFromContext(BuildContext context) {
    return AppColors.getTextSecondaryFromContext(context);
  }
  
  static LinearGradient getBackgroundGradientFromContext(BuildContext context) {
    return getBackgroundGradient(Theme.of(context).brightness);
  }

  static const LinearGradient darkGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.darkBackground, AppColors.darkSurface],
      );

  static LinearGradient getGoldGradient(Brightness brightness) {
    if (brightness == Brightness.light) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.lightGold, AppColors.lightGoldVariant],
      );
    }
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.darkCrimsonGlow, AppColors.darkCrimson],
    );
  }

  static LinearGradient getBrownGradient(Brightness brightness) {
    if (brightness == Brightness.light) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.lightBrown, AppColors.lightBrownVariant],
      );
    }
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.darkIronGray, AppColors.darkBackground],
    );
  }

  static LinearGradient getMedievalGradient(Brightness brightness) {
    if (brightness == Brightness.light) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.lightGold, AppColors.lightGoldVariant, AppColors.lightBrown],
      );
    }
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.darkCrimsonGlow, AppColors.darkCrimson, AppColors.darkIronGray],
    );
  }
  
  // Legacy gradients (for backward compatibility, default to dark)
  static const LinearGradient goldGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.darkCrimsonGlow, AppColors.darkCrimson],
      );

  static const LinearGradient brownGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.darkIronGray, AppColors.darkBackground],
      );

  static const LinearGradient medievalGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.darkCrimsonGlow, AppColors.darkCrimson, AppColors.darkIronGray],
      );

  static Color getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey;
      case 'rare':
        return AppColors.darkIronGray;
      case 'epic':
        return AppColors.darkCrimson;
      case 'legendary':
        return AppColors.darkCrimsonGlow;
      default:
        return Colors.grey;
    }
  }
}

