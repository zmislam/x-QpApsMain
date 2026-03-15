import 'package:flutter/material.dart';

// =============================================================================
// PostBackground — Unified solid color + gradient system for post backgrounds
// =============================================================================
// Storage format in backend (String field `post_background_color`):
//   Solid:    "e74c3c"                          (6-char hex, no #)
//   Gradient: "gradient:e74c3c,3498db,180"      (colors + angle in degrees)
//   Null:     no background
//
// Backward compatible — old solid color posts work unchanged.
// =============================================================================

class PostBackground {
  final Color primaryColor;
  final Gradient? gradient;
  final String storageValue; // what gets saved to backend

  const PostBackground._({
    required this.primaryColor,
    this.gradient,
    required this.storageValue,
  });

  bool get isGradient => gradient != null;
  bool get isSolid => gradient == null;

  /// Create a solid color background
  factory PostBackground.solid(Color color) {
    final hex = color.value.toRadixString(16).substring(2, 8);
    return PostBackground._(
      primaryColor: color,
      gradient: null,
      storageValue: hex,
    );
  }

  /// Create a gradient background
  factory PostBackground.gradient({
    required List<Color> colors,
    double angle = 180,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
  }) {
    final hexColors =
        colors.map((c) => c.value.toRadixString(16).substring(2, 8)).toList();
    final storageVal =
        'gradient:${hexColors.join(",")},${angle.toInt()}';

    // Convert angle to alignment
    final rad = angle * 3.14159265 / 180;
    final beginAlign = begin ?? Alignment(-_cos(rad), -_sin(rad));
    final endAlign = end ?? Alignment(_cos(rad), _sin(rad));

    return PostBackground._(
      primaryColor: colors.first,
      gradient: LinearGradient(
        begin: beginAlign as Alignment,
        end: endAlign as Alignment,
        colors: colors,
      ),
      storageValue: storageVal,
    );
  }

  static double _cos(double rad) {
    // Simple cos approximation safe for alignment values
    final val = rad % (2 * 3.14159265);
    // Use dart:math indirectly through a simple lookup
    if (val < 0.01) return 1.0;
    if ((val - 1.5708).abs() < 0.01) return 0.0;
    if ((val - 3.14159).abs() < 0.01) return -1.0;
    if ((val - 4.71239).abs() < 0.01) return 0.0;
    // Fallback — compute via Taylor or just map common angles
    return _cosTable(val);
  }

  static double _sin(double rad) {
    return _cos(rad - 1.5708);
  }

  static double _cosTable(double rad) {
    // Map common degree angles
    final deg = (rad * 180 / 3.14159265).round() % 360;
    switch (deg) {
      case 0:
        return 1.0;
      case 45:
        return 0.707;
      case 90:
        return 0.0;
      case 135:
        return -0.707;
      case 180:
        return -1.0;
      case 225:
        return -0.707;
      case 270:
        return 0.0;
      case 315:
        return 0.707;
      default:
        return 0.0;
    }
  }

  /// Parse a stored backend value back to a PostBackground
  static PostBackground? parse(String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.startsWith('gradient:')) {
      try {
        final parts = value.substring(9).split(',');
        if (parts.length < 3) return null;
        final angle = double.tryParse(parts.last) ?? 180;
        final colors = parts
            .sublist(0, parts.length - 1)
            .map((hex) => Color(int.parse('0xff$hex')))
            .toList();
        return PostBackground.gradient(colors: colors, angle: angle);
      } catch (_) {
        return null;
      }
    }

    // Solid color
    try {
      final color = Color(int.parse('0xff$value'));
      return PostBackground._(
        primaryColor: color,
        gradient: null,
        storageValue: value,
      );
    } catch (_) {
      return null;
    }
  }

  /// Build a BoxDecoration from this background
  BoxDecoration toDecoration({BorderRadius? borderRadius}) {
    if (isGradient) {
      return BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      );
    }
    return BoxDecoration(
      color: primaryColor,
      borderRadius: borderRadius,
    );
  }

  /// Determine text color for readability on this background
  Color get textColor {
    // Light colors get dark text, dark colors get white text
    final luminance = primaryColor.computeLuminance();
    return luminance > 0.45 ? Colors.black : Colors.white;
  }

  /// Hint text color
  Color get hintColor {
    final luminance = primaryColor.computeLuminance();
    return luminance > 0.45
        ? Colors.black.withValues(alpha: 0.5)
        : Colors.white.withValues(alpha: 0.7);
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  Static helpers for feed renderers — drop-in replacements
  // ═══════════════════════════════════════════════════════════════════════

  /// Build a BoxDecoration from a raw backend string (solid hex or gradient).
  /// Safe to call with null/empty — returns null decoration in that case.
  static BoxDecoration? decorationFromStoredValue(String? value) {
    if (value == null || value.isEmpty) return null;
    final bg = parse(value);
    if (bg == null) return null;
    return bg.toDecoration();
  }

  /// Get readable text color from a raw stored value.
  static Color textColorFromStoredValue(String? value) {
    if (value == null || value.isEmpty) return Colors.white;
    final bg = parse(value);
    if (bg == null) return Colors.white;
    return bg.textColor;
  }

  /// Check if a stored value represents a valid background.
  static bool hasBackground(String? value) {
    return value != null && value.isNotEmpty;
  }
}
