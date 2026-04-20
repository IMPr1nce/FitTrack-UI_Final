import 'package:flutter/material.dart';

ThemeData getTheme(Brightness brightness, Color seedColor) {
  final isDark = brightness == Brightness.dark;

  final scheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  ).copyWith(
    primary: isDark
        ? const Color(0xFF8FB4FF)
        : const Color(0xFF4D7CFE),
    onPrimary: Colors.white,
    surface: isDark
        ? const Color(0xFF1E2530)
        : const Color(0xFFD9E3F0),
    onSurface: isDark
        ? const Color(0xFFEAF2FF)
        : const Color(0xFF24324A),
    onSurfaceVariant: isDark
        ? const Color(0xFFA9B6CC)
        : const Color(0xFF5F6F8C),
    primaryContainer: isDark
        ? const Color(0xFF31415E)
        : const Color(0xFFD4E2FF),
    onPrimaryContainer: isDark
        ? const Color(0xFFEAF2FF)
        : const Color(0xFF1F3F8F),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: neoBackgroundFromBrightness(brightness),
    appBarTheme: AppBarTheme(
      backgroundColor: neoBackgroundFromBrightness(brightness),
      foregroundColor: scheme.onSurface,
      centerTitle: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
    ),
  );
}

bool neoIsDark(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

Color neoBackgroundFromBrightness(Brightness brightness) {
  return brightness == Brightness.dark
      ? const Color(0xFF1E2530)
      : const Color(0xFFD9E3F0);
}

Color neoSurfaceFromBrightness(Brightness brightness) {
  return brightness == Brightness.dark
      ? const Color(0xFF262E3B)
      : const Color(0xFFEAF1FB);
}

Color neoBackgroundColor(BuildContext context) {
  return neoBackgroundFromBrightness(Theme.of(context).brightness);
}

Color neoSurfaceColor(BuildContext context) {
  return neoSurfaceFromBrightness(Theme.of(context).brightness);
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
        color: Colors.white.withOpacity(0.06),
        offset: Offset(-distance, -distance),
        blurRadius: blur,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.52),
        offset: Offset(distance, distance),
        blurRadius: blur,
      ),
    ];
  }

  return [
    BoxShadow(
      color: Colors.white.withOpacity(0.96),
      offset: Offset(-distance, -distance),
      blurRadius: blur,
    ),
    BoxShadow(
      color: const Color(0xFFA7B7D6).withOpacity(0.78),
      offset: Offset(distance, distance),
      blurRadius: blur,
    ),
  ];
}