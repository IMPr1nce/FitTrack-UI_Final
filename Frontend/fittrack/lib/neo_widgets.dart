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
          Icon(
            icon,
            color: neoAccentColor(context),
            size: 22,
          ),
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
          prefixIcon: Icon(
            icon,
            color: neoAccentColor(context),
          ),
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
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(radius),
    );
    final innerPath = Path()..addRRect(rrect);

    _drawInnerShadow(
      canvas: canvas,
      rect: rect,
      clipPath: innerPath,
      radius: radius,
      color: isDark
          ? Colors.white.withOpacity(0.05)
          : const Color(0xFFF8FBFF).withOpacity(0.95),
      offset: const Offset(4, 4),
      blurSigma: 8,
    );

    _drawInnerShadow(
      canvas: canvas,
      rect: rect,
      clipPath: innerPath,
      radius: radius,
      color: isDark
          ? Colors.black.withOpacity(0.28)
          : const Color(0xFF97A9C7).withOpacity(0.62),
      offset: const Offset(-4, -4),
      blurSigma: 8,
    );

    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = isDark
          ? Colors.white.withOpacity(0.03)
          : Colors.white.withOpacity(0.22);

    canvas.drawRRect(rrect, edgePaint);
  }

  void _drawInnerShadow({
    required Canvas canvas,
    required Rect rect,
    required Path clipPath,
    required double radius,
    required Color color,
    required Offset offset,
    required double blurSigma,
  }) {
    final outerRect = rect.inflate(blurSigma * 3);

    final outerPath = Path()..addRect(outerRect);
    final shadowPath = Path.combine(
      PathOperation.difference,
      outerPath,
      clipPath,
    );

    final paint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);

    canvas.save();
    canvas.clipPath(clipPath);
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(shadowPath, paint);
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
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = neoIsDark(context);

    final buttonColor = isDark
        ? const Color(0xFF314563)
        : const Color(0xFFD7E4F8);

    final textColor = isDark
        ? const Color(0xFFEAF2FF)
        : const Color(0xFF1E408F);

    const radiusValue = 22.0;
    final radius = BorderRadius.circular(radiusValue);

    return Container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: radius,
        boxShadow: _pressed
            ? const []
            : neoShadows(context, distance: 10, blur: 22),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            if (_pressed)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _NeoInnerShadowPainter(
                      isDark: isDark,
                      radius: radiusValue,
                    ),
                  ),
                ),
              ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: radius,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTapDown: (_) => _setPressed(true),
                onTapCancel: () => _setPressed(false),
                onTapUp: (_) {
                  _setPressed(false);
                  widget.onPressed();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: textColor, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: textColor,
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
    final isDark = neoIsDark(context);
    final level = shineLevel.clamp(0.0, 1.0).toDouble();

    final baseSurface = neoSurfaceColor(context);
    final baseAccent = neoAccentColor(context);
    final baseTitle = neoPrimaryTextColor(context);
    final baseSubtitle = neoSecondaryTextColor(context);

    final targetSurface = isDark
        ? const Color(0xFF6289D6)
        : const Color(0xFF4F6FAF);

    final targetAccent = isDark
        ? const Color(0xFFF5F9FF)
        : const Color(0xFFF4F8FF);

    final surfaceBlend = 0.58;
    final accentBlend = 0.55;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: level),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      builder: (context, t, _) {
        final surface = Color.lerp(
          baseSurface,
          targetSurface,
          t * surfaceBlend,
        )!;

        final accent = Color.lerp(
          baseAccent,
          targetAccent,
          t * accentBlend,
        )!;

        final titleColor = Color.lerp(
          baseTitle,
          const Color(0xFFF7FAFF),
          t * 0.82,
        )!;

        final subtitleColor = Color.lerp(
          baseSubtitle,
          const Color(0xFFE4ECFF),
          t * 0.78,
        )!;

        final outerGlow = isDark
            ? accent.withOpacity(0.10 * t)
            : const Color(0xFF6F93DB).withOpacity(0.16 * t);

        final iconGlow = isDark
            ? accent.withOpacity(0.10 + (0.10 * t))
            : const Color(0xFF9EB8F2).withOpacity(0.10 + (0.10 * t));

        final topSheen = isDark
            ? Colors.white.withOpacity(0.03 + (0.05 * t))
            : Colors.white.withOpacity(0.10 + (0.12 * t));

        final bottomTint = isDark
            ? accent.withOpacity(0.05 + (0.08 * t))
            : const Color(0xFF385A9D).withOpacity(0.04 + (0.10 * t));

        final localShadows = isDark
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.05 + (0.02 * t)),
                  offset: const Offset(-10, -10),
                  blurRadius: 22 + (t * 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.54 + (0.08 * t)),
                  offset: const Offset(10, 10),
                  blurRadius: 22 + (t * 4),
                ),
                BoxShadow(
                  color: outerGlow,
                  blurRadius: 16 + (t * 18),
                  spreadRadius: t * 0.6,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.white.withOpacity(0.86 + (0.06 * t)),
                  offset: const Offset(-10, -10),
                  blurRadius: 22 + (t * 4),
                ),
                BoxShadow(
                  color: const Color(0xFF8FA5CC).withOpacity(0.82 + (0.08 * t)),
                  offset: const Offset(10, 10),
                  blurRadius: 22 + (t * 4),
                ),
                BoxShadow(
                  color: outerGlow,
                  blurRadius: 16 + (t * 18),
                  spreadRadius: t * 0.7,
                ),
              ];

        return Container(
          margin: margin,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: localShadows,
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
                          topSheen,
                          Colors.transparent,
                          bottomTint,
                        ],
                        stops: const [0.0, 0.42, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -30,
                  top: -22,
                  child: IgnorePointer(
                    child: Container(
                      width: 170,
                      height: 74,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(
                              isDark
                                  ? 0.02 + (0.04 * t)
                                  : 0.08 + (0.14 * t),
                            ),
                            Colors.transparent,
                          ],
                        ),
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
                            if (isDark) ...[
                              BoxShadow(
                                color: Colors.white.withOpacity(0.04 + (0.02 * t)),
                                offset: const Offset(-6, -6),
                                blurRadius: 12 + (t * 3),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.44 + (0.08 * t)),
                                offset: const Offset(6, 6),
                                blurRadius: 12 + (t * 3),
                              ),
                            ] else ...[
                              BoxShadow(
                                color: Colors.white.withOpacity(0.88 + (0.08 * t)),
                                offset: const Offset(-6, -6),
                                blurRadius: 12 + (t * 3),
                              ),
                              BoxShadow(
                                color: const Color(0xFF8FA5CC).withOpacity(0.74 + (0.08 * t)),
                                offset: const Offset(6, 6),
                                blurRadius: 12 + (t * 3),
                              ),
                            ],
                            BoxShadow(
                              color: iconGlow,
                              blurRadius: 8 + (t * 12),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          size: 24,
                          color: accent,
                        ),
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
                              t < 0.33
                                  ? 'Building momentum'
                                  : t < 0.66
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