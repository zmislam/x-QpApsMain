import 'package:flutter/material.dart';
import '../../../config/constants/color.dart';

// =============================================================================
// TEMPORARY — Brand logo design showcase
// Remove after approval. Called via long-press on the header logo.
// =============================================================================

void showBrandDesignPreview(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      final sheetBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
      final labelColor =
          isDark ? Colors.grey.shade400 : Colors.grey.shade600;
      final cardBg = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF5F5F5);
      final dividerColor =
          isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06);

      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollCtrl) {
          return Container(
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // ── Handle ──────────────────────────────────────────
                const SizedBox(height: 10),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Logo Design Options',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Long-press the header logo to open this preview',
                  style: TextStyle(fontSize: 12, color: labelColor),
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: dividerColor),
                // ── Design Grid ─────────────────────────────────────
                Expanded(
                  child: ListView(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    children: [
                      // 0 — current design
                      _DesignCard(
                        index: 0,
                        label: 'Current — Grand Hotel Script',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildCurrentDesign(),
                      ),
                      const SizedBox(height: 14),

                      // 1 — Modern Clean (Poppins lowercase, letter-spaced)
                      _DesignCard(
                        index: 1,
                        label: 'Modern Clean — Poppins',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildModernClean(),
                      ),
                      const SizedBox(height: 14),

                      // 2 — Bold Condensed (Oswald uppercase)
                      _DesignCard(
                        index: 2,
                        label: 'Bold Condensed — Oswald',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildBoldCondensed(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 3 — Minimal Sans (SfProDisplay)
                      _DesignCard(
                        index: 3,
                        label: 'Minimal Sans — SF Pro',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildMinimalSans(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 4 — QP Monogram + text
                      _DesignCard(
                        index: 4,
                        label: 'QP Monogram + Subtext',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildMonogram(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 5 — Neon Glow Script
                      _DesignCard(
                        index: 5,
                        label: 'Neon Glow — Grand Hotel',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildNeonGlow(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 6 — Gradient Bold (Poppins Bold, vivid gradient)
                      _DesignCard(
                        index: 6,
                        label: 'Gradient Bold — Poppins',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildGradientBold(),
                      ),
                      const SizedBox(height: 14),

                      // 7 — Stacked Two-Line (WorkSans)
                      _DesignCard(
                        index: 7,
                        label: 'Stacked Two-Line — Work Sans',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildStackedTwoLine(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 8 — Elegant Serif Blend
                      _DesignCard(
                        index: 8,
                        label: 'Elegant Blend — Script + Sans',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildElegantBlend(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 9 — Logo Icon + Text
                      _DesignCard(
                        index: 9,
                        label: 'App Logo + Text',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildLogoWithText(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 10 — Underline Accent
                      _DesignCard(
                        index: 10,
                        label: 'Underline Accent — Poppins',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildUnderlineAccent(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 11 — Pill Badge Style
                      _DesignCard(
                        index: 11,
                        label: 'Pill Badge — Rounded Container',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildPillBadge(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 12 — Typewriter (CourierPrime)
                      _DesignCard(
                        index: 12,
                        label: 'Typewriter — Courier Prime',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildTypewriter(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 13 — Outlined Text
                      _DesignCard(
                        index: 13,
                        label: 'Outlined Stroke — Poppins',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildOutlinedText(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 14 — Split Color
                      _DesignCard(
                        index: 14,
                        label: 'Split Color — Two Tone',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildSplitColor(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 15 — Dot Separator
                      _DesignCard(
                        index: 15,
                        label: 'Dot Separator — Poppins',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildDotSeparator(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 16 — Glassmorphic Card
                      _DesignCard(
                        index: 16,
                        label: 'Glassmorphic Card',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildGlassmorphic(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 17 — Circular Monogram + Script
                      _DesignCard(
                        index: 17,
                        label: 'Circle Monogram + Script',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildCircleMonogram(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 18 — Vertical Bar Accent
                      _DesignCard(
                        index: 18,
                        label: 'Vertical Bar — SF Pro',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildVerticalBar(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 19 — Handwritten Casual
                      _DesignCard(
                        index: 19,
                        label: 'Handwritten — Cedarville',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildHandwritten(isDark),
                      ),
                      const SizedBox(height: 14),

                      // ── NEW: Script-based cleaner variants ────────

                      // 20 — Script Solid Teal (no gradient, just clean solid)
                      _DesignCard(
                        index: 20,
                        label: 'Script Solid — Clean Teal',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildScriptSolidTeal(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 21 — Script Larger + Letter-Spaced
                      _DesignCard(
                        index: 21,
                        label: 'Script Large — Spaced',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildScriptLargeSpaced(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 22 — Script + Subtle Shadow (readable depth)
                      _DesignCard(
                        index: 22,
                        label: 'Script Shadow — Depth',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildScriptSubtleShadow(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 23 — Script Dark Teal (darker, bolder feel)
                      _DesignCard(
                        index: 23,
                        label: 'Script Dark — Bold Teal',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildScriptDarkTeal(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 24 — Script Two-Tone (quantum gradient + possibilities solid)
                      _DesignCard(
                        index: 24,
                        label: 'Script Two-Tone Split',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildScriptTwoTone(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 25 — Script Compact (smaller, tighter, clean)
                      _DesignCard(
                        index: 25,
                        label: 'Script Compact — Tight',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildScriptCompact(isDark),
                      ),
                      const SizedBox(height: 14),

                      // 26 — Script Horizontal Gradient (left-to-right clean)
                      _DesignCard(
                        index: 26,
                        label: 'Script Gradient — Horizontal',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildScriptHorizontalGradient(),
                      ),
                      const SizedBox(height: 14),

                      // 27 — Script + Thin Underline (clean accent)
                      _DesignCard(
                        index: 27,
                        label: 'Script + Thin Underline',
                        cardBg: cardBg,
                        labelColor: labelColor,
                        isDark: isDark,
                        child: _buildScriptThinUnderline(isDark),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// =============================================================================
//  Design 0 — Current (Grand Hotel cursive teal gradient)
// =============================================================================
Widget _buildCurrentDesign() {
  return ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [
        Color(0xFF1E4F4F),
        Color(0xFF307777),
        Color(0xFF21CBC1),
      ],
      stops: [0.0, 0.45, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds),
    child: const Text(
      'quantum possibilities',
      style: TextStyle(
        fontFamily: 'GrandHotel',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.2,
      ),
    ),
  );
}

// =============================================================================
//  Design 1 — Modern Clean (Poppins, lowercase, letter-spaced, solid teal)
// =============================================================================
Widget _buildModernClean() {
  return const Text(
    'quantum possibilities',
    style: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: PRIMARY_COLOR,
      letterSpacing: 0.8,
      height: 1.3,
    ),
  );
}

// =============================================================================
//  Design 2 — Bold Condensed (Oswald uppercase, teal gradient)
// =============================================================================
Widget _buildBoldCondensed(bool isDark) {
  return ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [PRIMARY_COLOR, Color(0xFF21CBC1)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(bounds),
    child: const Text(
      'QUANTUM POSSIBILITIES',
      style: TextStyle(
        fontFamily: 'Oswald',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 2.5,
        height: 1.2,
      ),
    ),
  );
}

// =============================================================================
//  Design 3 — Minimal Sans (SfProDisplay, lowercase, subtle)
// =============================================================================
Widget _buildMinimalSans(bool isDark) {
  return Text(
    'quantum possibilities',
    style: TextStyle(
      fontFamily: 'SfProDisplay',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white : const Color(0xFF2C2C2C),
      letterSpacing: -0.3,
      height: 1.2,
    ),
  );
}

// =============================================================================
//  Design 4 — QP Monogram + Subtext
// =============================================================================
Widget _buildMonogram(bool isDark) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // QP monogram in a rounded square
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E4F4F), Color(0xFF307777), Color(0xFF21CBC1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'QP',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
              height: 1.0,
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'quantum',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1E4F4F),
              height: 1.15,
              letterSpacing: -0.2,
            ),
          ),
          Text(
            'possibilities',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              height: 1.15,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    ],
  );
}

// =============================================================================
//  Design 5 — Neon Glow Script (Grand Hotel with glow shadow)
// =============================================================================
Widget _buildNeonGlow(bool isDark) {
  return Text(
    'quantum possibilities',
    style: TextStyle(
      fontFamily: 'GrandHotel',
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF21CBC1),
      height: 1.2,
      shadows: [
        Shadow(
          color: const Color(0xFF21CBC1).withValues(alpha: 0.6),
          blurRadius: 12,
        ),
        Shadow(
          color: const Color(0xFF21CBC1).withValues(alpha: 0.3),
          blurRadius: 24,
        ),
        if (isDark)
          Shadow(
            color: const Color(0xFF21CBC1).withValues(alpha: 0.15),
            blurRadius: 40,
          ),
      ],
    ),
  );
}

// =============================================================================
//  Design 6 — Gradient Bold (Poppins Bold, vivid teal-to-emerald)
// =============================================================================
Widget _buildGradientBold() {
  return ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [
        Color(0xFF0D9488), // teal-600
        Color(0xFF307777), // PRIMARY
        Color(0xFF14B8A6), // teal-400
        Color(0xFF06B6D4), // cyan-500
      ],
      stops: [0.0, 0.35, 0.65, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(bounds),
    child: const Text(
      'quantum possibilities',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: -0.3,
        height: 1.2,
      ),
    ),
  );
}

// =============================================================================
//  Design 7 — Stacked Two-Line (WorkSans, "quantum" big + "possibilities" small)
// =============================================================================
Widget _buildStackedTwoLine(bool isDark) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF1E4F4F), Color(0xFF307777)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: const Text(
          'quantum',
          style: TextStyle(
            fontFamily: 'WorkSans',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.0,
            height: 1.1,
          ),
        ),
      ),
      Text(
        'POSSIBILITIES',
        style: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
          letterSpacing: 5.0,
          height: 1.4,
        ),
      ),
    ],
  );
}

// =============================================================================
//  Design 8 — Elegant Blend (GrandHotel "q" + Poppins rest)
// =============================================================================
Widget _buildElegantBlend(bool isDark) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      // Large decorative "q" in script
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF1E4F4F), Color(0xFF21CBC1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds),
        child: const Text(
          'q',
          style: TextStyle(
            fontFamily: 'GrandHotel',
            fontSize: 34,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ),
      // Rest in clean sans
      Text(
        'uantum possibilities',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF2C2C2C),
          height: 1.0,
          letterSpacing: 0.3,
        ),
      ),
    ],
  );
}

// =============================================================================
//  Design 9 — Logo Icon + Text
// =============================================================================
Widget _buildLogoWithText(bool isDark) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // App logo
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/logo/app_logo.png',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 8),
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            Color(0xFF1E4F4F),
            Color(0xFF307777),
            Color(0xFF21CBC1),
          ],
          stops: [0.0, 0.45, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: const Text(
          'quantum possibilities',
          style: TextStyle(
            fontFamily: 'GrandHotel',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ),
    ],
  );
}

// =============================================================================
//  Design 10 — Underline Accent (text + gradient underline bar)
// =============================================================================
Widget _buildUnderlineAccent(bool isDark) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'quantum possibilities',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF1E4F4F),
          letterSpacing: 0.3,
          height: 1.2,
        ),
      ),
      const SizedBox(height: 3),
      Container(
        height: 2.5,
        width: 100,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF307777),
              Color(0xFF21CBC1),
              Color(0xFF06B6D4),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ],
  );
}

// =============================================================================
//  Design 11 — Pill Badge (text inside rounded teal border container)
// =============================================================================
Widget _buildPillBadge(bool isDark) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: isDark
          ? PRIMARY_COLOR.withValues(alpha: 0.15)
          : PRIMARY_COLOR.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: PRIMARY_COLOR.withValues(alpha: 0.35),
        width: 1.2,
      ),
    ),
    child: ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF1E4F4F), Color(0xFF307777), Color(0xFF21CBC1)],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: const Text(
        'quantum possibilities',
        style: TextStyle(
          fontFamily: 'GrandHotel',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.2,
        ),
      ),
    ),
  );
}

// =============================================================================
//  Design 12 — Typewriter (CourierPrime, retro mono look)
// =============================================================================
Widget _buildTypewriter(bool isDark) {
  return Text(
    'quantum_possibilities',
    style: TextStyle(
      fontFamily: 'CourierPrime',
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: isDark ? const Color(0xFF21CBC1) : PRIMARY_COLOR,
      letterSpacing: 0.5,
      height: 1.3,
    ),
  );
}

// =============================================================================
//  Design 13 — Outlined Stroke Text (Poppins, border-only letters)
// =============================================================================
Widget _buildOutlinedText(bool isDark) {
  return Stack(
    children: [
      // Stroke layer
      Text(
        'quantum possibilities',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          height: 1.2,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = isDark ? const Color(0xFF21CBC1) : PRIMARY_COLOR,
        ),
      ),
    ],
  );
}

// =============================================================================
//  Design 14 — Split Color ("quantum" teal, "possibilities" dark/grey)
// =============================================================================
Widget _buildSplitColor(bool isDark) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'quantum ',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: PRIMARY_COLOR,
          height: 1.2,
          letterSpacing: -0.3,
        ),
      ),
      Text(
        'possibilities',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 19,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          height: 1.2,
          letterSpacing: -0.3,
        ),
      ),
    ],
  );
}

// =============================================================================
//  Design 15 — Dot Separator (quantum • possibilities)
// =============================================================================
Widget _buildDotSeparator(bool isDark) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'quantum',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF1E4F4F),
          height: 1.2,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: Color(0xFF21CBC1),
            shape: BoxShape.circle,
          ),
        ),
      ),
      Text(
        'possibilities',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF1E4F4F),
          height: 1.2,
        ),
      ),
    ],
  );
}

// =============================================================================
//  Design 16 — Glassmorphic Card (frosted container + gradient text)
// =============================================================================
Widget _buildGlassmorphic(bool isDark) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isDark
            ? [Colors.white.withValues(alpha: 0.08), Colors.white.withValues(alpha: 0.03)]
            : [PRIMARY_COLOR.withValues(alpha: 0.06), const Color(0xFF21CBC1).withValues(alpha: 0.04)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.12)
            : PRIMARY_COLOR.withValues(alpha: 0.2),
        width: 1,
      ),
    ),
    child: ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF1E4F4F), Color(0xFF307777), Color(0xFF21CBC1)],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: const Text(
        'quantum possibilities',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
          height: 1.2,
        ),
      ),
    ),
  );
}

// =============================================================================
//  Design 17 — Circle Monogram + GrandHotel Script
// =============================================================================
Widget _buildCircleMonogram(bool isDark) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF1E4F4F), Color(0xFF21CBC1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: PRIMARY_COLOR.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'qp',
            style: TextStyle(
              fontFamily: 'GrandHotel',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF1E4F4F), Color(0xFF307777), Color(0xFF21CBC1)],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: const Text(
          'quantum possibilities',
          style: TextStyle(
            fontFamily: 'GrandHotel',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ),
    ],
  );
}

// =============================================================================
//  Design 18 — Vertical Bar Accent (teal bar | text)
// =============================================================================
Widget _buildVerticalBar(bool isDark) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 3,
        height: 24,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF307777), Color(0xFF21CBC1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        'quantum possibilities',
        style: TextStyle(
          fontFamily: 'SfProDisplay',
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF1E4F4F),
          letterSpacing: -0.3,
          height: 1.2,
        ),
      ),
    ],
  );
}

// =============================================================================
//  Design 19 — Handwritten Casual (CedarvilleCursive)
// =============================================================================
Widget _buildHandwritten(bool isDark) {
  return ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [Color(0xFF1E4F4F), Color(0xFF307777), Color(0xFF21CBC1)],
      stops: [0.0, 0.45, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(bounds),
    child: const Text(
      'quantum possibilities',
      style: TextStyle(
        fontFamily: 'CedarvilleCursive',
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        height: 1.3,
      ),
    ),
  );
}

// =============================================================================
//  Design 20 — Script Solid Clean Teal (no gradient, pure solid color)
// =============================================================================
Widget _buildScriptSolidTeal(bool isDark) {
  return Text(
    'quantum possibilities',
    style: TextStyle(
      fontFamily: 'GrandHotel',
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: isDark ? const Color(0xFF3CB3AA) : PRIMARY_COLOR,
      height: 1.2,
    ),
  );
}

// =============================================================================
//  Design 21 — Script Large + Letter-Spaced (airier, more readable)
// =============================================================================
Widget _buildScriptLargeSpaced(bool isDark) {
  return ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [Color(0xFF1E4F4F), Color(0xFF307777), Color(0xFF21CBC1)],
      stops: [0.0, 0.45, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds),
    child: const Text(
      'quantum possibilities',
      style: TextStyle(
        fontFamily: 'GrandHotel',
        fontSize: 27,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 1.2,
        height: 1.2,
      ),
    ),
  );
}

// =============================================================================
//  Design 22 — Script + Subtle Shadow (adds depth & readability)
// =============================================================================
Widget _buildScriptSubtleShadow(bool isDark) {
  return Text(
    'quantum possibilities',
    style: TextStyle(
      fontFamily: 'GrandHotel',
      fontSize: 25,
      fontWeight: FontWeight.w600,
      color: isDark ? const Color(0xFF3CB3AA) : const Color(0xFF1E4F4F),
      height: 1.2,
      shadows: [
        Shadow(
          color: PRIMARY_COLOR.withValues(alpha: isDark ? 0.4 : 0.18),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
  );
}

// =============================================================================
//  Design 23 — Script Dark Teal (deeper, bolder teal gradient)
// =============================================================================
Widget _buildScriptDarkTeal(bool isDark) {
  return ShaderMask(
    shaderCallback: (bounds) => LinearGradient(
      colors: isDark
          ? [const Color(0xFF4DD8CE), const Color(0xFF21CBC1)]
          : [const Color(0xFF0D4F4F), const Color(0xFF1A6B6B)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(bounds),
    child: const Text(
      'quantum possibilities',
      style: TextStyle(
        fontFamily: 'GrandHotel',
        fontSize: 25,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.2,
      ),
    ),
  );
}

// =============================================================================
//  Design 24 — Script Two-Tone ("quantum" gradient, "possibilities" muted)
// =============================================================================
Widget _buildScriptTwoTone(bool isDark) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF1E4F4F), Color(0xFF21CBC1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: const Text(
          'quantum ',
          style: TextStyle(
            fontFamily: 'GrandHotel',
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ),
      Text(
        'possibilities',
        style: TextStyle(
          fontFamily: 'GrandHotel',
          fontSize: 25,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
          height: 1.2,
        ),
      ),
    ],
  );
}

// =============================================================================
//  Design 25 — Script Compact (smaller, tighter for a cleaner AppBar fit)
// =============================================================================
Widget _buildScriptCompact(bool isDark) {
  return ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [Color(0xFF287070), Color(0xFF307777)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(bounds),
    child: const Text(
      'quantum possibilities',
      style: TextStyle(
        fontFamily: 'GrandHotel',
        fontSize: 21,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.3,
        height: 1.15,
      ),
    ),
  );
}

// =============================================================================
//  Design 26 — Script Horizontal Gradient (clean left→right teal-to-cyan)
// =============================================================================
Widget _buildScriptHorizontalGradient() {
  return ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [
        Color(0xFF307777),
        Color(0xFF21CBC1),
        Color(0xFF06B6D4),
      ],
      stops: [0.0, 0.6, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(bounds),
    child: const Text(
      'quantum possibilities',
      style: TextStyle(
        fontFamily: 'GrandHotel',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.2,
      ),
    ),
  );
}

// =============================================================================
//  Design 27 — Script + Thin Underline Accent
// =============================================================================
Widget _buildScriptThinUnderline(bool isDark) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF1E4F4F), Color(0xFF307777), Color(0xFF21CBC1)],
          stops: [0.0, 0.45, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: const Text(
          'quantum possibilities',
          style: TextStyle(
            fontFamily: 'GrandHotel',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ),
      const SizedBox(height: 2),
      Container(
        height: 1.5,
        width: 80,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF307777), Color(0xFF21CBC1)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    ],
  );
}

// =============================================================================
//  Design Card Wrapper
// =============================================================================

class _DesignCard extends StatelessWidget {
  final int index;
  final String label;
  final Widget child;
  final Color cardBg;
  final Color labelColor;
  final bool isDark;

  const _DesignCard({
    required this.index,
    required this.label,
    required this.child,
    required this.cardBg,
    required this.labelColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: index == 0
            ? Border.all(color: PRIMARY_COLOR.withValues(alpha: 0.4), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Label row ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: index == 0
                        ? PRIMARY_COLOR
                        : (isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: index == 0 ? Colors.white : labelColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                ),
                if (index == 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: PRIMARY_COLOR.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: PRIMARY_COLOR,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // ── Preview area (simulates AppBar-like context) ──────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Center(child: child),
          ),
        ],
      ),
    );
  }
}
