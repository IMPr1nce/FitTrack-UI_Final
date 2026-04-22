import 'package:flutter/material.dart';

ThemeData getTheme(Brightness brightness, Color seedColor) {
  final isDark = brightness == Brightness.dark;

  final scheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  ).copyWith(
    primary: isDark
        ? const Color(0xFF9FBCFF)
        : const Color(0xFF4B74E6),
    onPrimary: Colors.white,
    surface: isDark
        ? const Color(0xFF18212D)
        : const Color(0xFFCAD8E8),
    onSurface: isDark
        ? const Color(0xFFEAF2FF)
        : const Color(0xFF22324A),
    onSurfaceVariant: isDark
        ? const Color(0xFFB2BED1)
        : const Color(0xFF61718D),
    primaryContainer: isDark
        ? const Color(0xFF314563)
        : const Color(0xFFD3E1F8),
    onPrimaryContainer: isDark
        ? const Color(0xFFEAF2FF)
        : const Color(0xFF1E408F),
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
      ? const Color(0xFF18212D)
      : const Color(0xFFCAD8E8);
}

Color neoSurfaceFromBrightness(Brightness brightness) {
  return brightness == Brightness.dark
      ? const Color(0xFF243244)
      : const Color(0xFFDCE7F4);
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
      : const Color(0xFF22324A);
}

Color neoSecondaryTextColor(BuildContext context) {
  return neoIsDark(context)
      ? const Color(0xFFB2BED1)
      : const Color(0xFF61718D);
}

Color neoAccentColor(BuildContext context) {
  return neoIsDark(context)
      ? const Color(0xFF9FBCFF)
      : const Color(0xFF4B74E6);
}

List<BoxShadow> neoShadows(
  BuildContext context, {
  double distance = 10,
  double blur = 22,
}) {
  final isDark = neoIsDark(context);

  if (isDark) {
    return [
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.08),
        offset: Offset(-distance, -distance),
        blurRadius: blur,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.62),
        offset: Offset(distance, distance),
        blurRadius: blur,
      ),
    ];
  }

  return [
    BoxShadow(
      color: const Color(0xFFF6FAFF).withValues(alpha: 0.82),
      offset: Offset(-distance, -distance),
      blurRadius: blur,
    ),
    BoxShadow(
      color: const Color(0xFF9AAECC).withValues(alpha: 0.95),
      offset: Offset(distance, distance),
      blurRadius: blur,
    ),
  ];
}

List<BoxShadow> neoSoftShadows(
  BuildContext context, {
  double distance = 6,
  double blur = 12,
}) {
  final isDark = neoIsDark(context);

  if (isDark) {
    return [
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.05),
        offset: Offset(-distance, -distance),
        blurRadius: blur,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.48),
        offset: Offset(distance, distance),
        blurRadius: blur,
      ),
    ];
  }

  return [
    BoxShadow(
      color: const Color(0xFFF7FBFF).withValues(alpha: 0.76),
      offset: Offset(-distance, -distance),
      blurRadius: blur,
    ),
    BoxShadow(
      color: const Color(0xFF9FB2CF).withValues(alpha: 0.82),
      offset: Offset(distance, distance),
      blurRadius: blur,
    ),
  ];
}
List<BoxShadow> neoInsetShadows(
  BuildContext context, {
  double distance = 6,
  double blur = 12,
}) {
  final isDark = neoIsDark(context);

  if (isDark) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.52),
        offset: Offset(distance, distance),
        blurRadius: blur,
        blurStyle: BlurStyle.inner,
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.05),
        offset: Offset(-distance, -distance),
        blurRadius: blur,
        blurStyle: BlurStyle.inner,
      ),
    ];
  }

  return [
    BoxShadow(
      color: const Color(0xFF97A9C7).withValues(alpha: 0.88),
      offset: Offset(distance, distance),
      blurRadius: blur,
      blurStyle: BlurStyle.inner,
    ),
    BoxShadow(
      color: const Color(0xFFF8FBFF).withValues(alpha: 0.72),
      offset: Offset(-distance, -distance),
      blurRadius: blur,
      blurStyle: BlurStyle.inner,
    ),
  ];
}