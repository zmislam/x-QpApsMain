/// Reels V2 Integration Configuration
/// Controls whether V2 has fully replaced V1 across the app.
///
/// Phase 12: Both V1 and V2 coexist — `useV2AsDefault = false`
/// Phase 12B: V2 replaces V1 — set `useV2AsDefault = true`
///
/// HOW TO ACTIVATE Phase 12B:
/// 1. Set `useV2AsDefault = true` below
/// 2. Rebuild the app
/// 3. V2 replaces V1 everywhere (nav, profiles, search, notifications)
class ReelsV2IntegrationConfig {
  ReelsV2IntegrationConfig._();

  /// Master toggle: when `true`, V2 is the default experience everywhere.
  /// Set to `true` ONLY after V1 vs V2 comparison is complete and approved.
  static const bool useV2AsDefault = false;

  /// Whether the create menu "Reel" button opens V2 camera.
  static bool get useV2Camera => useV2AsDefault;

  /// Whether profile views show V2 reel grid.
  static bool get useV2ProfileGrid => useV2AsDefault;

  /// Whether newsfeed shows V2 reel preview cards.
  static bool get useV2NewsfeedCards => useV2AsDefault;

  /// Whether advance search uses V2 search.
  static bool get useV2Search => useV2AsDefault;

  /// Whether notification taps open V2 reel detail.
  static bool get useV2Notifications => useV2AsDefault;
}
