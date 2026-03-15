



import 'package:flutter/material.dart';
import 'post_background.dart';


List<Color> postListColor = [
  // ── Row 0: Neutral (no background) ──────────────────────────────────
  const Color(0xFFF8F6F6), // off-white / none

  // ── Row 1: Soft Pastels ─────────────────────────────────────────────
  const Color(0xFFFFC3D6), // blush pink
  const Color(0xFFD4A5FF), // soft lavender
  const Color(0xFFA8D8EA), // baby blue
  const Color(0xFFB5EAD7), // mint green
  const Color(0xFFFFDAB9), // peach puff

  // ── Row 2: Warm & Rich ─────────────────────────────────────────────
  const Color(0xFFE74C3C), // crimson red
  const Color(0xFFFF6B35), // sunset orange
  const Color(0xFFF39C12), // golden amber
  const Color(0xFFE91E63), // vibrant pink
  const Color(0xFFFF1493), // deep pink

  // ── Row 3: Cool & Jewel Tones ───────────────────────────────────────
  const Color(0xFF2C3E50), // midnight blue
  const Color(0xFF1ABC9C), // turquoise
  const Color(0xFF3498DB), // ocean blue
  const Color(0xFF8E44AD), // royal purple
  const Color(0xFF16A085), // teal jade

  // ── Row 4: Deep & Moody ─────────────────────────────────────────────
  const Color(0xFF0C0C0B), // near black
  const Color(0xFF2D1B69), // deep indigo
  const Color(0xFF1B4332), // forest green
  const Color(0xFF4A0E0E), // dark burgundy
  const Color(0xFF1A1A2E), // dark navy

  // ── Row 5: Trendy & Vibrant ─────────────────────────────────────────
  const Color(0xFF6C5CE7), // electric purple
  const Color(0xFF00B894), // emerald
  const Color(0xFFFDCB6E), // warm yellow
  const Color(0xFF0984E3), // bright blue
  const Color(0xFFE17055), // terracotta
];

// =============================================================================
// Decorative Gradient Backgrounds — Facebook-style
// =============================================================================

final List<PostBackground> postGradientBackgrounds = [
  // ── Row 1: Dreamy & Soft ────────────────────────────────────────────
  PostBackground.gradient(
    colors: [const Color(0xFFFAD0C4), const Color(0xFFFFD1FF)],
    angle: 135,
  ), // peach to pink
  PostBackground.gradient(
    colors: [const Color(0xFFA18CD1), const Color(0xFFFBC2EB)],
    angle: 135,
  ), // purple to pink
  PostBackground.gradient(
    colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
    angle: 135,
  ), // indigo to purple
  PostBackground.gradient(
    colors: [const Color(0xFFD4A574), const Color(0xFFE8C99B)],
    angle: 180,
  ), // warm sand
  PostBackground.gradient(
    colors: [const Color(0xFF89216B), const Color(0xFFDA4453)],
    angle: 135,
  ), // berry to rose

  // ── Row 2: Bold & Vibrant ──────────────────────────────────────────
  PostBackground.gradient(
    colors: [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)],
    angle: 135,
  ), // dark ocean
  PostBackground.gradient(
    colors: [const Color(0xFF4B6CB7), const Color(0xFF182848)],
    angle: 180,
  ), // steel blue
  PostBackground.gradient(
    colors: [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)],
    angle: 135,
  ), // coral to yellow
  PostBackground.gradient(
    colors: [const Color(0xFFEB3349), const Color(0xFFF45C43)],
    angle: 135,
  ), // hot red
  PostBackground.gradient(
    colors: [const Color(0xFFA8FF78), const Color(0xFF78FFD6)],
    angle: 135,
  ), // neon green

  // ── Row 3: Elegant & Calm ──────────────────────────────────────────
  PostBackground.gradient(
    colors: [const Color(0xFFFFF1EB), const Color(0xFFACE0F9)],
    angle: 135,
  ), // cream to sky
  PostBackground.gradient(
    colors: [const Color(0xFFE8D5B7), const Color(0xFF8693AB)],
    angle: 180,
  ), // beige to blue grey
  PostBackground.gradient(
    colors: [const Color(0xFFC9D6FF), const Color(0xFFE2E2E2)],
    angle: 180,
  ), // soft periwinkle
  PostBackground.gradient(
    colors: [const Color(0xFFF5AF19), const Color(0xFFF12711)],
    angle: 135,
  ), // golden sunset
  PostBackground.gradient(
    colors: [const Color(0xFF200122), const Color(0xFF6F0000)],
    angle: 180,
  ), // dark wine

  // ── Row 4: Instagram & Trendy ──────────────────────────────────────
  PostBackground.gradient(
    colors: [const Color(0xFFFC5C7D), const Color(0xFF6A82FB)],
    angle: 135,
  ), // pink to blue
  PostBackground.gradient(
    colors: [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
    angle: 135,
  ), // green to teal
  PostBackground.gradient(
    colors: [const Color(0xFFFA709A), const Color(0xFFFEE140)],
    angle: 135,
  ), // pink to yellow
  PostBackground.gradient(
    colors: [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
    angle: 135,
  ), // sky to cyan
  PostBackground.gradient(
    colors: [const Color(0xFFF093FB), const Color(0xFFF5576C)],
    angle: 135,
  ), // magenta to coral

  // ── Row 5: Deep & Atmospheric ──────────────────────────────────────
  PostBackground.gradient(
    colors: [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
    angle: 135,
  ), // violet to blue
  PostBackground.gradient(
    colors: [const Color(0xFF1D2B64), const Color(0xFFF8CDDA)],
    angle: 180,
  ), // midnight to blush
  PostBackground.gradient(
    colors: [const Color(0xFFFF9A9E), const Color(0xFFFECFEF)],
    angle: 180,
  ), // soft rose
  PostBackground.gradient(
    colors: [const Color(0xFF0250C5), const Color(0xFFD43F8D)],
    angle: 135,
  ), // royal blue to magenta
  PostBackground.gradient(
    colors: [const Color(0xFFFFAFBD), const Color(0xFFFFC3A0)],
    angle: 135,
  ), // peach blush
];
