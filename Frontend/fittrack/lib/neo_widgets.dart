import 'package:flutter/material.dart';
import 'app_theme.dart';

class NeoSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double radius;
  final double? width;
  final double? height;
  final List<BoxShadow>? shadows;
  final Color? color;

  const NeoSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.radius = 24,
    this.width,
    this.height,
    this.shadows,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? neoSurfaceColor(context),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadows ?? neoShadows(context),
      ),
      child: child,
    );
  }
}

class NeoIconTile extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? iconColor;

  const NeoIconTile({
    super.key,
    required this.icon,
    this.size = 58,
    this.iconSize = 22,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return NeoSurface(
      width: size,
      height: size,
      padding: EdgeInsets.zero,
      radius: 20,
      shadows: neoSoftShadows(context, distance: 6, blur: 14),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? neoAccentColor(context),
        ),
      ),
    );
  }
}

class NeoNavSelected extends StatelessWidget {
  final IconData icon;
  final String label;

  const NeoNavSelected({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return NeoSurface(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      radius: 24,
      shadows: neoShadows(context, distance: 10, blur: 22),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: neoAccentColor(context), size: 22),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: neoPrimaryTextColor(context),
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class NeoNavUnselected extends StatelessWidget {
  final IconData icon;

  const NeoNavUnselected({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return NeoSurface(
      width: 60,
      height: 60,
      padding: EdgeInsets.zero,
      radius: 20,
      shadows: neoSoftShadows(context, distance: 6, blur: 13),
      child: Center(
        child: Icon(
          icon,
          color: neoSecondaryTextColor(context),
          size: 22,
        ),
      ),
    );
  }
}

class NeoTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;

  const NeoTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return NeoSurface(
      padding: EdgeInsets.zero,
      radius: 22,
      shadows: neoSoftShadows(context, distance: 7, blur: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          color: neoPrimaryTextColor(context),
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: neoAccentColor(context)),
          labelText: label,
          labelStyle: TextStyle(
            color: neoSecondaryTextColor(context),
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}

class _NeoInnerShadowPainter extends CustomPainter {
  final bool isDark;
  final double radius;

  const _NeoInnerShadowPainter({
    required this.isDark,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      );

    _drawInnerShadow(
      canvas,
      rect,
      path,
      const Offset(4, 4),
      isDark
          ? Colors.white.withValues(alpha: 0.05)
          : const Color(0xFFF8FBFF).withValues(alpha: 0.95),
    );

    _drawInnerShadow(
      canvas,
      rect,
      path,
      const Offset(-4, -4),
      isDark
          ? Colors.black.withValues(alpha: 0.28)
          : const Color(0xFF97A9C7).withValues(alpha: 0.62),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9
        ..color = isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.white.withValues(alpha: 0.22),
    );
  }

  void _drawInnerShadow(
    Canvas canvas,
    Rect rect,
    Path clipPath,
    Offset offset,
    Color color,
  ) {
    final outer = Path()..addRect(rect.inflate(30));
    final shadow = Path.combine(PathOperation.difference, outer, clipPath);

    canvas.save();
    canvas.clipPath(clipPath);
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(
      shadow,
      Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NeoInnerShadowPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.radius != radius;
  }
}

class NeoPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const NeoPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  State<NeoPrimaryButton> createState() => _NeoPrimaryButtonState();
}

class _NeoPrimaryButtonState extends State<NeoPrimaryButton> {
  bool pressed = false;

  void setPressed(bool value) {
    if (pressed == value) return;
    setState(() {
      pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = neoIsDark(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF314563)
            : const Color(0xFFD7E4F8),
        borderRadius: BorderRadius.circular(22),
        boxShadow: pressed ? [] : neoShadows(context, distance: 10, blur: 22),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            if (pressed)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _NeoInnerShadowPainter(
                      isDark: isDark,
                      radius: 22,
                    ),
                  ),
                ),
              ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTapDown: (_) => setPressed(true),
                onTapCancel: () => setPressed(false),
                onTapUp: (_) {
                  setPressed(false);
                  widget.onPressed();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: 20,
                          color: isDark
                              ? const Color(0xFFEAF2FF)
                              : const Color(0xFF1E408F),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFEAF2FF)
                              : const Color(0xFF1E408F),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NeoAchievementCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double shineLevel;
  final EdgeInsetsGeometry margin;

  const NeoAchievementCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.shineLevel,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final t = shineLevel.clamp(0.0, 1.0);
    final isDark = neoIsDark(context);

    final surface = Color.lerp(
      neoSurfaceColor(context),
      isDark
          ? const Color(0xFF6289D6)
          : const Color(0xFF4F6FAF),
      t * 0.58,
    )!;

    final accent = Color.lerp(
      neoAccentColor(context),
      const Color(0xFFF5F9FF),
      t * 0.55,
    )!;

    final titleColor = Color.lerp(
      neoPrimaryTextColor(context),
      const Color(0xFFF7FAFF),
      t * 0.82,
    )!;

    final subtitleColor = Color.lerp(
      neoSecondaryTextColor(context),
      const Color(0xFFE4ECFF),
      t * 0.78,
    )!;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: t.toDouble()),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      builder: (context, level, _) {
        return Container(
          margin: margin,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              if (isDark) ...[
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.05 + (0.02 * level)),
                  offset: const Offset(-10, -10),
                  blurRadius: 22 + (level * 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.54 + (0.08 * level)),
                  offset: const Offset(10, 10),
                  blurRadius: 22 + (level * 4),
                ),
              ] else ...[
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.86 + (0.06 * level)),
                  offset: const Offset(-10, -10),
                  blurRadius: 22 + (level * 4),
                ),
                BoxShadow(
                  color: const Color(0xFF8FA5CC)
                      .withValues(alpha: 0.82 + (0.08 * level)),
                  offset: const Offset(10, 10),
                  blurRadius: 22 + (level * 4),
                ),
              ],
              BoxShadow(
                color: isDark
                    ? accent.withValues(alpha: 0.10 * level)
                    : const Color(0xFF6F93DB).withValues(alpha: 0.16 * level),
                blurRadius: 16 + (level * 18),
                spreadRadius: level * 0.7,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          isDark
                              ? Colors.white.withValues(alpha: 0.03 + (0.05 * level))
                              : Colors.white.withValues(alpha: 0.10 + (0.12 * level)),
                          Colors.transparent,
                          isDark
                              ? accent.withValues(alpha: 0.05 + (0.08 * level))
                              : const Color(0xFF385A9D)
                                  .withValues(alpha: 0.04 + (0.10 * level)),
                        ],
                        stops: const [0.0, 0.42, 1.0],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            ...neoSoftShadows(
                              context,
                              distance: 6 + level,
                              blur: 12 + (level * 3),
                            ),
                            BoxShadow(
                              color: isDark
                                  ? accent.withValues(alpha: 0.10 + (0.10 * level))
                                  : const Color(0xFF9EB8F2)
                                      .withValues(alpha: 0.10 + (0.10 * level)),
                              blurRadius: 8 + (level * 12),
                            ),
                          ],
                        ),
                        child: Icon(icon, size: 24, color: accent),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              level < 0.33
                                  ? 'Building momentum'
                                  : level < 0.66
                                      ? 'Strong progress'
                                      : 'Elite volume',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}