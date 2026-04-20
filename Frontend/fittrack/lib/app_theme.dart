import 'package:flutter/material.dart';

ThemeData getTheme(Brightness newBrightness, Color newSeedColor) {
  final scheme = ColorScheme.fromSeed(
    seedColor: newSeedColor,
    brightness: newBrightness,
  );

  final isDark = newBrightness == Brightness.dark;

  final background = isDark
      ? const Color(0xFF1E2530)
      : const Color(0xFFD9E3F0);

  final surface = isDark
      ? const Color(0xFF262E3B)
      : const Color(0xFFEAF1FB);

  final primaryText = isDark
      ? const Color(0xFFEAF2FF)
      : const Color(0xFF24324A);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme.copyWith(
      primary: isDark
          ? const Color(0xFF8FB4FF)
          : const Color(0xFF4D7CFE),
      onPrimary: Colors.white,
      surface: background,
      onSurface: primaryText,
      onSurfaceVariant: isDark
          ? const Color(0xFFA9B6CC)
          : const Color(0xFF5F6F8C),
      primaryContainer: isDark
          ? const Color(0xFF31415E)
          : const Color(0xFFD4E2FF),
      onPrimaryContainer: isDark
          ? const Color(0xFFEAF2FF)
          : const Color(0xFF1F3F8F),
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: primaryText,
      centerTitle: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primaryText,
      ),
      iconTheme: IconThemeData(color: primaryText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark
            ? const Color(0xFF8FB4FF)
            : const Color(0xFF4D7CFE),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
    ),
  );
}

bool neoIsDark(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

Color neoBackgroundColor(BuildContext context) {
  return neoIsDark(context)
      ? const Color(0xFF1E2530)
      : const Color(0xFFD9E3F0);
}

Color neoSurfaceColor(BuildContext context) {
  return neoIsDark(context)
      ? const Color(0xFF262E3B)
      : const Color(0xFFEAF1FB);
}

Color neoPrimaryTextColor(BuildContext context) {
  return neoIsDark(context)
      ? const Color(0xFFEAF2FF)
      : const Color(0xFF24324A);
}

Color neoSecondaryTextColor(BuildContext context) {
  return neoIsDark(context)
      ? const Color(0xFFA9B6CC)
      : const Color(0xFF5F6F8C);
}

Color neoAccentColor(BuildContext context) {
  return neoIsDark(context)
      ? const Color(0xFF8FB4FF)
      : const Color(0xFF4D7CFE);
}

List<BoxShadow> neoShadows(
  BuildContext context, {
  double distance = 8,
  double blur = 18,
}) {
  final isDark = neoIsDark(context);

  if (isDark) {
    return [
      BoxShadow(
        color: Colors.white.withOpacity(0.08),
        offset: Offset(-distance, -distance),
        blurRadius: blur,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.55),
        offset: Offset(distance, distance),
        blurRadius: blur,
      ),
    ];
  }

  return [
    BoxShadow(
      color: Colors.white.withOpacity(0.95),
      offset: Offset(-distance, -distance),
      blurRadius: blur,
    ),
    BoxShadow(
      color: const Color(0xFFA7B7D6).withOpacity(0.75),
      offset: Offset(distance, distance),
      blurRadius: blur,
    ),
  ];
}