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