# Pending Implementation: Dynamic Force Update Improvements

This document outlines the required changes to make the "Hard Force Update" feature platform-independent for both Android and iOS.

## Current Issue
The existing `VersionCheckerService` is Android-centric in its fallback and manual checking logic. It hardcodes Play Store URLs and doesn't provide a reliable scraping fallback for iOS users.

## Proposed Changes

### [Flutter App]

#### 1. Refactor `VersionCheckerService` (`lib/app/services/versionCheckerService.dart`)
- **Dynamic Platform Detection**: Update the service to check the device platform (`Platform.isIOS` or `Platform.isAndroid`) and use the correct Store ID.
- **Platform-Aware Fallback**:
    - **Android**: Use `https://play.google.com/store/apps/details?id=com.quanumpossibilities.qp`.
    - **iOS**: Use the App Store Lookup API or page scraping for `itunes.apple.com`.
- **Global Store Getter**: Implement a getter for the store link that returns the correct URL based on the platform.
- **Improved Dialog Redirection**: Fix `_showSimpleUpdateDialog` so that tapping "Update Now" on an iPhone correctly opens the App Store instead of the Play Store.

#### 2. Refine Version Comparison
- Update `_shouldUpdate` to handle edge cases where version names might be formatted differently or include build numbers in non-standard ways.

## Verification Plan (For Future Use)

### Manual Verification
1. **Force Dialog Trigger**: Decrease the version in `pubspec.yaml` (e.g., to `1.0.0`) and run the app.
2. **Platform Link Check**:
    - On **Android Emulator**: Verify button opens Google Play.
    - On **iOS Simulator/Device**: Verify button opens App Store.
3. **Blocking Test**: Ensure the dialog cannot be dismissed until the app is updated.

---
*Created: February 22, 2026*
