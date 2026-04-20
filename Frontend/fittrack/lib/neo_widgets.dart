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
    this.size = 56,
    this.iconSize = 22,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return NeoSurface(
      width: size,
      height: size,
      padding: EdgeInsets.zero,
      radius: 18,
      shadows: neoShadows(context, distance: 5, blur: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      radius: 22,
      shadows: neoShadows(context, distance: 7, blur: 16),
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
              fontWeight: FontWeight.w700,
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
      width: 58,
      height: 58,
      padding: EdgeInsets.zero,
      radius: 20,
      shadows: neoShadows(context, distance: 5, blur: 10),
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

class NeoPrimaryButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = neoIsDark(context);

    final buttonColor = isDark
        ? const Color(0xFF31415E)
        : const Color(0xFFDCEBFF);

    final textColor = isDark
        ? const Color(0xFFEAF2FF)
        : const Color(0xFF1F3F8F);

    return NeoSurface(
      padding: EdgeInsets.zero,
      radius: 20,
      color: buttonColor,
      shadows: neoShadows(context, distance: 7, blur: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}