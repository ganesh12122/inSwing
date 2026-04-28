import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0C4DA2);
  static const Color secondaryColor = Color(0xFF0E9A77);
  static const Color accentColor = Color(0xFFF78D1E);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color successColor = Color(0xFF10B981);
  static const Color infoColor = Color(0xFF2F7DD8);

  static const Color darkPrimaryColor = Color(0xFF3B82F6);
  static const Color darkSecondaryColor = Color(0xFF34D399);
  static const Color darkAccentColor = Color(0xFFFBBF24);
  static const Color darkErrorColor = Color(0xFFF87171);
  static const Color darkWarningColor = Color(0xFFFBBF24);
  static const Color darkSuccessColor = Color(0xFF34D399);
  static const Color darkInfoColor = Color(0xFF60A5FA);

  static const Color backgroundColor = Color(0xFFF4F7FB);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFD7E0EB);

  static const Color darkBackgroundColor = Color(0xFF111827);
  static const Color darkSurfaceColor = Color(0xFF1F2937);
  static const Color darkCardColor = Color(0xFF374151);
  static const Color darkDividerColor = Color(0xFF374151);

  static const Color textPrimaryColor = Color(0xFF0D1C33);
  static const Color textSecondaryColor = Color(0xFF4E5F79);
  static const Color textDisabledColor = Color(0xFF9CA3AF);

  static const Color darkTextPrimaryColor = Color(0xFFF9FAFB);
  static const Color darkTextSecondaryColor = Color(0xFF9CA3AF);
  static const Color darkTextDisabledColor = Color(0xFF6B7280);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        iconTheme: const IconThemeData(color: textPrimaryColor),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.sora(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: textPrimaryColor,
        ),
        displayMedium: GoogleFonts.sora(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: textPrimaryColor,
        ),
        displaySmall: GoogleFonts.sora(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: textPrimaryColor,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleLarge: GoogleFonts.sora(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleMedium: GoogleFonts.sora(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleSmall: GoogleFonts.sora(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        bodyLarge: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimaryColor,
        ),
        bodyMedium: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimaryColor,
        ),
        bodySmall: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondaryColor,
        ),
        labelLarge: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        labelMedium: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textSecondaryColor,
        ),
        labelSmall: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textDisabledColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textSecondaryColor,
        ),
        hintStyle: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textDisabledColor,
        ),
        errorStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: errorColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        selectedLabelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: primaryColor.withValues(alpha: 0.1),
        labelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: dividerColor),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      colorScheme: ColorScheme.dark(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        surface: darkSurfaceColor,
        error: darkErrorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimaryColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurfaceColor,
        foregroundColor: darkTextPrimaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: darkTextPrimaryColor,
        ),
        iconTheme: const IconThemeData(color: darkTextPrimaryColor),
      ),
      cardTheme: CardTheme(
        color: darkCardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimaryColor,
          side: const BorderSide(color: darkPrimaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.sora(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: darkTextPrimaryColor,
        ),
        displayMedium: GoogleFonts.sora(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: darkTextPrimaryColor,
        ),
        displaySmall: GoogleFonts.sora(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: darkTextPrimaryColor,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: darkTextPrimaryColor,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: darkTextPrimaryColor,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkTextPrimaryColor,
        ),
        titleLarge: GoogleFonts.sora(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: darkTextPrimaryColor,
        ),
        titleMedium: GoogleFonts.sora(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkTextPrimaryColor,
        ),
        titleSmall: GoogleFonts.sora(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: darkTextPrimaryColor,
        ),
        bodyLarge: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkTextPrimaryColor,
        ),
        bodyMedium: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: darkTextPrimaryColor,
        ),
        bodySmall: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: darkTextSecondaryColor,
        ),
        labelLarge: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: darkTextPrimaryColor,
        ),
        labelMedium: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: darkTextSecondaryColor,
        ),
        labelSmall: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: darkTextDisabledColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: darkDividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: darkDividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: darkErrorColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: darkTextSecondaryColor,
        ),
        hintStyle: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: darkTextDisabledColor,
        ),
        errorStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: darkErrorColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurfaceColor,
        selectedItemColor: darkPrimaryColor,
        unselectedItemColor: darkTextSecondaryColor,
        selectedLabelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: darkDividerColor,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceColor,
        selectedColor: darkPrimaryColor.withValues(alpha: 0.1),
        labelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: darkTextPrimaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: darkDividerColor),
        ),
      ),
    );
  }
}
