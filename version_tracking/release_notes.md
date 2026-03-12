# Release Notes - Feb 2026

## Features & Fixes (Combined)

### Social & Discovery
- **People You May Know**: Fixed initialization issues in `HomeController`.
- **Suggested Pages**: Implemented missing `suggestedPageList` and follow logic.
- **Friend Requests**: Verified friend request sending flow.

### Media & Reels
- **Reels Thumbnails**: Added missing `video_thumbnail` field to `ReelsDataModel` to fix feed rendering.
- **UI Consistency**: Ensured cards and list views handle missing data gracefully.

### Under the Hood
- **Independent Versioning**: iOS and Android now maintain separate build numbers.
- **Production Signing**: Properly configured `DEVELOPMENT_TEAM` for iOS production builds.
