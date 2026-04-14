# QP Reels V2 — Comprehensive Build Plan
### Clone Best of Facebook Reels + Instagram Reels (Mixed)

> **🔒 LOCKED FOR IMPLEMENTATION — April 14, 2026 (v1.0-final)**  
> This plan has been reviewed, audited, and locked. All gaps resolved. No further changes unless a blocking issue is discovered during implementation. Any deviation must be documented with rationale.

**Project:** x-QpApsMain (Flutter / GetX)  
**Created:** April 14, 2026  
**Locked:** April 14, 2026  
**Status:** 🔒 Locked for Implementation  
**Module Path:** `lib/app/modules/reelsV2/`  
**Existing V1 Location:** `lib/app/modules/NAVIGATION_MENUS/reels/` (untouched — V2 is a clean build)

---

## Table of Contents

1. [Feature Gap Analysis — Facebook vs Instagram vs QP V1](#1-feature-gap-analysis)
2. [Reels V2 Feature Inventory (All Features)](#2-reels-v2-feature-inventory)
3. [Architecture Blueprint](#3-architecture-blueprint)
4. [Module & File Structure](#4-module--file-structure)
5. [Phase Breakdown (Implementation Order)](#5-phase-breakdown)
   - Phase 0B: Backend Foundation (NEW V2 API — before any Flutter)
   - Phase 0–13: Flutter Implementation + CampaignV2 Integration
6. [Backend API Requirements (Full Isolation Architecture)](#6-backend-api-requirements)
   - 6A: V1 → V2 Isolation Architecture (WHY & HOW)
   - 6B: New V2 API Endpoints (~70+)
7. [Data Models (Mongoose Schemas + Dart Models)](#7-data-models)
   - 7A: MongoDB Schemas (14 NEW collections)
   - 7B: Flutter Client Models (Dart)
8. [Design System & UI/UX (Premium Modern Design)](#8-design-system--uiux)
9. [Sponsored & Promoted Reels (CampaignV2 Integration)](#9-sponsored--promoted-reels)
10. [Performance & Scalability Strategy](#10-performance--scalability-strategy)
11. [Navigation & V1/V2 Comparison Strategy](#11-navigation--v1v2-comparison-strategy)
12. [Migration & Rollout Strategy](#12-migration--rollout-strategy)
13. [Testing Strategy](#13-testing-strategy)
14. [Security & Content Moderation](#14-security--content-moderation)
- Appendix A: Route Plan
- Appendix B: Packages
- Appendix C: File Count Summary

---

## 1. Feature Gap Analysis

### Feature Comparison Matrix

| Feature | Instagram Reels | Facebook Reels | QP V1 | QP V2 Target |
|---------|:-:|:-:|:-:|:-:|
| **PLAYBACK** |||||
| Full-screen vertical swipe feed | ✅ | ✅ | ✅ | ✅ |
| Double-tap to like | ✅ | ✅ | ❌ | ✅ |
| Long-press to pause/preview | ✅ | ✅ | ❌ | ✅ |
| Seek bar / scrubber | ✅ | ✅ | ❌ | ✅ |
| Auto-loop with count | ✅ | ✅ | ✅ | ✅ |
| Volume gesture (swipe up/down) | ❌ | ❌ | ❌ | ✅ |
| Playback speed toggle (viewer) | ❌ | ❌ | ❌ | ✅ |
| Pinch-to-zoom | ✅ | ❌ | ❌ | ✅ |
| Smart preloading (3-5 ahead) | ✅ | ✅ | ✅ (3) | ✅ (5) |
| Immersive mode (hide UI on tap) | ✅ | ✅ | ❌ | ✅ |
| **FEED & DISCOVERY** |||||
| For You (algorithm) | ✅ | ✅ | ✅ | ✅ |
| Following feed | ✅ | ✅ | ✅ | ✅ |
| Trending / Explore feed | ✅ | ✅ | ✅ | ✅ |
| Hashtag feed (tap hashtag → feed) | ✅ | ✅ | ❌ | ✅ |
| Audio/Sound feed (tap sound → all reels with that sound) | ✅ | ✅ | ❌ | ✅ |
| Location-based reels | ❌ | ✅ | ❌ | ✅ |
| Topics/Interest-based categories | ❌ | ✅ | ❌ | ✅ |
| Suggested creators carousel | ✅ | ✅ | ✅ | ✅ |
| In-feed reel cards (newsfeed) | ✅ | ✅ | ✅ | ✅ |
| Reel series/playlists | ❌ | ✅ | ❌ | ✅ |
| **CREATION — CAMERA** |||||
| Multi-clip recording (segments) | ✅ | ✅ | ❌ | ✅ |
| Timer/countdown (3s, 10s) | ✅ | ✅ | ❌ | ✅ |
| Hands-free recording | ✅ | ✅ | ❌ | ✅ |
| Flash / torch toggle | ✅ | ✅ | ❌ | ✅ |
| Front/rear camera flip | ✅ | ✅ | ✅ | ✅ |
| Speed control (0.3x–3x) | ✅ | ✅ | ✅ | ✅ |
| Recording duration selector (15s/30s/60s/90s) | ✅ | ✅ | ❌ | ✅ |
| Gallery import (multi-select) | ✅ | ✅ | ✅ | ✅ |
| Photo to reel (slideshow mode) | ✅ | ✅ | ✅ | ✅ |
| Draft saving (auto & manual) | ✅ | ✅ | ❌ | ✅ |
| **CREATION — EDITING** |||||
| Trim / split clips | ✅ | ✅ | ✅ (basic) | ✅ (advanced) |
| Reorder clips on timeline | ✅ | ✅ | ❌ | ✅ |
| Clip-by-clip speed adjustment | ✅ | ✅ | ❌ | ✅ |
| Transitions between clips | ❌ | ✅ | ❌ | ✅ |
| **CREATION — AUDIO** |||||
| Music library (browse/search/categories) | ✅ | ✅ | ❌ | ✅ |
| Sound search | ✅ | ✅ | ❌ | ✅ |
| "Use this sound" (from other reels) | ✅ | ✅ | ❌ | ✅ |
| Original audio + music mix (dual audio) | ✅ | ✅ | ❌ | ✅ |
| Audio trim / seek for music clips | ✅ | ✅ | ❌ | ✅ |
| Voiceover recording | ✅ | ✅ | ❌ | ✅ |
| Sound effects library | ✅ | ✅ | ❌ | ✅ |
| Audio volume control (original vs added) | ✅ | ✅ | ❌ | ✅ |
| Saved sounds collection | ✅ | ✅ | ❌ | ✅ |
| Trending sounds badge | ✅ | ✅ | ❌ | ✅ |
| **CREATION — EFFECTS & OVERLAYS** |||||
| AR Camera filters/effects | ✅ | ✅ | ❌ | ✅ |
| Green screen (background replace) | ✅ | ✅ | ❌ | ✅ |
| Text overlays (animated, timed) | ✅ | ✅ | ✅ (basic) | ✅ (timed) |
| Stickers (GIF, emoji, poll, quiz) | ✅ | ✅ | ✅ (emoji) | ✅ (full) |
| Drawings / pen tool | ✅ | ✅ | ❌ | ✅ |
| Filters (color grading presets) | ✅ | ✅ | ❌ | ✅ |
| Brightness / contrast / saturation | ✅ | ✅ | ❌ | ✅ |
| Align tool (ghost overlay for transitions) | ✅ | ❌ | ❌ | ✅ |
| Templates (trending clip layouts) | ✅ | ✅ | ❌ | ✅ |
| **CREATION — COLLABORATION** |||||
| Remix / Duet (side-by-side) | ✅ | ✅ | ❌ | ✅ |
| Stitch (react to clip) | ❌ | ❌ | ❌ | ✅ |
| Collab (co-author) | ✅ | ❌ | ❌ | ✅ |
| **PUBLISHING** |||||
| Caption with hashtags & mentions | ✅ | ✅ | ✅ (partial) | ✅ |
| Location tagging | ✅ | ✅ | ❌ | ✅ |
| People tagging | ✅ | ✅ | ❌ | ✅ |
| Custom thumbnail (frame select + upload) | ✅ | ✅ | ❌ | ✅ |
| Topic/category selection | ❌ | ✅ | ❌ | ✅ |
| Cross-post to newsfeed | ✅ | ✅ | ✅ | ✅ |
| Cross-post to Stories | ✅ | ✅ | ❌ | ✅ |
| Schedule publishing | ✅ | ✅ | ❌ | ✅ |
| Privacy settings (Public/Friends/Private) | ✅ | ✅ | ✅ | ✅ |
| Comment controls (All/Friends/Off) | ✅ | ✅ | ✅ | ✅ |
| Remix permission toggle | ✅ | ✅ | ❌ | ✅ |
| Download permission toggle | ✅ | ✅ | ❌ | ✅ |
| **INTERACTIONS** |||||
| Like (single emoji) | ✅ | ❌ | ❌ | ✅ |
| Reactions (multiple emoji set) | ❌ | ✅ | ✅ | ✅ |
| Comments (threaded) | ✅ | ✅ | ✅ | ✅ |
| Pinned comment (creator) | ✅ | ✅ | ❌ | ✅ |
| Liked comments sort | ✅ | ✅ | ✅ | ✅ |
| Creator comment reply with reel | ✅ | ❌ | ❌ | ✅ |
| Share (DM, Stories, External) | ✅ | ✅ | ✅ (partial) | ✅ (full) |
| Share sheet (copy link, WhatsApp, etc.) | ✅ | ✅ | ❌ | ✅ |
| Save / Bookmark | ✅ | ✅ | ✅ | ✅ |
| Save to collection / folder | ✅ | ❌ | ❌ | ✅ |
| Not interested / hide | ✅ | ✅ | ❌ | ✅ |
| Report reel | ✅ | ✅ | ✅ | ✅ |
| Download reel | ✅ | ✅ | ❌ | ✅ |
| Embed link | ❌ | ✅ | ❌ | ✅ |
| View like/reaction list | ✅ | ✅ | ✅ | ✅ |
| **CREATOR TOOLS** |||||
| Insights / Analytics dashboard | ✅ | ✅ | ❌ | ✅ |
| Reach / Impressions | ✅ | ✅ | ❌ | ✅ |
| Plays count | ✅ | ✅ | ✅ | ✅ |
| Watch time / retention graph | ✅ | ✅ | ❌ | ✅ |
| Audience demographics | ✅ | ✅ | ❌ | ✅ |
| Top performing reels | ✅ | ✅ | ❌ | ✅ |
| Boost / Promote | ✅ | ✅ | ✅ | ✅ |
| Monetization status | ✅ | ✅ | ❌ | ✅ |
| Earnings per reel | ✅ | ✅ | ❌ | ✅ |
| A/B thumbnail testing | ❌ | ✅ | ❌ | ✅ |
| **SOCIAL FEATURES** |||||
| Follow from reel | ✅ | ✅ | ❌ | ✅ |
| Profile peek (long-press avatar) | ✅ | ❌ | ❌ | ✅ |
| Soundtrack page (see all reels with sound) | ✅ | ✅ | ❌ | ✅ |
| Hashtag page (see all reels with tag) | ✅ | ✅ | ❌ | ✅ |
| Effect page (see all reels with effect) | ✅ | ❌ | ❌ | ✅ |
| Challenges/Trends hub | ✅ | ✅ | ❌ | ✅ |
| **ACCESSIBILITY** |||||
| Auto-captions / subtitles | ✅ | ✅ | ❌ | ✅ |
| Caption translation | ✅ | ❌ | ❌ | ✅ |
| Alt text for reels | ✅ | ❌ | ❌ | ✅ |
| **SETTINGS & MANAGEMENT** |||||
| Auto-play ON/OFF | ✅ | ✅ | ❌ | ✅ |
| Data saver mode (lower quality) | ✅ | ✅ | ❌ | ✅ |
| Content preferences (interests) | ❌ | ✅ | ❌ | ✅ |
| Hidden words filter | ✅ | ✅ | ❌ | ✅ |
| Blocked accounts in comments | ✅ | ✅ | ❌ | ✅ |
| Watch history | ✅ | ✅ | ✅ | ✅ |
| Clear watch history | ❌ | ✅ | ❌ | ✅ |
| Liked reels collection | ✅ | ✅ | ❌ | ✅ |

---

## 2. Reels V2 Feature Inventory (All Features)

### A. Playback Engine
1. **Immersive Full-screen Player** — Edge-to-edge video, transparent status bar
2. **Smart Preloader** — 5-reel window (2 prev + current + 2 next), adaptive based on RAM/connection
3. **Double-tap Like** — Heart burst animation at tap position
4. **Long-press Preview** — Pause + show scrubber + dim overlay
5. **Seekbar/Scrubber** — Thin progress bar at bottom, expandable on touch
6. **Pinch-to-Zoom** — Scale up to 3x with pan
7. **Volume Gesture** — Swipe right side up/down for volume
8. **Brightness Gesture** — Swipe left side up/down for brightness
9. **Auto-loop** — Loop counter shown subtly
10. **Immersive Toggle** — Single tap hides all overlays, tap again shows
11. **Viewer Speed Toggle** — 0.5x / 1x / 1.5x / 2x in long-press menu
12. **Smart Pause** — Auto-pause when scrolled >50% off screen, when app backgrounded, when dialog opens
13. **Mute/Unmute Toggle** — Tap speaker icon, persists across reels
14. **Adaptive Quality** — Auto-adjust resolution based on network speed (360p/480p/720p/1080p)
15. **Loading Shimmer** — Skeleton UI while video buffers (not just spinner)

### B. Feed & Discovery System  
1. **For You Feed** — ML-ranked personalized feed (primary tab)
2. **Following Feed** — Chronological from followed accounts
3. **Trending Feed** — Algorithmically trending reels (time-decay weighted)
4. **Hashtag Feed** — Tap any hashtag → open dedicated feed of reels with that tag
5. **Sound/Audio Feed** — Tap sound name → all reels using that sound
6. **Location Feed** — Tap location tag → reels from that place
7. **Topic Channels** — Category feeds (Comedy, Music, Food, Sports, DIY, Education, etc.)
8. **Creator Spotlight** — Suggested creator carousels between reels
9. **Challenges/Trends Hub** — Dedicated screen for active challenges with "Join" CTA
10. **Related Reels** — "More like this" at end of single-reel view
11. **Search** — Unified search: reels, sounds, hashtags, creators, effects
12. **Reel Series/Playlists** — Creators can group reels into ordered playlists
13. **In-Feed Cards** — Reel preview cards in main newsfeed (auto-play on visibility)

### C. Camera & Recording
1. **Multi-Segment Recording** — Record multiple clips, each shown as segment on progress bar
2. **Duration Selector** — 15s / 30s / 60s / 90s max recording length
3. **Recording Timer** — 3s or 10s countdown before recording starts
4. **Hands-free Mode** — Tap once to start, tap to stop (no hold required)
5. **Speed Controls** — 0.3x / 0.5x / 1x / 2x / 3x recording speed
6. **Camera Flip** — Front ↔ Rear with smooth animation
7. **Flash/Torch** — Off / On / Auto modes
8. **Zoom** — Pinch or vertical slide to zoom while recording
9. **Gallery Import** — Multi-select photos/videos from device gallery
10. **Photo Slideshow** — Multiple photos → auto-generate reel with transitions + music
11. **Segment Undo** — Delete last recorded segment
12. **Draft Auto-save** — Recording progress saved automatically, resume later

### D. Editing Suite
1. **Timeline Editor** — Visual timeline with clip thumbnails, drag to reorder
2. **Trim/Split** — Per-clip trimming with frame-accurate preview
3. **Clip Speed** — Per-clip speed adjustment (0.3x–3x)
4. **Transitions** — Fade, dissolve, slide, zoom, swipe between clips
5. **Text Overlays** — Multiple text layers, each with:
   - Font selection (15+ fonts)
   - Color picker (full spectrum)
   - Background color/transparency
   - Text animation (typewriter, fade-in, bounce, slide)
   - Duration/timing (when text appears/disappears)
   - Position & rotation via drag
6. **Stickers** — GIF stickers (Giphy integration), emoji, polls, quiz, countdown, mention, location, hashtag
7. **Drawing/Pen Tool** — Freehand drawing with brush size, color, eraser
8. **Filters** — 30+ color grading presets (cinematic, vintage, warm, cool, B&W, etc.)
9. **Adjustments** — Brightness, contrast, saturation, warmth, vignette, sharpen, fade
10. **Align Tool** — Ghost overlay of last frame for seamless multi-clip transitions
11. **Templates** — Pre-made trending clip layouts with beat-synced markers
12. **Green Screen** — Replace background with image/video from gallery
13. **AR Effects** — Face filters, background effects, interactive overlays
14. **Voiceover** — Record narration over edited video
15. **Text-to-Speech** — Auto-generate voiceover from on-screen text

### E. Audio/Sound System
1. **Music Library** — Browse by mood, genre, trending, saved
2. **Sound Search** — Search by song name, artist, lyrics
3. **Use This Sound** — One-tap from any reel to create with same sound
4. **Original Audio** — Keep video's original audio track
5. **Dual Audio Mix** — Blend original audio + music with independent volume sliders
6. **Audio Trim** — Select specific section of a song
7. **Voiceover Layer** — Additional narration track over music + original
8. **Sound Effects** — Whoosh, pop, ding, applause, etc.
9. **Saved Sounds** — Personal collection of bookmarked sounds
10. **Trending Sounds** — 🔥 badge on currently viral audio tracks
11. **Sound Attribution** — "Original audio - @username" shown on reel
12. **Soundtrack Page** — Tap sound → see usage count, all reels, "Use this audio" CTA

### F. Publishing & Distribution
1. **Caption Editor** — Rich text with inline #hashtags and @mentions (autocomplete)
2. **Cover/Thumbnail** — Pick frame from video OR upload custom image
3. **A/B Thumbnail Test** — Upload 2 thumbnails, auto-select winner after 1000 views
4. **Location Tag** — Search & attach location
5. **People Tag** — Tag users appearing in the reel
6. **Topic/Category** — Select up to 3 relevant topics
7. **Privacy** — Public / Friends Only / Private
8. **Comment Controls** — Everyone / Friends / Off
9. **Remix Permissions** — Allow / Disable remixing of your reel
10. **Download Permission** — Allow / Disable others downloading your reel
11. **Cross-post to Feed** — Toggle "Also post to newsfeed"
12. **Cross-post to Stories** — Toggle "Also share to story"
13. **Schedule** — Pick date/time for future publishing
14. **Draft Management** — Save to drafts, edit later, drafts list view
15. **Collab/Co-author** — Invite co-author (appears on both profiles)

### G. Interactions & Engagement
1. **Double-tap Like** — Heart burst animation
2. **Reaction Picker** — Long-press like → expanded emoji reactions (like, love, haha, wow, sad, angry)
3. **Comments Sheet** — Bottom sheet with:
   - Threaded replies (2-level deep)
   - Sort: Top / Newest
   - Liked comments highlighting
   - Creator badges
   - Pinned comment (creator selects)
   - @mention autocomplete
   - GIF replies
   - Like/react on comments
4. **Creator Reply with Reel** — Reply to comment with a new reel
5. **Share Sheet** — Share to: DM, Stories, Newsfeed, Copy Link, WhatsApp, Telegram, SMS, More...
6. **Save/Bookmark** — Save to default collection or custom folders
7. **Collections Manager** — Create/rename/delete collection folders for saved reels
8. **"Not Interested"** — Feedback to algorithm, hide reel + similar
9. **"Why am I seeing this?"** — Transparency explainer
10. **Report** — Content/spam/harassment categories
11. **Download** — Save reel video to device (if creator allows)
12. **Follow/Unfollow** — Inline follow button on reel overlay
13. **Profile Peek** — Long-press avatar → mini profile card (bio, stats, follow button)
14. **Embed Link** — Copy embeddable link for external sharing
15. **Reaction List** — View who reacted with what emoji

### H. Remix & Collaboration
1. **Remix (Duet)** — Side-by-side or top-bottom with original reel
2. **Stitch** — Use first 1-5 seconds of another reel, then record reaction
3. **Collab Post** — Co-author invite, dual profile attribution
4. **Remix Chain** — See full remix tree/chain (who remixed who)
5. **Green Screen Remix** — Use another reel as your green screen background

### I. Creator Analytics Dashboard
1. **Overview** — Total plays, likes, comments, shares, saves (7d/30d/90d/lifetime)
2. **Individual Reel Insights** — Per-reel detailed metrics
3. **Watch Time** — Average watch duration, retention curve graph
4. **Audience Reach** — Impressions, unique viewers, source breakdown (For You, Following, Hashtag, Sound, Share)
5. **Audience Demographics** — Age, gender, location, peak active hours
6. **Top Performing Reels** — Ranked by engagement rate
7. **Follower Growth** — Net new followers attributed to reels
8. **Sound Performance** — If creator has original sounds, track usage by others
9. **Monetization** — Earnings per reel, total reel earnings, bonus program status
10. **A/B Thumbnail Results** — View winner and engagement diff
11. **Export Data** — Download analytics as CSV

### J. Monetization & Promotions (CampaignV2 Integration)
1. **Boost/Promote Reel** — Full boost flow integrated with CampaignV2 backend (budget, targeting, schedule, CTA)
2. **Sponsored Reel in Feed** — Fetch from `GET /api/campaigns-v2/serve?placement=Reels`, merge 1 per 5-7 organic
3. **"Sponsored" Label** — Non-removable badge (legal compliance), positioned below author name
4. **CTA Button** — Dynamic from `Ad.call_to_action` (Shop Now, Learn More, Sign Up, etc.)
5. **Destination URL** — Opens in-app browser or deep link on CTA tap
6. **Impression Tracking** — Auto `POST /api/campaigns-v2/beacon` on reel view (≥1s watched)
7. **Click Tracking** — `POST /api/campaigns-v2/beacon` with event=click on CTA tap
8. **"Hide Ad" / "Not Interested"** — Negative feedback → beacon event=hide → suppress similar
9. **"Why This Ad?"** — Bottom sheet showing targeting reason (interests, demographics)
10. **Frequency Capping** — Client respects `AdSet.frequency_cap` (max N impressions/user/day)
11. **Budget Gating** — Ad stops appearing when daily budget exhausted (server-side)
12. **Boost Analytics** — Real-time impressions, clicks, reach, CTR from CampaignV2 analytics
13. **Boost Status Tracking** — Draft → Pending Review → Active → Paused → Completed
14. **Ad Engagement** — Reactions and comments on sponsored reels via AdEngagementController
15. **Creator Bonus Program** — Play-based earnings dashboard linked to earn dashboard
16. **Brand Partnership Label** — "Paid partnership with @brand" tag for influencer posts
17. **Shopping Tags** — Tag products in reel (marketplace integration)
18. **Tipping on Reels** — Tip creator directly from reel view (integrate Phase 6 tipping module)

### K. Accessibility & Settings
1. **Auto-captions** — Server-generated subtitles shown over video
2. **Caption Translation** — Translate captions to user's language
3. **Alt Text** — Creator can add alt-text description
4. **Auto-play Setting** — ON / WiFi Only / OFF
5. **Data Saver Mode** — Lower resolution on cellular
6. **Content Preferences** — Select interest topics for feed tuning
7. **Hidden Words Filter** — Block comments containing specific words
8. **Watch History** — View history with clear option
9. **Liked Reels** — View all previously liked reels
10. **Notification Preferences** — Granular reel notification controls

---

## 3. Architecture Blueprint

### Design Principles
- **V2 is 100% independent** — New module `reelsV2/`, V1 remains untouched
- **Clean Architecture layers** — Presentation → Domain → Data
- **Feature-first organization** — Each major area is a self-contained sub-module
- **Reactive state management** — GetX with `Rx<>`, `.obs`, `Obx()`
- **Repository pattern** — Single API gateway, services wrap repository
- **Offline-first** — Local caching for drafts, watched history, saved items
- **Performance-first** — 0-frame video start, background preloading, thumbnail caching

### Dependency Stack
```yaml
# Already in pubspec.yaml
video_player: ^2.9.2         # Core video engine
chewie: 1.8.1                # Player controls
camera: ^0.10.1              # Camera recording
audioplayers: ^6.1.0         # Audio playback
video_thumbnail: ^0.5.0      # Thumbnail generation
image_picker: ^1.0.7         # Gallery picker
file_picker: ^8.0.7          # File picker

# NEW — Required for V2
video_editor: ^3.0.0          # Timeline editing, trim, split
ffmpeg_kit_flutter: ^6.0.3    # Video processing, effects, merge clips, audio mix
just_audio: ^0.9.39           # Advanced audio (music library playback)
flutter_cache_manager: ^3.3.1 # Video/thumbnail caching
lottie: ^3.1.0                # Animations (heart burst, stickers)
giphy_get: ^3.5.3             # GIF sticker picker
flutter_colorpicker: ^1.1.0   # Color picker for text/drawing
google_mlkit_text_recognition: ^0.12.0  # Auto-caption OCR
photo_manager: ^3.2.2         # Gallery access (multi-select)
wechat_assets_picker: ^9.0.0  # Rich gallery picker (Instagram-style)
flutter_drawing_board: ^0.4.4 # Drawing/pen tool
shimmer: ^3.0.0               # Loading shimmer effects
cached_network_image: ^3.3.1  # Image caching (thumbnails)
share_plus: ^9.0.0            # Native share sheet
path_provider: ^2.1.3         # Local file storage
```

### State Architecture
```
ReelsV2 Module
├── ReelsV2MainController        — Tab navigation, feed switching
├── ReelsFeedController          — Feed pagination, preloading orchestration
├── ReelPlayerController         — Per-reel playback state (singleton pool)
├── ReelsCameraController        — Camera, recording, segments
├── ReelsEditorController        — Timeline, clips, effects, text, stickers
├── ReelsAudioController         — Music search, audio mixing, voiceover
├── ReelsPublishController       — Caption, tags, privacy, schedule, publish
├── ReelsDraftController         — Draft CRUD, auto-save
├── ReelsInteractionController   — Like, comment, share, save, report
├── ReelsCommentController       — Comment CRUD, pagination, sort, pin
├── ReelsSearchController        — Search reels, sounds, hashtags, creators
├── ReelsAnalyticsController     — Creator dashboard data
├── ReelsSettingsController      — User preferences
├── ReelsCollectionController    — Bookmark collections/folders
└── ReelsRemixController         — Duet, stitch, green screen remix
```

---

## 4. Module & File Structure

```
lib/app/modules/reelsV2/
│
├── bindings/
│   └── reels_v2_binding.dart                    # Main binding (lazy-loads controllers)
│
├── controllers/
│   ├── reels_v2_main_controller.dart            # Tab & navigation state
│   ├── reels_feed_controller.dart               # Feed data, pagination, preloading
│   ├── reel_player_controller.dart              # Video player pool management
│   ├── reels_interaction_controller.dart        # Likes, shares, saves, follows
│   └── reels_comment_controller.dart            # Comments, replies, pins
│
├── views/
│   ├── reels_v2_view.dart                       # Main full-screen view (tab host)
│   ├── reels_feed_view.dart                     # Vertical PageView feed
│   └── reel_detail_view.dart                    # Single reel deep-link view
│
├── widgets/
│   ├── player/
│   │   ├── reel_player_widget.dart              # Core video player
│   │   ├── reel_overlay.dart                    # UI overlay (actions, caption, progress)
│   │   ├── reel_seekbar.dart                    # Seekbar / scrubber
│   │   ├── reel_gesture_layer.dart              # Double-tap, long-press, swipe, pinch
│   │   ├── reel_loading_shimmer.dart            # Skeleton loading state
│   │   ├── double_tap_heart.dart                # Heart burst animation
│   │   └── reel_volume_brightness.dart          # Volume/brightness gesture indicator
│   ├── feed/
│   │   ├── feed_tab_bar.dart                    # For You / Following / Trending tabs
│   │   ├── creator_spotlight_card.dart          # Suggested creator carousel
│   │   ├── challenge_card.dart                  # Challenge/trend CTA card
│   │   ├── reel_feed_card.dart                  # In-newsfeed reel preview card
│   │   └── topic_channel_bar.dart               # Category/topic filter chips
│   ├── interaction/
│   │   ├── reel_action_bar.dart                 # Right-side action icons (like, comment, share, etc.)
│   │   ├── reel_caption_area.dart               # Caption + hashtags + mentions + sound
│   │   ├── reel_author_info.dart                # Avatar, name, follow button
│   │   ├── reel_sound_ticker.dart               # Spinning disc + sound name marquee
│   │   ├── reel_reaction_picker.dart            # Expanded emoji reaction picker
│   │   ├── profile_peek_card.dart               # Long-press avatar mini profile
│   │   ├── reel_share_sheet.dart                # Multi-channel share bottom sheet
│   │   └── not_interested_menu.dart             # "Not interested" + "Why this?" options
│   ├── comment/
│   │   ├── comment_sheet.dart                   # Full comment bottom sheet
│   │   ├── comment_tile.dart                    # Single comment row
│   │   ├── comment_reply_tile.dart              # Reply row (nested)
│   │   ├── comment_input_bar.dart               # Text input + mention + GIF picker
│   │   ├── pinned_comment_badge.dart            # "Pinned by creator" label
│   │   └── comment_sort_toggle.dart             # Top / Newest sort
│   └── common/
│       ├── reel_thumbnail.dart                  # Cached thumbnail widget
│       ├── follow_button.dart                   # Animated follow/unfollow
│       ├── verified_badge.dart                  # Verified creator badge
│       └── engagement_counter.dart              # Animated number display (likes, views)
│
├── camera/
│   ├── bindings/
│   │   └── reels_camera_binding.dart
│   ├── controllers/
│   │   └── reels_camera_controller.dart         # Recording, segments, timer, speed
│   ├── views/
│   │   └── reels_camera_view.dart               # Camera screen
│   └── widgets/
│       ├── camera_controls.dart                 # Capture, flip, flash, timer, speed
│       ├── segment_progress_bar.dart            # Multi-segment recording progress
│       ├── duration_selector.dart               # 15/30/60/90s pills
│       ├── recording_timer_overlay.dart         # 3/10s countdown
│       ├── gallery_picker_button.dart           # Open gallery (multi-select thumbnail)
│       └── zoom_slider.dart                     # Zoom control
│
├── editor/
│   ├── bindings/
│   │   └── reels_editor_binding.dart
│   ├── controllers/
│   │   ├── reels_editor_controller.dart         # Timeline state, clips, undo/redo
│   │   └── reels_effects_controller.dart        # Filters, adjustments, AR
│   ├── views/
│   │   ├── reels_editor_view.dart               # Main editing screen
│   │   └── reels_preview_view.dart              # Full preview before publish
│   └── widgets/
│       ├── timeline/
│       │   ├── clip_timeline.dart               # Horizontal scrolling timeline
│       │   ├── clip_thumbnail.dart              # Individual clip thumbnail in timeline
│       │   ├── trim_handle.dart                 # Drag handles for trimming
│       │   └── transition_picker.dart           # Transition type selector between clips
│       ├── text/
│       │   ├── text_editor_overlay.dart         # Add/edit text layers
│       │   ├── font_picker.dart                 # Font selection carousel
│       │   ├── text_animation_picker.dart       # Text animation style picker
│       │   └── text_timing_slider.dart          # When text appears/disappears
│       ├── sticker/
│       │   ├── sticker_picker.dart              # GIF/emoji/poll/quiz sticker browser
│       │   ├── draggable_sticker.dart           # Positioned, scalable, rotatable sticker
│       │   └── interactive_sticker.dart         # Poll/quiz/countdown stickers
│       ├── drawing/
│       │   ├── drawing_canvas.dart              # Freehand drawing overlay
│       │   ├── brush_picker.dart                # Brush size, color, type
│       │   └── eraser_tool.dart                 # Eraser mode
│       ├── filter/
│       │   ├── filter_carousel.dart             # Horizontal filter preview strip
│       │   ├── filter_preview_tile.dart         # Individual filter thumbnail
│       │   └── adjustment_sliders.dart          # Brightness, contrast, etc. sliders
│       ├── effect/
│       │   ├── ar_effect_browser.dart           # AR filter/effect gallery
│       │   ├── green_screen_picker.dart         # Background image/video selector
│       │   └── align_ghost_overlay.dart         # Ghost of last frame for alignment
│       └── template/
│           ├── template_browser.dart            # Browse trending templates
│           └── template_beat_marker.dart        # Beat-synced clip markers
│
├── audio/
│   ├── bindings/
│   │   └── reels_audio_binding.dart
│   ├── controllers/
│   │   └── reels_audio_controller.dart          # Music search, selection, mixing
│   ├── views/
│   │   ├── music_library_view.dart              # Browse music (mood, genre, trending)
│   │   ├── sound_search_view.dart               # Search songs, artists
│   │   └── soundtrack_page_view.dart            # All reels using a specific sound
│   └── widgets/
│       ├── music_tile.dart                      # Song row (art, name, artist, duration, preview)
│       ├── audio_trim_slider.dart               # Select section of song
│       ├── audio_mix_panel.dart                 # Dual volume sliders (original + music)
│       ├── voiceover_recorder.dart              # Record voiceover over timeline
│       ├── sound_effect_picker.dart             # Browse/select sound effects
│       ├── saved_sounds_list.dart               # User's saved sounds
│       └── trending_sound_badge.dart            # 🔥 trending indicator
│
├── publish/
│   ├── bindings/
│   │   └── reels_publish_binding.dart
│   ├── controllers/
│   │   └── reels_publish_controller.dart        # Caption, tags, privacy, schedule, submit
│   ├── views/
│   │   └── reels_publish_view.dart              # Publish settings screen
│   └── widgets/
│       ├── caption_editor.dart                  # Rich text with #hashtag and @mention autocomplete
│       ├── thumbnail_picker.dart                # Select frame or upload cover
│       ├── ab_thumbnail_selector.dart           # A/B thumbnail upload
│       ├── location_tag_picker.dart             # Search location
│       ├── people_tag_picker.dart               # Tag users
│       ├── topic_selector.dart                  # Category chips
│       ├── privacy_selector.dart                # Public / Friends / Private
│       ├── comment_control_selector.dart        # Comment permission
│       ├── remix_permission_toggle.dart         # Allow remix toggle
│       ├── download_permission_toggle.dart      # Allow download toggle
│       ├── cross_post_toggles.dart              # Feed + Stories toggles
│       ├── schedule_picker.dart                 # Date/time picker
│       └── collab_invite_picker.dart            # Invite co-author
│
├── drafts/
│   ├── bindings/
│   │   └── reels_draft_binding.dart
│   ├── controllers/
│   │   └── reels_draft_controller.dart          # Local draft CRUD, auto-save timer
│   ├── views/
│   │   └── reels_draft_view.dart                # Drafts grid with resume/delete
│   └── widgets/
│       └── draft_card.dart                      # Draft thumbnail + timestamp + resume CTA
│
├── remix/
│   ├── bindings/
│   │   └── reels_remix_binding.dart
│   ├── controllers/
│   │   └── reels_remix_controller.dart          # Duet/stitch layout, source reel ref
│   ├── views/
│   │   ├── remix_duet_view.dart                 # Side-by-side recording
│   │   └── remix_stitch_view.dart               # Clip-and-react recording
│   └── widgets/
│       ├── remix_layout_picker.dart             # Side-by-side / top-bottom / green screen
│       ├── remix_source_preview.dart            # Original reel preview
│       └── remix_chain_viewer.dart              # Full remix tree/lineage
│
├── analytics/
│   ├── bindings/
│   │   └── reels_analytics_binding.dart
│   ├── controllers/
│   │   └── reels_analytics_controller.dart      # Fetch & aggregate analytics
│   ├── views/
│   │   ├── reels_analytics_dashboard_view.dart  # Overview dashboard
│   │   └── reel_insight_view.dart               # Individual reel detail insights
│   └── widgets/
│       ├── plays_chart.dart                     # Plays over time (fl_chart)
│       ├── retention_curve.dart                 # Watch-time retention graph
│       ├── audience_demographics.dart           # Pie charts: age, gender, location
│       ├── reach_source_breakdown.dart          # Bar chart: For You, Following, etc.
│       ├── top_performing_list.dart             # Ranked reel list
│       ├── follower_growth_chart.dart           # Net follower gain from reels
│       ├── monetization_summary.dart            # Earnings overview
│       └── ab_thumbnail_result.dart             # A/B test winner comparison
│
├── search/
│   ├── bindings/
│   │   └── reels_search_binding.dart
│   ├── controllers/
│   │   └── reels_search_controller.dart         # Multi-type search (reels, sounds, tags, users)
│   ├── views/
│   │   ├── reels_search_view.dart               # Search screen with tab results
│   │   ├── hashtag_feed_view.dart               # #tag → all reels with that tag
│   │   └── location_feed_view.dart              # Location → all reels from there
│   └── widgets/
│       ├── search_bar_widget.dart               # Search input with filter chips
│       ├── search_result_reel.dart              # Reel result grid tile
│       ├── search_result_sound.dart             # Sound result row
│       ├── search_result_hashtag.dart           # Hashtag result row
│       └── search_result_creator.dart           # Creator result row
│
├── collection/
│   ├── controllers/
│   │   └── reels_collection_controller.dart     # Collection CRUD
│   ├── views/
│   │   ├── collections_view.dart                # All collections grid
│   │   └── collection_detail_view.dart          # Reels in a collection
│   └── widgets/
│       ├── collection_card.dart                 # Collection cover + count
│       └── collection_create_dialog.dart        # Create/rename dialog
│
├── settings/
│   ├── controllers/
│   │   └── reels_settings_controller.dart       # Preferences state
│   ├── views/
│   │   └── reels_settings_view.dart             # Settings screen
│   └── widgets/
│       ├── autoplay_toggle.dart
│       ├── data_saver_toggle.dart
│       ├── content_preferences.dart             # Interest topic selection
│       ├── hidden_words_editor.dart             # Blocked words list
│       └── notification_preferences.dart        # Reel notification toggles
│
├── sponsored/
│   ├── controllers/
│   │   └── reels_sponsored_controller.dart      # Fetch & merge sponsored reels from CampaignV2
│   ├── widgets/
│   │   ├── sponsored_reel_overlay.dart          # "Sponsored" badge + CTA button overlay
│   │   ├── sponsored_cta_button.dart            # Dynamic CTA (Shop Now, Learn More, etc.)
│   │   ├── why_this_ad_sheet.dart               # "Why am I seeing this?" bottom sheet
│   │   └── ad_feedback_menu.dart                # Hide ad, report ad options
│   ├── models/
│   │   └── sponsored_reel_model.dart            # Maps CampaignV2 Ad → reel display format
│   └── services/
│       └── reels_ad_serve_service.dart           # Wraps /campaigns-v2/serve + /beacon APIs
│
├── boost/
│   ├── bindings/
│   │   └── reels_boost_binding.dart
│   ├── controllers/
│   │   └── reels_boost_controller.dart          # Boost own reel (budget, targeting, submit)
│   ├── views/
│   │   └── reels_boost_view.dart                # Boost creation form (full-page)
│   └── widgets/
│       ├── boost_budget_selector.dart           # Budget slider + daily/lifetime toggle
│       ├── boost_audience_picker.dart           # Location, age, gender, interests targeting
│       ├── boost_schedule_picker.dart           # Start/end date picker
│       ├── boost_preview_card.dart              # Preview how boosted reel will look in feed
│       ├── boost_cta_selector.dart              # CTA dropdown (Learn More, Shop Now, etc.)
│       ├── boost_performance_card.dart          # Live performance stats (after launch)
│       └── boost_status_badge.dart              # Draft/Pending/Active/Paused/Completed badge
│
├── models/
│   ├── reel_v2_model.dart                       # Core reel data
│   ├── reel_comment_model.dart                  # Comment + reply
│   ├── reel_sound_model.dart                    # Sound/music track
│   ├── reel_hashtag_model.dart                  # Hashtag with usage count
│   ├── reel_effect_model.dart                   # AR effect metadata
│   ├── reel_draft_model.dart                    # Local draft schema
│   ├── reel_analytics_model.dart                # Analytics response
│   ├── reel_collection_model.dart               # Bookmark collection
│   ├── reel_remix_model.dart                    # Remix/duet metadata
│   ├── reel_template_model.dart                 # Template metadata
│   ├── reel_challenge_model.dart                # Challenge/trend data
│   ├── reel_series_model.dart                   # Playlist/series
│   └── reel_filter_model.dart                   # Filter/adjustment preset
│
├── services/
│   ├── reels_v2_api_service.dart                # All API calls (main)
│   ├── reels_v2_feed_service.dart               # Feed-specific API calls
│   ├── reels_v2_sound_service.dart              # Sound/music API calls
│   ├── reels_v2_analytics_service.dart          # Analytics API calls
│   ├── reels_v2_upload_service.dart             # Upload & processing
│   ├── reels_v2_cache_service.dart              # Local caching logic (GetStorage)
│   └── reels_v2_preload_service.dart            # Smart preloading engine
│
└── utils/
    ├── video_processor.dart                     # FFmpeg wrapper for effects, merge, trim
    ├── reel_constants.dart                      # All constants, durations, sizes
    ├── reel_enums.dart                          # Privacy, status, sort, filter enums
    └── reel_helpers.dart                        # Date formatting, duration display, etc.
```

**Total new files: ~175+ (with sponsored/boost modules)**

---

## 5. Phase Breakdown (Implementation Order)

> **⛔ BACKEND-FIRST RULE:** Phase 0B (Backend Foundation) MUST be completed before Phase 0 (Flutter Foundation). The Flutter app needs working V2 APIs to function. Build backend first, test with Postman/curl, then build Flutter UI against proven APIs.

### Phase Dependency Graph

```
Phase 0B (Backend) ──────┐
                         ▼
              Phase 0 (Flutter Foundation)
                         │
              ┌──────────┼──────────┐
              ▼          ▼          ▼
         Phase 1    Phase 2    Phase 3
        (Playback) (Interact) (Camera)
              │          │          │
              │          │          ▼
              │          │     Phase 4 (Editor) ───▶ Phase 5 (Filters)
              │          │          │
              │          │          ▼
              │          │     Phase 6 (Audio)
              │          │          │
              │          │          ▼
              │          ├────▶ Phase 7 (Publishing)
              │          │          │
              │          │          ▼
              │          │     Phase 8 (Remix)
              │          │
              ▼          ▼
         Phase 9 (Discovery/Search)  ◀── requires Phase 1 + 2
              │
              ▼
         Phase 10 (Analytics) ◀── requires Phase 7 (publish data)
              │
              ▼
         Phase 11 (Settings)
              │
              ▼
         Phase 12 (Navigation/Dual-Nav) ◀── requires Phase 0-2 minimum
              │
              ▼
         Phase 13 (Sponsored/Boost) ◀── requires Phase 1 + 7
              │
              ▼
         Phase 12B (Full Integration) ◀── ALL phases complete
```

**Parallel tracks after Phase 0:**
- **Track A (Playback):** Phase 1 → Phase 9 → Phase 10 → Phase 11
- **Track B (Creation):** Phase 3 → Phase 4 → Phase 5 → Phase 6 → Phase 7 → Phase 8
- **Track C (Interactions):** Phase 2 (can run alongside Track A/B)
- **Merge point:** Phase 12 requires Tracks A + C minimum. Phase 13 requires Track A + B.

### Phase 0B — Backend Foundation (NEW V2 API Server) ✅
**Status:** ✅ Complete  
**Priority:** CRITICAL — Must be done BEFORE any Flutter work  
**Files:** ~40 (all in `qp-api/`)

> **ISOLATION MANDATE:** Every file below is NEW. Zero imports from `controller/Reels/`, `models/Reels/`, or `services/ReelsRecommendationService.js`. See Section 6A for full isolation architecture.

| # | Task | Files (all new in qp-api/) |
|---|------|---------------------------|
| 1 | Create V2 model directory & core schema | `models/ReelsV2/ReelV2.js` |
| 2 | Comment model (threaded, self-ref) | `models/ReelsV2/ReelV2Comment.js` |
| 3 | Reaction model (unified reel+comment) | `models/ReelsV2/ReelV2Reaction.js` |
| 4 | Bookmark & Collection models | `models/ReelsV2/ReelV2Bookmark.js`, `ReelV2Collection.js` |
| 5 | Sound, Remix, Analytics models | `models/ReelsV2/ReelV2Sound.js`, `ReelV2Remix.js`, `ReelV2Analytics.js` |
| 6 | Watch history, Feedback, Series models | `models/ReelsV2/ReelV2WatchHistory.js`, `ReelV2Feedback.js`, `ReelV2Series.js` |
| 7 | Draft, Report, Settings models | `models/ReelsV2/ReelV2Draft.js`, `ReelV2Report.js`, `ReelV2Settings.js` |
| 8 | Standardized ApiResponse class | `utils/ApiResponse.js` (reusable: `ApiResponse.success()`, `.error()`, `.paginated()`) |
| 9 | V2 request validators | `validators/ReelsV2/reel.validator.js`, `comment.validator.js`, `collection.validator.js`, `settings.validator.js` |
| 10 | Feed controller (for-you, following, trending) | `controller/ReelsV2/ReelsV2FeedController.js` |
| 11 | CRUD controller (create, read, update, delete) | `controller/ReelsV2/ReelsV2CrudController.js` |
| 12 | Comment controller (threaded comments & replies) | `controller/ReelsV2/ReelsV2CommentController.js` |
| 13 | Reaction controller (reel + comment reactions) | `controller/ReelsV2/ReelsV2ReactionController.js` |
| 14 | Bookmark controller (save, unsave, collections) | `controller/ReelsV2/ReelsV2BookmarkController.js` |
| 15 | Share controller | `controller/ReelsV2/ReelsV2ShareController.js` |
| 16 | Tracking controller (views, impressions, watch time) | `controller/ReelsV2/ReelsV2TrackingController.js` |
| 17 | Upload controller (chunked upload + processing) | `controller/ReelsV2/ReelsV2UploadController.js` |
| 18 | Feed candidate service (clean recommendation engine) | `services/ReelsV2/ReelsV2FeedCandidateService.js` |
| 19 | Feed scoring service (engagement + personalization) | `services/ReelsV2/ReelsV2FeedScoringService.js` |
| 20 | Feed cache service (Redis with rv2:* prefix) | `services/ReelsV2/ReelsV2FeedCacheService.js` |
| 21 | Video service (upload, transcode, thumb, adaptive) | `services/ReelsV2/ReelsV2VideoService.js` |
| 22 | Notification service (V2-specific notifications) | `services/ReelsV2/ReelsV2NotificationService.js` |
| 23 | V2 route files (all 12 route files) | `routes/reels-v2/index.js`, `feed.routes.js`, `crud.routes.js`, `interaction.routes.js`, `sound.routes.js`, `remix.routes.js`, `collection.routes.js`, `analytics.routes.js`, `tracking.routes.js`, `series.routes.js`, `settings.routes.js`, `admin.routes.js` |
| 24 | Register V2 routes in main `index.js` | `index.js` — add `app.use('/api/v2/reels', require('./routes/reels-v2'))` |
| 25 | Socket V2 namespace setup | `socket/reels-v2/index.js`, `viewTracking.js`, `liveComments.js`, `realtimeReactions.js` |
| 26 | Basic test suite | `tests/reels-v2/feed.test.js`, `crud.test.js`, `comment.test.js`, `reaction.test.js`, `bookmark.test.js` |
| 27 | FFmpeg transcoding worker queue (Bull/BullMQ) | `queue/reelsV2TranscodeQueue.js`, `queue/workers/reelsV2TranscodeWorker.js` |
| 28 | Scheduled publish cron job | `cronjob/reelsV2ScheduledPublish.js` |
| 29 | Trending recomputation cron (every 5 min) | `cronjob/reelsV2TrendingCompute.js` |
| 30 | Analytics rollup cron (daily aggregation) | `cronjob/reelsV2AnalyticsRollup.js` |

**Acceptance Criteria:**
- [x] All 14 new MongoDB collections created with indexes (verify with `db.collection.getIndexes()`)
- [x] All V2 routes respond — test every endpoint with Postman
- [x] Create reel → returns reel object with id
- [x] Get feed (for-you, following, trending) → returns paginated reels with cursor
- [x] Add reaction → atomic `$inc` on reel's `like_count`, verify count matches actual reaction count
- [x] Add comment → creates in `reel_v2_comments`, atomic `$inc` on reel's `comment_count`
- [x] Add reply → creates comment with `parent_id`, atomic `$inc` on parent's `reply_count`
- [x] Bookmark → creates in `reel_v2_bookmarks`, atomic `$inc` on reel's `save_count`
- [x] Track view → creates in `reel_v2_analytics`, atomic `$inc` on reel's `view_count`
- [x] ZERO imports from `controller/Reels/`, `models/Reels/`, `services/ReelsRecommendation*`
- [x] All responses use `ApiResponse.success()` / `ApiResponse.error()` format
- [x] All write endpoints have validator middleware
- [x] Rate limiting active: 10 creates/min, 30 reactions/min, 20 comments/min
- [x] Socket namespace `/reels-v2` operational
- [x] All queries tested with `.explain()` — must use indexes (no COLLSCAN)

---

### Phase 0 — Flutter Foundation & Core Player ✅ 
**Status:** ✅ Complete  
**Priority:** CRITICAL — Everything depends on this  
**Files:** ~20

| # | Task | Files |
|---|------|-------|
| 1 | Create module structure & binding | `bindings/reels_v2_binding.dart` |
| 2 | Core data models | `models/reel_v2_model.dart`, `reel_comment_model.dart`, `reel_sound_model.dart` |
| 3 | Constants, enums, helpers | `utils/reel_constants.dart`, `reel_enums.dart`, `reel_helpers.dart` |
| 4 | Main API service | `services/reels_v2_api_service.dart` |
| 5 | Feed API service | `services/reels_v2_feed_service.dart` |
| 6 | Cache service | `services/reels_v2_cache_service.dart` |
| 7 | Preload service (5-reel window) | `services/reels_v2_preload_service.dart` |
| 8 | Main controller + Feed controller | `controllers/reels_v2_main_controller.dart`, `reels_feed_controller.dart` |
| 9 | Player controller (pool) | `controllers/reel_player_controller.dart` |
| 10 | Core player widget | `widgets/player/reel_player_widget.dart` |
| 11 | Loading shimmer | `widgets/player/reel_loading_shimmer.dart` |
| 12 | Main view + Feed view | `views/reels_v2_view.dart`, `reels_feed_view.dart` |
| 13 | Route registration | `app_routes.dart` + `app_pages.dart` (add REELS_V2) |

**Acceptance Criteria:**
- [x] Vertical swipe through reels in full-screen
- [x] Auto-play current, pause others
- [x] 5-reel preloading (2 prev + current + 2 next)
- [x] Shimmer loading state
- [x] Auto-loop with count
- [x] For You / Following / Trending feed tabs
- [x] Pagination with cursor-based infinite scroll
- [x] Basic API integration fetching real reel data

---

### Phase 1 — Playback UX & Gestures ✅
**Status:** ✅ Complete  
**Priority:** HIGH  
**Files:** ~12

| # | Task | Files |
|---|------|-------|
| 1 | Gesture detection layer | `widgets/player/reel_gesture_layer.dart` |
| 2 | Double-tap like animation | `widgets/player/double_tap_heart.dart` |
| 3 | Seekbar / scrubber | `widgets/player/reel_seekbar.dart` |
| 4 | Volume/brightness gesture | `widgets/player/reel_volume_brightness.dart` |
| 5 | Overlay (UI + immersive toggle) | `widgets/player/reel_overlay.dart` |
| 6 | Action bar (like, comment, share, save) | `widgets/interaction/reel_action_bar.dart` |
| 7 | Author info row | `widgets/interaction/reel_author_info.dart` |
| 8 | Caption area (expandable) | `widgets/interaction/reel_caption_area.dart` |
| 9 | Sound ticker (spinning disc) | `widgets/interaction/reel_sound_ticker.dart` |
| 10 | Engagement counters (animated) | `widgets/common/engagement_counter.dart` |
| 11 | Interaction controller | `controllers/reels_interaction_controller.dart` |
| 12 | Common widgets | `widgets/common/reel_thumbnail.dart`, `follow_button.dart`, `verified_badge.dart` |

**Acceptance Criteria:**
- [x] Double-tap anywhere → heart burst at tap position
- [x] Long-press → pause + dim overlay + show scrubber
- [x] Seekbar at bottom, expandable on touch
- [x] Pinch-to-zoom (up to 3x)
- [x] Single tap toggles overlay visibility (immersive mode)
- [x] Right-side action bar: like, comment, share, bookmark, more menu
- [x] Author row: avatar, name, follow button
- [x] Caption: truncated → "more" expansion, tappable hashtags/mentions
- [x] Spinning disc with sound name marquee

---

### Phase 2 — Interactions & Comments ✅
**Status:** ✅ Complete  
**Priority:** HIGH  
**Files:** ~16

| # | Task | Files |
|---|------|-------|
| 1 | Comment controller | `controllers/reels_comment_controller.dart` |
| 2 | Comment sheet | `widgets/comment/comment_sheet.dart` |
| 3 | Comment tile | `widgets/comment/comment_tile.dart` |
| 4 | Reply tile | `widgets/comment/comment_reply_tile.dart` |
| 5 | Comment input bar | `widgets/comment/comment_input_bar.dart` |
| 6 | Pinned comment badge | `widgets/comment/pinned_comment_badge.dart` |
| 7 | Comment sort toggle | `widgets/comment/comment_sort_toggle.dart` |
| 8 | Reaction picker | `widgets/interaction/reel_reaction_picker.dart` |
| 9 | Share sheet | `widgets/interaction/reel_share_sheet.dart` |
| 10 | Profile peek card | `widgets/interaction/profile_peek_card.dart` |
| 11 | Not interested menu | `widgets/interaction/not_interested_menu.dart` |
| 12 | Comment model | `models/reel_comment_model.dart` (update) |
| 13 | Reaction list view | `views/reel_detail_view.dart` |
| 14 | Save to collection | (placeholder, full in Phase 9) |

**Acceptance Criteria:**
- [x] Swipe up or tap comment icon → full comment sheet (60% height)
- [x] Threaded replies (2-level), paginated
- [x] Sort toggle: Top / Newest
- [x] Creator pin comment
- [x] @mention autocomplete in input
- [x] GIF reply option
- [x] Long-press reaction picker (6 emoji reactions)
- [x] Share sheet: DM, Stories, Feed, Copy Link, WhatsApp, More
- [x] Long-press avatar → profile peek card
- [x] "Not interested" + "Why am I seeing this?"
- [x] Report with category selection

---

### Phase 3 — Camera & Recording ✅
**Status:** ✅ Complete  
**Priority:** HIGH  
**Files:** ~12

| # | Task | Files |
|---|------|-------|
| 1 | Camera binding | `camera/bindings/reels_camera_binding.dart` |
| 2 | Camera controller | `camera/controllers/reels_camera_controller.dart` |
| 3 | Camera view | `camera/views/reels_camera_view.dart` |
| 4 | Camera controls | `camera/widgets/camera_controls.dart` |
| 5 | Segment progress bar | `camera/widgets/segment_progress_bar.dart` |
| 6 | Duration selector | `camera/widgets/duration_selector.dart` |
| 7 | Timer countdown overlay | `camera/widgets/recording_timer_overlay.dart` |
| 8 | Gallery picker button | `camera/widgets/gallery_picker_button.dart` |
| 9 | Zoom slider | `camera/widgets/zoom_slider.dart` |
| 10 | Draft model | `models/reel_draft_model.dart` |
| 11 | Route registration | Update routes for camera |
| 12 | Video processor util | `utils/video_processor.dart` |

**Acceptance Criteria:**
- [x] Full-screen camera preview (front/rear)
- [x] Multi-segment recording (tap segments on progress bar)
- [x] Duration limit selector (15/30/60/90s)
- [x] 3s / 10s countdown timer
- [x] Hands-free mode (tap to start/stop)
- [x] Speed control (0.3x–3x) per segment
- [x] Flash toggle (Off/On/Auto)
- [x] Pinch/slide zoom
- [x] Gallery multi-select (photos + videos)
- [x] Photo slideshow generation (multi-photo → video)
- [x] Undo last segment
- [x] Auto-save draft on back/exit

---

### Phase 4 — Editing Suite ✅
**Status:** ✅ COMPLETE  
**Priority:** HIGH  
**Files:** ~20

| # | Task | Files |
|---|------|-------|
| 1 | Editor binding | `editor/bindings/reels_editor_binding.dart` |
| 2 | Editor controller | `editor/controllers/reels_editor_controller.dart` |
| 3 | Effects controller | `editor/controllers/reels_effects_controller.dart` |
| 4 | Editor view | `editor/views/reels_editor_view.dart` |
| 5 | Preview view | `editor/views/reels_preview_view.dart` |
| 6 | Clip timeline | `editor/widgets/timeline/clip_timeline.dart` |
| 7 | Clip thumbnail | `editor/widgets/timeline/clip_thumbnail.dart` |
| 8 | Trim handle | `editor/widgets/timeline/trim_handle.dart` |
| 9 | Transition picker | `editor/widgets/timeline/transition_picker.dart` |
| 10 | Text editor overlay | `editor/widgets/text/text_editor_overlay.dart` |
| 11 | Font picker | `editor/widgets/text/font_picker.dart` |
| 12 | Text animation picker | `editor/widgets/text/text_animation_picker.dart` |
| 13 | Text timing slider | `editor/widgets/text/text_timing_slider.dart` |
| 14 | Sticker picker | `editor/widgets/sticker/sticker_picker.dart` |
| 15 | Draggable sticker | `editor/widgets/sticker/draggable_sticker.dart` |
| 16 | Interactive sticker (poll/quiz) | `editor/widgets/sticker/interactive_sticker.dart` |
| 17 | Drawing canvas | `editor/widgets/drawing/drawing_canvas.dart` |
| 18 | Brush picker | `editor/widgets/drawing/brush_picker.dart` |
| 19 | Eraser tool | `editor/widgets/drawing/eraser_tool.dart` |
| 20 | Route registration | Update routes for editor |

**Acceptance Criteria:**
- [ ] Horizontal scrollable timeline with clip thumbnails
- [ ] Drag-to-reorder clips
- [ ] Per-clip trim with frame-accurate handles
- [ ] Per-clip speed adjustment
- [ ] Transitions (fade, slide, zoom, dissolve) between clips
- [ ] Text overlay: add, edit, move, resize, rotate, animate, set timing
- [ ] 15+ fonts, full color picker, background opacity
- [ ] GIF stickers via Giphy, emoji stickers, mention/hashtag stickers
- [ ] Freehand drawing with brush size/color/type
- [ ] Eraser mode
- [ ] Undo/redo stack (up to 30 actions)

---

### Phase 5 — Filters, Effects & Green Screen ✅
**Status:** ✅ COMPLETE  
**Priority:** MEDIUM  
**Files:** ~10

| # | Task | Files |
|---|------|-------|
| 1 | Filter carousel | `editor/widgets/filter/filter_carousel.dart` |
| 2 | Filter preview tile | `editor/widgets/filter/filter_preview_tile.dart` |
| 3 | Adjustment sliders | `editor/widgets/filter/adjustment_sliders.dart` |
| 4 | AR effect browser | `editor/widgets/effect/ar_effect_browser.dart` |
| 5 | Green screen picker | `editor/widgets/effect/green_screen_picker.dart` |
| 6 | Align ghost overlay | `editor/widgets/effect/align_ghost_overlay.dart` |
| 7 | Template browser | `editor/widgets/template/template_browser.dart` |
| 8 | Template beat marker | `editor/widgets/template/template_beat_marker.dart` |
| 9 | Filter model | `models/reel_filter_model.dart` |
| 10 | Template model | `models/reel_template_model.dart` |

**Acceptance Criteria:**
- [ ] 30+ color grading filters (real-time preview)
- [ ] Adjustment sliders: brightness, contrast, saturation, warmth, vignette, sharpen, fade
- [ ] AR face filters (minimum 10 effects)
- [ ] Green screen: pick background image/video from gallery
- [ ] Align tool: ghost overlay of previous clip's last frame
- [ ] Template browser: trending templates with beat markers
- [ ] Apply template → auto-place clips at beat timestamps

---

### Phase 6 — Audio & Sound System ✅
**Status:** ✅ COMPLETE  
**Priority:** HIGH  
**Files:** ~14

| # | Task | Files |
|---|------|-------|
| 1 | Audio binding | `audio/bindings/reels_audio_binding.dart` |
| 2 | Audio controller | `audio/controllers/reels_audio_controller.dart` |
| 3 | Music library view | `audio/views/music_library_view.dart` |
| 4 | Sound search view | `audio/views/sound_search_view.dart` |
| 5 | Soundtrack page view | `audio/views/soundtrack_page_view.dart` |
| 6 | Music tile | `audio/widgets/music_tile.dart` |
| 7 | Audio trim slider | `audio/widgets/audio_trim_slider.dart` |
| 8 | Audio mix panel | `audio/widgets/audio_mix_panel.dart` |
| 9 | Voiceover recorder | `audio/widgets/voiceover_recorder.dart` |
| 10 | Sound effect picker | `audio/widgets/sound_effect_picker.dart` |
| 11 | Saved sounds list | `audio/widgets/saved_sounds_list.dart` |
| 12 | Trending sound badge | `audio/widgets/trending_sound_badge.dart` |
| 13 | Sound model | `models/reel_sound_model.dart` (update if needed) |
| 14 | Sound API service | `services/reels_v2_sound_service.dart` |

**Acceptance Criteria:**
- [ ] Music library: browse by mood, genre, trending, saved
- [ ] Search songs by name, artist, lyrics snippet
- [ ] Tap sound on any reel → "Use this sound" → camera with that sound
- [ ] Audio trim: select 15–90s section of a song
- [ ] Dual audio mix: original audio + music (independent volume sliders)
- [ ] Voiceover recording over edited video
- [ ] Sound effects library (10+ categories)
- [ ] Saved sounds collection
- [ ] Trending sounds badge (🔥)
- [ ] Soundtrack page: all reels using a specific sound

---

### Phase 7 — Publishing & Drafts ✅
**Status:** ✅ COMPLETE  
**Priority:** HIGH  
**Files:** ~18

| # | Task | Files |
|---|------|-------|
| 1 | Publish binding | `publish/bindings/reels_publish_binding.dart` |
| 2 | Publish controller | `publish/controllers/reels_publish_controller.dart` |
| 3 | Publish view | `publish/views/reels_publish_view.dart` |
| 4 | Caption editor | `publish/widgets/caption_editor.dart` |
| 5 | Thumbnail picker | `publish/widgets/thumbnail_picker.dart` |
| 6 | A/B thumbnail selector | `publish/widgets/ab_thumbnail_selector.dart` |
| 7 | Location tag picker | `publish/widgets/location_tag_picker.dart` |
| 8 | People tag picker | `publish/widgets/people_tag_picker.dart` |
| 9 | Topic selector | `publish/widgets/topic_selector.dart` |
| 10 | Privacy selector | `publish/widgets/privacy_selector.dart` |
| 11 | Comment control selector | `publish/widgets/comment_control_selector.dart` |
| 12 | Remix/download toggles | `publish/widgets/remix_permission_toggle.dart`, `download_permission_toggle.dart` |
| 13 | Cross-post toggles | `publish/widgets/cross_post_toggles.dart` |
| 14 | Schedule picker | `publish/widgets/schedule_picker.dart` |
| 15 | Collab invite | `publish/widgets/collab_invite_picker.dart` |
| 16 | Draft binding | `drafts/bindings/reels_draft_binding.dart` |
| 17 | Draft controller | `drafts/controllers/reels_draft_controller.dart` |
| 18 | Draft view + card | `drafts/views/reels_draft_view.dart`, `drafts/widgets/draft_card.dart` |
| 19 | Upload service | `services/reels_v2_upload_service.dart` |

**Acceptance Criteria:**
- [ ] Caption editor with inline #hashtag & @mention autocomplete
- [ ] Thumbnail: pick frame from video OR upload custom image
- [ ] A/B thumbnail: upload 2 options
- [ ] Location search & attach
- [ ] Tag people in reel
- [ ] Select up to 3 topics/categories
- [ ] Privacy: Public / Friends Only / Private
- [ ] Comment control: Everyone / Friends / Off
- [ ] Remix toggle (allow/disable)
- [ ] Download toggle (allow/disable)
- [ ] Cross-post: Feed toggle + Stories toggle
- [ ] Schedule: future date/time picker
- [ ] Collab invite via user search
- [ ] Save as draft (manual)
- [ ] Auto-save drafts on exit
- [ ] Drafts grid view with resume, edit, delete
- [ ] Background upload with progress indicator

---

### Phase 8 — Remix & Collaboration ✅
**Status:** ⬜ Not Started  
**Priority:** MEDIUM  
**Files:** ~10

| # | Task | Files |
|---|------|-------|
| 1 | Remix binding | `remix/bindings/reels_remix_binding.dart` |
| 2 | Remix controller | `remix/controllers/reels_remix_controller.dart` |
| 3 | Duet view | `remix/views/remix_duet_view.dart` |
| 4 | Stitch view | `remix/views/remix_stitch_view.dart` |
| 5 | Layout picker | `remix/widgets/remix_layout_picker.dart` |
| 6 | Source preview | `remix/widgets/remix_source_preview.dart` |
| 7 | Remix chain viewer | `remix/widgets/remix_chain_viewer.dart` |
| 8 | Remix model | `models/reel_remix_model.dart` |
| 9 | Route registration | Update routes for remix |

**Acceptance Criteria:**
- [ ] Remix/Duet: record alongside another reel (side-by-side or top/bottom)
- [ ] Stitch: use first 1-5s of another reel, then record response
- [ ] Green Screen Remix: use reel as background
- [ ] Layout picker: side-by-side / top-bottom / picture-in-picture
- [ ] Remix chain: view full lineage tree of remixes
- [ ] Collab post attribution (dual profile display)
- [ ] Audio from original reel plays alongside recording

---

### Phase 9 — Discovery, Search & Collections ✅
**Status:** ⬜ Not Started  
**Priority:** MEDIUM  
**Files:** ~16

| # | Task | Files |
|---|------|-------|
| 1 | Search binding | `search/bindings/reels_search_binding.dart` |
| 2 | Search controller | `search/controllers/reels_search_controller.dart` |
| 3 | Search view | `search/views/reels_search_view.dart` |
| 4 | Hashtag feed view | `search/views/hashtag_feed_view.dart` |
| 5 | Location feed view | `search/views/location_feed_view.dart` |
| 6 | Search widgets | `search/widgets/` (5 files) |
| 7 | Collection controller | `collection/controllers/reels_collection_controller.dart` |
| 8 | Collections view | `collection/views/collections_view.dart` |
| 9 | Collection detail view | `collection/views/collection_detail_view.dart` |
| 10 | Collection widgets | `collection/widgets/` (2 files) |
| 11 | Feed cards & discovery | `widgets/feed/` (5 files) |
| 12 | Models | `models/reel_hashtag_model.dart`, `reel_collection_model.dart`, `reel_challenge_model.dart`, `reel_series_model.dart` |

**Acceptance Criteria:**
- [ ] Unified search: reels, sounds, hashtags, creators (tabbed)
- [ ] Tap hashtag anywhere → hashtag feed (all reels with that tag)
- [ ] Tap location → location feed
- [ ] Topic/channel filter chips in feed
- [ ] Challenges/trends hub with "Join" CTA
- [ ] Creator spotlight carousels between reels
- [ ] Save to collection: default + custom folders
- [ ] Collection CRUD (create, rename, delete)
- [ ] Collection grid with cover images
- [ ] Reel series/playlists (creator-defined ordered groups)

---

### Phase 10 — Creator Analytics ✅
**Status:** ⬜ Not Started  
**Priority:** MEDIUM  
**Files:** ~12

| # | Task | Files |
|---|------|-------|
| 1 | Analytics binding | `analytics/bindings/reels_analytics_binding.dart` |
| 2 | Analytics controller | `analytics/controllers/reels_analytics_controller.dart` |
| 3 | Dashboard view | `analytics/views/reels_analytics_dashboard_view.dart` |
| 4 | Individual insight view | `analytics/views/reel_insight_view.dart` |
| 5 | Plays chart | `analytics/widgets/plays_chart.dart` |
| 6 | Retention curve | `analytics/widgets/retention_curve.dart` |
| 7 | Audience demographics | `analytics/widgets/audience_demographics.dart` |
| 8 | Reach source breakdown | `analytics/widgets/reach_source_breakdown.dart` |
| 9 | Top performing list | `analytics/widgets/top_performing_list.dart` |
| 10 | Follower growth chart | `analytics/widgets/follower_growth_chart.dart` |
| 11 | Monetization summary | `analytics/widgets/monetization_summary.dart` |
| 12 | A/B thumbnail result | `analytics/widgets/ab_thumbnail_result.dart` |
| 13 | Analytics model | `models/reel_analytics_model.dart` |
| 14 | Analytics API service | `services/reels_v2_analytics_service.dart` |

**Acceptance Criteria:**
- [ ] Overview dashboard: plays, likes, comments, shares, saves (7d/30d/90d/lifetime)
- [ ] Per-reel insight: plays over time, retention curve, reach sources
- [ ] Watch time: average duration, retention drop-off graph
- [ ] Audience: age brackets, gender pie, top cities, peak hours
- [ ] Top performing reels ranked by engagement
- [ ] Follower growth attributed to reels
- [ ] Monetization: earnings per reel, totals, bonus status
- [ ] A/B thumbnail: show winner, engagement comparison
- [ ] Export data as CSV

---

### Phase 11 — Settings & Accessibility ✅
**Status:** ⬜ Not Started  
**Priority:** MEDIUM  
**Files:** ~10

| # | Task | Files |
|---|------|-------|
| 1 | Settings controller | `settings/controllers/reels_settings_controller.dart` |
| 2 | Settings view | `settings/views/reels_settings_view.dart` |
| 3 | Autoplay toggle | `settings/widgets/autoplay_toggle.dart` |
| 4 | Data saver toggle | `settings/widgets/data_saver_toggle.dart` |
| 5 | Content preferences | `settings/widgets/content_preferences.dart` |
| 6 | Hidden words editor | `settings/widgets/hidden_words_editor.dart` |
| 7 | Notification preferences | `settings/widgets/notification_preferences.dart` |
| 8 | Effect model | `models/reel_effect_model.dart` |

**Acceptance Criteria:**
- [ ] Auto-play: ON / WiFi Only / OFF
- [ ] Data saver: lower quality on cellular
- [ ] Content preferences: select/deselect interest topics
- [ ] Hidden words: CRUD list of blocked words
- [ ] Notification preferences: granular toggles per event type
- [ ] Auto-captions toggle (server-generated subtitles)
- [ ] Caption translation toggle
- [ ] Watch history view + clear button
- [ ] Liked reels collection view

---

### Phase 12 — Navigation & V1/V2 Comparison Mode ✅
**Status:** ⬜ Not Started  
**Priority:** HIGH  
**Files:** ~5 (modifications to existing navigation files)

> **REQUIREMENT:** Do NOT replace the existing Reels tab. Add a NEW "Reels V2" nav button **next to** the existing "Reels" button in the bottom nav bar. This allows side-by-side comparison during development and testing.

#### Current Bottom Nav (Normal Profile)
```
[Home] [Reels] [Friends] [Marketplace] [Notifications] [Profile]
  0      1        2           3              4             5
```

#### New Bottom Nav (With V2 Button)
```
[Home] [Reels] [V2 ✨] [Friends] [Marketplace] [Notifications] [Profile]
  0      1       2        3           4              5             6
```

> The "V2 ✨" button sits immediately right of the existing "Reels" button. Uses a distinct icon (e.g. `QpIcon.reels` with a small sparkle badge or a different color tint) so it's visually clear which is V1 and which is V2.

#### Implementation Details

| # | Task | Files to Modify | Detail |
|---|------|----------------|--------|
| 1 | Add V2 nav item to bottom nav | `tab_view.dart` → `_buildBottomNav()` | Insert new `_BottomNavItemData(icon: QpIcon.reels, label: 'V2 ✨'.tr)` at index 2 in both `isPageProfile` and normal item lists |
| 2 | Update index mapping | `tab_view.dart` | Update `_normalNavToTab` from `[0,1,2,4,5,6]` to `[0,1,NEW_V2_IDX,2,4,5,6]` and `_pageNavToTab` similarly |
| 3 | Add ReelsV2View to TabBarView | `tab_view.dart` → `tabBarViewsForProfile` | Insert `const ReelsV2View()` at the new tab index position |
| 4 | Update TabController length | `tab_view_controller.dart` | Increment tab count by 1 (e.g. from 7 to 8 for normal profile) |
| 5 | Pause V2 reels on tab switch | `tab_view_controller.dart` | Add V2 index check alongside existing index 1 check: if leaving V2 tab → `ReelsV2MainController.pauseAllReels()` |

**Page Profile Nav:**
```
[Home] [Reels] [V2 ✨] [Pages] [Marketplace] [Notifications] [Profile]
  0      1       2       3          4              5             6  
```

**Acceptance Criteria:**
- [ ] New "V2 ✨" button visible next to existing "Reels" button
- [ ] Tapping "Reels" opens V1 (existing behavior, unchanged)
- [ ] Tapping "V2 ✨" opens Reels V2 (new full-screen feed)
- [ ] V2 button has distinct visual (sparkle badge or gradient icon) to differentiate from V1
- [ ] Both V1 and V2 pause when switching away from their tab
- [ ] V1 code completely untouched
- [ ] Tab index mapping updated correctly (no broken navigation)
- [ ] Works for both normal profile and page profile nav layouts

---

### Phase 12B — Full Integration (Post-Comparison, Future) ✅
**Status:** ✅ COMPLETE — Feature-flag gated integration across all touchpoints
**Priority:** DEFERRED — Only after V2 passes comparison testing
**Files:** ~11 (5 new + 6 modifications)

> **This phase executes ONLY after you've compared V1 vs V2 side-by-side and confirmed V2 is ready to be the primary experience.** Until then, both buttons stay in the nav.

| # | Task | Files to Modify |
|---|------|----------------|
| 1 | Remove V1 Reels tab, V2 takes index 1 | `tab_view.dart`, `tab_view_controller.dart` |
| 2 | Update create menu | Floating action menu → camera V2 |
| 3 | Profile integration | `profile_view.dart` → V2 reel grid |
| 4 | Page profile integration | `page_profile_view.dart` → V2 reel grid |
| 5 | Newsfeed in-feed cards | `newsfeed_view.dart` → V2 reel cards |
| 6 | Advance search | `reels_tab.dart` → V2 search |
| 7 | Deep links & notifications | Universal link handler → V2 routes |
| 8 | Remove "V2 ✨" button, V2 becomes "Reels" | `tab_view.dart` — clean up nav |

**Acceptance Criteria:**
- [ ] V2 replaces V1 as the sole "Reels" tab at index 1
- [ ] "V2 ✨" button removed, V2 now labeled just "Reels"
- [ ] Create menu "Reel" button opens V2 camera
- [ ] All profile views show V2 reel grid
- [ ] Newsfeed shows V2 reel preview cards
- [ ] Advance search uses V2 search
- [ ] Push notifications open V2 reel detail
- [ ] V1 code can be deprecated/archived

---

### Phase 13 — Sponsored Reels & Boost (CampaignV2 Integration) ✅
**Status:** ✅ COMPLETE — 17 new files + 3 modifications, route registered, 14/14 criteria verified
**Priority:** HIGH
**Files:** ~20 (17 new + 3 modified)

| # | Task | Files |
|---|------|-------|
| 1 | Sponsored controller | `sponsored/controllers/reels_sponsored_controller.dart` |
| 2 | Ad serve service | `sponsored/services/reels_ad_serve_service.dart` |
| 3 | Sponsored reel model | `sponsored/models/sponsored_reel_model.dart` |
| 4 | Sponsored overlay widget | `sponsored/widgets/sponsored_reel_overlay.dart` |
| 5 | CTA button widget | `sponsored/widgets/sponsored_cta_button.dart` |
| 6 | "Why this ad?" sheet | `sponsored/widgets/why_this_ad_sheet.dart` |
| 7 | Ad feedback menu | `sponsored/widgets/ad_feedback_menu.dart` |
| 8 | Feed merge logic | Update `reels_feed_controller.dart` — merge sponsored reels into organic feed |
| 9 | Impression tracking | Update `reels_ad_serve_service.dart` — auto-beacon on view |
| 10 | Boost binding | `boost/bindings/reels_boost_binding.dart` |
| 11 | Boost controller | `boost/controllers/reels_boost_controller.dart` |
| 12 | Boost view | `boost/views/reels_boost_view.dart` |
| 13 | Budget selector | `boost/widgets/boost_budget_selector.dart` |
| 14 | Audience picker | `boost/widgets/boost_audience_picker.dart` |
| 15 | Schedule picker | `boost/widgets/boost_schedule_picker.dart` |
| 16 | Preview card | `boost/widgets/boost_preview_card.dart` |
| 17 | CTA selector | `boost/widgets/boost_cta_selector.dart` |
| 18 | Performance card | `boost/widgets/boost_performance_card.dart` |
| 19 | Status badge | `boost/widgets/boost_status_badge.dart` |
| 20 | Route registration | Add REELS_V2_BOOST route |

**Acceptance Criteria:**
- [ ] Sponsored reels fetched from `GET /api/campaigns-v2/serve?placement=Reels`
- [ ] 1 sponsored reel inserted every 5-7 organic reels in feed
- [ ] "Sponsored" label visible below author name (non-removable)
- [ ] CTA button renders dynamically from Ad.call_to_action
- [ ] CTA tap opens destination URL in in-app browser
- [ ] Impression auto-tracked via beacon when reel viewed ≥1s
- [ ] Click tracked via beacon when CTA tapped
- [ ] "Hide Ad" sends feedback and suppresses similar ads
- [ ] "Why this ad?" shows targeting reason bottom sheet
- [ ] Frequency cap respected (max N per user per day)
- [ ] Boost flow: budget + audience + schedule + CTA → POST /api/campaigns-v2/boost
- [ ] Boost status tracked: Draft → Pending → Active → Paused → Completed
- [ ] Live boost analytics: impressions, clicks, reach, CTR from CampaignV2
- [ ] Ad reactions/comments sent via AdEngagementController endpoints

---

## 6. Backend API Requirements

> ⛔ **CRITICAL ISOLATION RULE:** Reels V2 backend MUST be 100% independent from V1. NO shared controllers, NO shared models, NO shared services, NO shared collections. V2 will have its own route files, controller files, model files, service files, and MongoDB collections. The ONLY shared infrastructure is platform-level utilities (Redis client, push notification helper, User model, Firebase, Multer upload). This ensures V1 instability CANNOT leak into V2.

### 6A. V1 → V2 Isolation Architecture

#### Why Full Isolation (NOT Partial Reuse)
| V1 Component | Problem | V2 Solution |
|--------------|---------|-------------|
| `ReelsController.js` (23 functions in one file) | Monolithic, tightly coupled, hard to debug | Separate controllers per domain (FeedController, CommentController, ReactionController, etc.) |
| `Reels` model (`reels` collection) | Denormalized counts get out of sync, `engagement_score` not consistently updated, missing indexes | New `reels_v2` collection with proper schema, atomic counter operations, full index coverage |
| `ReelComment` + `ReelReplyComment` (2 separate models) | Split models cause N+1 queries, no threaded comment support | Single `reel_v2_comments` collection with `parentId` field (self-referencing tree) |
| `ReelPostReaction` + `ReelCommentReaction` (2 separate models) | Separate models = separate queries per reaction type | Single `reel_v2_reactions` collection handling both reel + comment reactions |
| `ReelsRecommendationService` (1 monolithic service) | Complex candidate generation mixed with scoring, Redis caching, config loading in one class | Split into: `FeedCandidateService`, `FeedScoringService`, `FeedCacheService` |
| Legacy routes (`/edit-reels`, `/user-reels/:username`) | Inconsistent URL patterns, no versioning, mixed auth | All V2 routes under `/api/v2/reels/*` with consistent REST patterns |
| `ReelsPerformance` (impression tracking) | Unbounded growth, no TTL/rollup, missing compound index | New `reel_v2_analytics` with TTL indexes, daily rollup, proper sharding key |
| Socket events (global namespace, 6 events) | No namespace isolation, events leak to all clients | V2 uses `/reels-v2` socket namespace, separate event handlers |
| `OptimizedReelsQuery.js` (optimization patch) | Bolt-on optimization = fragile, still uses V1 models | V2 queries optimized from day one (no optimization patches needed) |
| `UserReelsPriorityView.js` (abandoned) | Attempted materialized view, abandoned "not scalable" | V2 uses Redis-backed pre-computed feeds instead of MongoDB views |

#### What IS Shared (Platform Infrastructure — OK to reuse)
| Shared Module | Why Safe | Used By V2 |
|---------------|----------|------------|
| `models/User.js` | User data is universal, not reel-specific | Yes — for author info population |
| `models/Friends.js` | Friendship graph is universal | Yes — for "Following" feed filter |
| `utils/redisClient.js` | Redis connection pool is platform infra | Yes — but V2 uses SEPARATE key prefixes (`rv2:*`) |
| `helper/push.notification.helper.js` | Push notifications are platform infra | Yes — for reel interaction notifications |
| `firebase.js` | Firebase is platform infra | Yes — for push tokens and cloud messaging |
| `middleware/auth.js` | JWT auth is platform-wide | Yes — same auth for all endpoints |
| `config/` | DB connection, S3 config, etc. | Yes — platform configuration |
| `helper/videoProcessing.js` | FFmpeg utilities are generic | No — V2 will have its own `reels_v2_video_service.js` with improved pipeline |
| `helper/handleCompression.js` | Current compression is lossy/slow | No — V2 will have new adaptive quality pipeline |

#### V2 Backend File Structure (NEW — Completely Separate)

```
qp-api/
├── routes/
│   └── reels-v2/                          # NEW directory
│       ├── index.js                       # Route aggregator
│       ├── feed.routes.js                 # Feed endpoints
│       ├── crud.routes.js                 # CRUD endpoints
│       ├── interaction.routes.js          # Like, comment, share, bookmark
│       ├── sound.routes.js                # Sound/music library
│       ├── remix.routes.js                # Duet, stitch, green screen
│       ├── collection.routes.js           # Bookmark collections
│       ├── analytics.routes.js            # Creator analytics
│       ├── tracking.routes.js             # View/impression tracking
│       ├── series.routes.js               # Series/playlist
│       ├── settings.routes.js             # User preferences
│       └── admin.routes.js                # Admin/config endpoints
│
├── controller/
│   └── ReelsV2/                           # NEW directory
│       ├── ReelsV2FeedController.js       # For You, Following, Trending feeds
│       ├── ReelsV2CrudController.js       # Create, update, delete, get
│       ├── ReelsV2CommentController.js    # Comments & replies (threaded)
│       ├── ReelsV2ReactionController.js   # Reactions (reel + comment)
│       ├── ReelsV2BookmarkController.js   # Bookmarks & collections
│       ├── ReelsV2ShareController.js      # Sharing & repost
│       ├── ReelsV2SoundController.js      # Sound library & search
│       ├── ReelsV2RemixController.js      # Duet, stitch, green screen
│       ├── ReelsV2AnalyticsController.js  # Creator analytics & insights
│       ├── ReelsV2TrackingController.js   # View, impression, watch time
│       ├── ReelsV2SeriesController.js     # Series/playlist management
│       ├── ReelsV2SettingsController.js   # User preferences
│       ├── ReelsV2UploadController.js     # Video upload & processing pipeline
│       └── ReelsV2AdminController.js      # Admin config & moderation
│
├── models/
│   └── ReelsV2/                           # NEW directory
│       ├── ReelV2.js                      # Main reel document → collection: 'reels_v2'
│       ├── ReelV2Comment.js               # Threaded comments → collection: 'reel_v2_comments'
│       ├── ReelV2Reaction.js              # All reactions → collection: 'reel_v2_reactions'
│       ├── ReelV2Bookmark.js              # Bookmarks → collection: 'reel_v2_bookmarks'
│       ├── ReelV2Collection.js            # Bookmark collections → collection: 'reel_v2_collections'
│       ├── ReelV2Sound.js                 # Sound/music library → collection: 'reel_v2_sounds'
│       ├── ReelV2Remix.js                 # Remix relationships → collection: 'reel_v2_remixes'
│       ├── ReelV2Analytics.js             # Per-reel analytics → collection: 'reel_v2_analytics'
│       ├── ReelV2WatchHistory.js          # Watch history → collection: 'reel_v2_watch_history'
│       ├── ReelV2Feedback.js              # Negative signals → collection: 'reel_v2_feedback'
│       ├── ReelV2Series.js                # Series/playlist → collection: 'reel_v2_series'
│       ├── ReelV2Draft.js                 # Drafts → collection: 'reel_v2_drafts'
│       ├── ReelV2Report.js               # Reports → collection: 'reel_v2_reports'
│       └── ReelV2Settings.js              # User prefs → collection: 'reel_v2_settings'
│
├── services/
│   └── ReelsV2/                           # NEW directory
│       ├── ReelsV2FeedCandidateService.js # Candidate generation (following, trending, interests)
│       ├── ReelsV2FeedScoringService.js   # Engagement scoring, personalization
│       ├── ReelsV2FeedCacheService.js     # Redis caching (key prefix: rv2:*)
│       ├── ReelsV2VideoService.js         # Upload, transcoding, thumbnail, adaptive quality
│       ├── ReelsV2NotificationService.js  # Reel-specific notification logic
│       └── ReelsV2SearchService.js        # Full-text search, hashtag, sound search
│
├── validators/
│   └── ReelsV2/                           # NEW directory
│       ├── reel.validator.js              # Create/update reel validation
│       ├── comment.validator.js           # Comment validation
│       ├── collection.validator.js        # Collection validation
│       └── settings.validator.js          # Settings validation
│
├── socket/
│   └── reels-v2/                          # NEW directory
│       ├── index.js                       # Namespace '/reels-v2' setup
│       ├── viewTracking.js               # start-viewing-v2, stop-viewing-v2
│       ├── liveComments.js               # Real-time comment updates
│       └── realtimeReactions.js          # Real-time reaction counts
│
└── tests/
    └── reels-v2/                          # NEW directory
        ├── feed.test.js
        ├── crud.test.js
        ├── comment.test.js
        ├── reaction.test.js
        ├── bookmark.test.js
        └── analytics.test.js
```

**V2 backend total: 14 controllers, 14 models, 6 services, 12 route files, 3 socket handlers, 4 validators, 6 test files = ~59 new backend files**

#### MongoDB Collection Mapping (V1 → V2)

| V1 Collection | V2 Collection | Why New | Key Improvements |
|--------------|---------------|---------|-----------------|
| `reels` | `reels_v2` | V1 schema has denormalized counts that drift, no sound/remix fields, no series support | Atomic `$inc` for counts, `soundId`, `remixSourceId`, `seriesId`, `abThumbnailUrl`, `scheduledAt`, `collabAuthorId`, TTL for soft-deleted docs |
| `reelcomments` + `reelreplycomments` | `reel_v2_comments` | V1 splits comments and replies into 2 collections → requires 2 queries | Single collection with `parentId` (null = top-level, ObjectId = reply). Threaded to any depth. Pinned support. |
| `reelpostreactions` + `reelcommentreactions` | `reel_v2_reactions` | V1 splits reel vs comment reactions → 2 models, 2 queries | Single collection with `targetType` ('reel' or 'comment') + `targetId`. One query covers both. |
| `reelbookmarks` | `reel_v2_bookmarks` | V1 has no collection support, just flat bookmarks | `collectionId` field for organizing bookmarks into named collections |
| (none) | `reel_v2_collections` | V1 has no collections feature | Named bookmark collections with cover, count, privacy |
| (none) | `reel_v2_sounds` | V1 has no sound library | Sound metadata, usage count, trending score, genre, mood tags |
| (none) | `reel_v2_remixes` | V1 has no remix support | Links original → remix with type (duet/stitch/greenScreen) |
| `reelsperformances` | `reel_v2_analytics` | V1 grows unbounded, no TTL, missing indexes | TTL on raw events (30 days), daily rollup aggregation, per-reel retention curve data |
| (none) | `reel_v2_watch_history` | V1 uses ReelsPerformance for watch history (overloaded collection) | Dedicated collection, cursor pagination, bulk clear |
| `reelfeedbacks` | `reel_v2_feedback` | V1 missing index on signal_type | Compound index `{user_id, reel_id, signal_type}`, used for negative signal filtering |
| (none) | `reel_v2_series` | V1 has no series feature | Series with ordered reel list, cover art, description |
| (none) | `reel_v2_drafts` | V1 stores drafts in main collection (pollutes queries) | Separate collection for drafts, never mixed with published reels |
| (none) | `reel_v2_reports` | V1 uses feedback for reports (mixed concerns) | Dedicated reports with reason, evidence, status, moderator assignment |
| (none) | `reel_v2_settings` | V1 has no per-user reel preferences | Default remix/download/comment permissions, hidden words, content language |

#### Redis Key Namespace Isolation
```
V1 keys: recs:*, reels:*, algo:*         ← V1 (UNTOUCHED)
V2 keys: rv2:feed:*, rv2:reel:*, rv2:user:*, rv2:sound:*, rv2:trending:*  ← V2 (SEPARATE)
```
- V2 NEVER reads V1 Redis keys
- V2 NEVER writes to V1 Redis keys
- If Redis is flushed, both V1 and V2 recover independently via cold-start fallback

#### Socket Namespace Isolation
```javascript
// V1 (existing — UNTOUCHED)
io.on('connection', (socket) => {
  socket.on('start-viewing', ...);     // V1 events
  socket.on('stop-viewing', ...);
  socket.on('endstream', ...);
});

// V2 (new — SEPARATE NAMESPACE)
const reelsV2Ns = io.of('/reels-v2');
reelsV2Ns.on('connection', (socket) => {
  socket.on('start-viewing-v2', ...);  // V2 events (different handler)
  socket.on('stop-viewing-v2', ...);
  socket.on('live-comment', ...);      // NEW: real-time comments
  socket.on('live-reaction', ...);     // NEW: real-time reactions
});
```

#### V2 Controller Design Principles (Prevent V1 Mistakes)

| V1 Mistake | V2 Rule |
|-----------|---------|
| `ReelsController.js` has 23 functions (500+ lines) | Each V2 controller has max 5-7 functions, single responsibility |
| Denormalized counts updated with separate `findOneAndUpdate` (race condition) | V2 uses `$inc` atomic operations in the same query, with periodic reconciliation cron |
| No input validation in controller | V2 uses `express-validator` middleware in route files (validators run BEFORE controller) |
| Mixed `async/await` and `.then()` callbacks | V2 uses ONLY `async/await` with proper `try/catch` |
| Error responses inconsistent (`res.send` vs `res.json` vs `res.status`) | V2 uses standardized `ApiResponse` class: `ApiResponse.success(data)`, `ApiResponse.error(code, message)` |
| No rate limiting on write endpoints | V2 has rate limiting: 10 creates/min, 30 reactions/min, 20 comments/min |
| No request timeout | V2 has 10s timeout on all endpoints (30s for uploads) |
| N+1 queries for comment reactions | V2 uses `$lookup` aggregate in single query |
| Missing indexes discovered in production | V2 models define ALL indexes at schema level, tested with `.explain()` before deploy |
| No pagination on some list endpoints | V2 ALL list endpoints use cursor pagination (no `skip/offset`) |

### 6B. New V2 API Endpoints (qp-api)

#### Feed APIs
```
GET    /api/v2/reels/feed/for-you          # Personalized feed (cursor pagination)
GET    /api/v2/reels/feed/following         # Following feed
GET    /api/v2/reels/feed/trending          # Trending feed
GET    /api/v2/reels/feed/hashtag/:tag      # Reels by hashtag
GET    /api/v2/reels/feed/sound/:soundId    # Reels by sound
GET    /api/v2/reels/feed/location/:locId   # Reels by location
GET    /api/v2/reels/feed/topic/:topicId    # Reels by topic
GET    /api/v2/reels/feed/related/:reelId   # Related reels
GET    /api/v2/reels/feed/challenges        # Active challenges
```

#### CRUD APIs
```
POST   /api/v2/reels                        # Create/upload reel
PUT    /api/v2/reels/:id                    # Update reel metadata
DELETE /api/v2/reels/:id                    # Delete reel
GET    /api/v2/reels/:id                    # Get single reel detail
GET    /api/v2/reels/user/:userId           # User's reels
GET    /api/v2/reels/drafts                 # User's drafts (metadata only)
POST   /api/v2/reels/schedule               # Schedule future publish
```

#### Interaction APIs
```
POST   /api/v2/reels/:id/reaction           # Add/change reaction
DELETE /api/v2/reels/:id/reaction           # Remove reaction
GET    /api/v2/reels/:id/reactions          # Reaction list
POST   /api/v2/reels/:id/comment            # Add comment
PUT    /api/v2/reels/comment/:cid           # Edit comment
DELETE /api/v2/reels/comment/:cid           # Delete comment
POST   /api/v2/reels/comment/:cid/reply     # Reply to comment
GET    /api/v2/reels/:id/comments           # Paginated comments (sort param)
POST   /api/v2/reels/comment/:cid/pin       # Pin/unpin comment
POST   /api/v2/reels/comment/:cid/reaction  # React to comment
POST   /api/v2/reels/:id/share              # Share reel
POST   /api/v2/reels/:id/bookmark           # Toggle bookmark
POST   /api/v2/reels/:id/not-interested     # Negative feedback
POST   /api/v2/reels/:id/report             # Report reel
POST   /api/v2/reels/:id/download           # Log download
POST   /api/v2/reels/:id/follow-author      # Follow from reel
```

#### Sound/Audio APIs
```
GET    /api/v2/reels/sounds/trending         # Trending sounds
GET    /api/v2/reels/sounds/library          # Music library (genre, mood)
GET    /api/v2/reels/sounds/search           # Search sounds
GET    /api/v2/reels/sounds/:id              # Sound detail + usage count
GET    /api/v2/reels/sounds/:id/reels        # All reels with sound
POST   /api/v2/reels/sounds/:id/save         # Save/unsave sound
GET    /api/v2/reels/sounds/saved            # User's saved sounds
POST   /api/v2/reels/sounds/effects          # Sound effects library
```

#### Remix APIs
```
POST   /api/v2/reels/remix                   # Create remix (duet/stitch)
GET    /api/v2/reels/:id/remix-chain         # Get remix tree
GET    /api/v2/reels/:id/remixes             # All remixes of a reel
```

#### Collection APIs
```
GET    /api/v2/reels/collections              # User's collections
POST   /api/v2/reels/collections              # Create collection
PUT    /api/v2/reels/collections/:id          # Rename collection
DELETE /api/v2/reels/collections/:id          # Delete collection
POST   /api/v2/reels/collections/:id/add      # Add reel to collection
DELETE /api/v2/reels/collections/:id/remove    # Remove reel from collection
GET    /api/v2/reels/collections/:id/reels     # Reels in collection
```

#### Analytics APIs
```
GET    /api/v2/reels/analytics/overview       # Creator overview (period param)
GET    /api/v2/reels/analytics/:id            # Per-reel insights
GET    /api/v2/reels/analytics/:id/retention  # Retention curve data
GET    /api/v2/reels/analytics/audience       # Audience demographics
GET    /api/v2/reels/analytics/top            # Top performing reels
GET    /api/v2/reels/analytics/growth         # Follower growth
GET    /api/v2/reels/analytics/earnings       # Reel monetization data
GET    /api/v2/reels/analytics/ab/:id         # A/B thumbnail results
POST   /api/v2/reels/analytics/export         # Export CSV
```

#### Tracking APIs
```
POST   /api/v2/reels/track/view              # Batch view tracking
POST   /api/v2/reels/track/watch-time        # Watch time per reel
POST   /api/v2/reels/track/impression        # Impression tracking
```

#### Series/Playlist APIs
```
GET    /api/v2/reels/series/user/:userId     # User's series
POST   /api/v2/reels/series                  # Create series
PUT    /api/v2/reels/series/:id              # Update series
DELETE /api/v2/reels/series/:id              # Delete series
POST   /api/v2/reels/series/:id/reels        # Add/reorder reels in series
```

#### Settings APIs
```
GET    /api/v2/reels/settings                 # User's reel preferences
PUT    /api/v2/reels/settings                 # Update preferences
GET    /api/v2/reels/settings/hidden-words    # Blocked words list
PUT    /api/v2/reels/settings/hidden-words    # Update blocked words
GET    /api/v2/reels/history                  # Watch history
DELETE /api/v2/reels/history                  # Clear watch history
GET    /api/v2/reels/liked                    # Liked reels
```

**Total: ~70+ API endpoints**

---

## 7. Data Models

> **Two-side models:** This section shows BOTH the Flutter (Dart) client model AND the MongoDB (Mongoose) server schema. The Mongoose schemas define the NEW V2 collections — completely separate from V1 collections. Every V2 collection has proper indexes defined at schema level.

### 7A. MongoDB Schemas (Backend — NEW Collections)

#### ReelV2.js → collection: `reels_v2`
```javascript
const ReelV2Schema = new mongoose.Schema({
  author_id:          { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
  collab_author_id:   { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  page_id:            { type: mongoose.Schema.Types.ObjectId, ref: 'Page' },
  
  // Video
  video_url:          { type: String, required: true },
  original_video_url: { type: String },
  thumbnail_url:      { type: String, required: true },
  ab_thumbnail_url:   { type: String },
  duration_ms:        { type: Number, required: true },
  aspect_ratio:       { type: Number, default: 0.5625 },  // 9:16
  quality_variants:   [{ quality: String, url: String, size_bytes: Number }],  // ['360p','480p','720p','1080p']
  
  // Content
  caption:            { type: String, maxlength: 2200 },
  hashtags:           [{ type: String, index: true }],
  mentioned_user_ids: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  tagged_people:      [{ user_id: mongoose.Schema.Types.ObjectId, username: String, x: Number, y: Number }],
  location_id:        { type: String },
  location_name:      { type: String },
  topic_ids:          [{ type: String }],
  
  // Audio
  sound_id:             { type: mongoose.Schema.Types.ObjectId, ref: 'ReelV2Sound' },
  sound_name:           { type: String },
  sound_artist:         { type: String },
  is_original_audio:    { type: Boolean, default: true },
  original_audio_volume:{ type: Number, default: 1.0, min: 0, max: 1 },
  music_volume:         { type: Number, default: 1.0, min: 0, max: 1 },
  
  // Settings
  privacy:              { type: String, enum: ['public', 'friends', 'private'], default: 'public' },
  comment_permission:   { type: String, enum: ['everyone', 'friends', 'off'], default: 'everyone' },
  allow_remix:          { type: Boolean, default: true },
  allow_download:       { type: Boolean, default: true },
  allow_stitch:         { type: Boolean, default: true },
  
  // Remix
  remix_source_reel_id: { type: mongoose.Schema.Types.ObjectId, ref: 'ReelV2' },
  remix_type:           { type: String, enum: ['duet', 'stitch', 'greenScreen'] },
  
  // Series
  series_id:            { type: mongoose.Schema.Types.ObjectId, ref: 'ReelV2Series' },
  series_order:         { type: Number },
  
  // Counts (atomic $inc ONLY — never set directly)
  view_count:           { type: Number, default: 0, min: 0 },
  like_count:           { type: Number, default: 0, min: 0 },
  comment_count:        { type: Number, default: 0, min: 0 },
  share_count:          { type: Number, default: 0, min: 0 },
  save_count:           { type: Number, default: 0, min: 0 },
  remix_count:          { type: Number, default: 0, min: 0 },
  loop_count:           { type: Number, default: 0, min: 0 },
  engagement_score:     { type: Number, default: 0, index: true },
  
  // Status
  status:               { type: String, enum: ['draft', 'scheduled', 'processing', 'published', 'removed'], default: 'processing', index: true },
  scheduled_at:         { type: Date },
  processing_job_id:    { type: String },
  processing_progress:  { type: Number, min: 0, max: 100 },
  
  // Accessibility
  auto_captions:        [{ start_ms: Number, end_ms: Number, text: String, language: String }],
  alt_text:             { type: String },
  
  // Soft delete
  is_deleted:           { type: Boolean, default: false, index: true },
  deleted_at:           { type: Date },
  
}, { timestamps: true });

// INDEXES — all defined at schema level, tested with .explain()
ReelV2Schema.index({ status: 1, privacy: 1, is_deleted: 1, createdAt: -1 });        // Feed query (primary)
ReelV2Schema.index({ author_id: 1, is_deleted: 1, createdAt: -1 });                 // User's reels (profile)
ReelV2Schema.index({ page_id: 1, is_deleted: 1, createdAt: -1 });                   // Page reels
ReelV2Schema.index({ status: 1, is_deleted: 1, engagement_score: -1, createdAt: -1 }); // Trending
ReelV2Schema.index({ sound_id: 1, status: 1, is_deleted: 1, createdAt: -1 });       // Reels by sound
ReelV2Schema.index({ 'hashtags': 1, status: 1, is_deleted: 1, createdAt: -1 });     // Reels by hashtag
ReelV2Schema.index({ series_id: 1, series_order: 1 });                               // Series reels
ReelV2Schema.index({ remix_source_reel_id: 1 });                                    // Find remixes of a reel
ReelV2Schema.index({ status: 1, scheduled_at: 1 });                                 // Scheduled publish cron
ReelV2Schema.index({ caption: 'text', sound_name: 'text' });                        // Full-text search
```

#### ReelV2Comment.js → collection: `reel_v2_comments`
```javascript
// SINGLE collection for both comments AND replies (threaded via parent_id)
const ReelV2CommentSchema = new mongoose.Schema({
  reel_id:        { type: mongoose.Schema.Types.ObjectId, ref: 'ReelV2', required: true },
  author_id:      { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  parent_id:      { type: mongoose.Schema.Types.ObjectId, ref: 'ReelV2Comment', default: null }, // null = top-level, ObjectId = reply
  text:           { type: String, required: true, maxlength: 1000 },
  mentions:       [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  gif_url:        { type: String },
  image_url:      { type: String },
  
  // Denormalized (atomic $inc)
  reaction_count: { type: Number, default: 0 },
  reply_count:    { type: Number, default: 0 },   // Only meaningful when parent_id is null
  
  is_pinned:      { type: Boolean, default: false },
  is_edited:      { type: Boolean, default: false },
  is_deleted:     { type: Boolean, default: false },
}, { timestamps: true });

ReelV2CommentSchema.index({ reel_id: 1, parent_id: 1, createdAt: -1 });  // Top-level comments for reel
ReelV2CommentSchema.index({ reel_id: 1, parent_id: 1, reaction_count: -1 }); // Most relevant sort
ReelV2CommentSchema.index({ parent_id: 1, createdAt: 1 });                // Replies for a comment
ReelV2CommentSchema.index({ reel_id: 1, is_pinned: -1, createdAt: -1 }); // Pinned first
ReelV2CommentSchema.index({ author_id: 1, createdAt: -1 });              // User's comments
```

#### ReelV2Reaction.js → collection: `reel_v2_reactions`
```javascript
// SINGLE collection for reel reactions AND comment reactions
const ReelV2ReactionSchema = new mongoose.Schema({
  target_type:    { type: String, enum: ['reel', 'comment'], required: true },
  target_id:      { type: mongoose.Schema.Types.ObjectId, required: true },  // reel_id or comment_id
  user_id:        { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  reaction_type:  { type: String, enum: ['like', 'love', 'haha', 'wow', 'sad', 'angry'], default: 'like' },
}, { timestamps: true });

ReelV2ReactionSchema.index({ target_type: 1, target_id: 1, user_id: 1 }, { unique: true }); // One reaction per user per target
ReelV2ReactionSchema.index({ target_type: 1, target_id: 1, reaction_type: 1 }); // Count by reaction type
ReelV2ReactionSchema.index({ user_id: 1, target_type: 1, createdAt: -1 });      // User's reaction history
```

#### ReelV2Bookmark.js → collection: `reel_v2_bookmarks`
```javascript
const ReelV2BookmarkSchema = new mongoose.Schema({
  user_id:        { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  reel_id:        { type: mongoose.Schema.Types.ObjectId, ref: 'ReelV2', required: true },
  collection_id:  { type: mongoose.Schema.Types.ObjectId, ref: 'ReelV2Collection' }, // null = default "Saved"
}, { timestamps: true });

ReelV2BookmarkSchema.index({ user_id: 1, reel_id: 1 }, { unique: true });           // One bookmark per user per reel
ReelV2BookmarkSchema.index({ user_id: 1, collection_id: 1, createdAt: -1 });        // Bookmarks in collection
ReelV2BookmarkSchema.index({ user_id: 1, createdAt: -1 });                          // All user bookmarks
```

#### ReelV2Analytics.js → collection: `reel_v2_analytics`
```javascript
const ReelV2AnalyticsSchema = new mongoose.Schema({
  reel_id:           { type: mongoose.Schema.Types.ObjectId, ref: 'ReelV2', required: true },
  user_id:           { type: mongoose.Schema.Types.ObjectId, ref: 'User' },  // null for anonymous
  event_type:        { type: String, enum: ['view', 'impression', 'watch_time', 'share_click', 'profile_visit'], required: true },
  watch_duration_ms: { type: Number },  // For watch_time events
  watch_percentage:  { type: Number },  // 0-100 (how much of reel was watched)
  source:            { type: String, enum: ['for_you', 'following', 'trending', 'profile', 'search', 'share_link', 'notification'] },
  
  // Expires after 30 days (raw events) — daily rollup cron aggregates into reel_v2_analytics_daily
  expires_at:        { type: Date, default: () => new Date(Date.now() + 30 * 24 * 60 * 60 * 1000) },
}, { timestamps: true });

ReelV2AnalyticsSchema.index({ expires_at: 1 }, { expireAfterSeconds: 0 });           // TTL auto-cleanup
ReelV2AnalyticsSchema.index({ reel_id: 1, event_type: 1, createdAt: -1 });          // Per-reel analytics
ReelV2AnalyticsSchema.index({ user_id: 1, event_type: 1, createdAt: -1 });          // User watch history
ReelV2AnalyticsSchema.index({ reel_id: 1, user_id: 1 }, { unique: true, partialFilterExpression: { event_type: 'view' } }); // Unique views
```

#### ReelV2Sound.js → collection: `reel_v2_sounds`
```javascript
const ReelV2SoundSchema = new mongoose.Schema({
  name:           { type: String, required: true },
  artist:         { type: String },
  cover_url:      { type: String },
  audio_url:      { type: String, required: true },
  duration_ms:    { type: Number, required: true },
  genre:          { type: String },
  mood_tags:      [{ type: String }],
  usage_count:    { type: Number, default: 0 },         // Atomic $inc
  trending_score: { type: Number, default: 0, index: true },
  is_original:    { type: Boolean, default: false },     // User-created original audio
  original_author_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
}, { timestamps: true });

ReelV2SoundSchema.index({ name: 'text', artist: 'text' });              // Search
ReelV2SoundSchema.index({ trending_score: -1, usage_count: -1 });       // Trending sort
ReelV2SoundSchema.index({ genre: 1, trending_score: -1 });              // Browse by genre
ReelV2SoundSchema.index({ original_author_id: 1, createdAt: -1 });     // Creator's original sounds
```

#### Other V2 Collections (Compact Definitions)

| Collection | Schema Key Fields | Indexes |
|-----------|-------------------|---------|
| `reel_v2_collections` | `user_id`, `name`, `cover_url`, `reel_count`, `privacy` | `{user_id, createdAt}` |
| `reel_v2_remixes` | `source_reel_id`, `remix_reel_id`, `remix_type`, `author_id` | `{source_reel_id}`, `{remix_reel_id}` unique, `{author_id, createdAt}` |
| `reel_v2_watch_history` | `user_id`, `reel_id`, `watch_count`, `last_position_ms` | `{user_id, updatedAt}`, `{user_id, reel_id}` unique |
| `reel_v2_feedback` | `user_id`, `reel_id`, `signal_type` (not_interested/hide/report) | `{user_id, reel_id, signal_type}` unique, `{reel_id, signal_type}` |
| `reel_v2_series` | `author_id`, `name`, `cover_url`, `reel_ids[]`, `reel_count`, `privacy` | `{author_id, createdAt}` |
| `reel_v2_drafts` | `author_id`, `clip_paths[]`, `sound_id`, `text_overlays[]`, `stickers[]`, `filter_settings` | `{author_id, updatedAt}` |
| `reel_v2_reports` | `reel_id`, `reporter_id`, `reason`, `evidence_text`, `status` (pending/reviewed/actioned), `moderator_id` | `{status, createdAt}`, `{reel_id}`, `{reporter_id}` |
| `reel_v2_settings` | `user_id`, `default_privacy`, `default_comment_perm`, `allow_remix_default`, `hidden_words[]`, `content_language` | `{user_id}` unique |

### 7B. Flutter Client Models (Dart)
```dart
class ReelV2 {
  String id;
  String authorId;
  String? collabAuthorId;          // Co-author
  String videoUrl;                  // Processed video URL
  String? originalVideoUrl;         // Pre-processing original
  String thumbnailUrl;              // Default thumbnail
  String? abThumbnailUrl;           // A/B test thumbnail
  int durationMs;                   // Video duration in ms
  double aspectRatio;               // Width / Height
  
  // Content
  String caption;                   // Rich text caption
  List<String> hashtags;            // Extracted hashtags
  List<String> mentionedUserIds;    // @mentioned users
  List<TaggedUser> taggedPeople;    // People tagged in video
  String? locationId;               // Location tag
  String? locationName;
  List<String> topicIds;            // Category topics
  
  // Audio
  String? soundId;                  // External sound reference
  String? soundName;
  String? soundArtist;
  bool isOriginalAudio;            // True if creator's own audio
  double originalAudioVolume;       // 0.0 - 1.0
  double musicVolume;               // 0.0 - 1.0
  
  // Settings
  ReelPrivacy privacy;              // public / friends / private
  CommentPermission commentPermission; // everyone / friends / off
  bool allowRemix;
  bool allowDownload;
  bool allowStitch;
  
  // Remix
  String? remixSourceReelId;        // If this is a remix, source reel
  RemixType? remixType;             // duet / stitch / greenScreen
  
  // Series
  String? seriesId;
  int? seriesOrder;
  
  // Stats
  int viewCount;
  int likeCount;
  int commentCount;
  int shareCount;
  int saveCount;
  int remixCount;
  int loopCount;
  
  // Interaction state (viewer-specific)
  String? myReaction;               // null if no reaction
  bool isBookmarked;
  bool isFollowingAuthor;
  
  // Metadata
  DateTime createdAt;
  DateTime? scheduledAt;
  ReelStatus status;                // draft / scheduled / processing / published / removed
  
  // Author info (denormalized)
  String authorName;
  String authorUsername;
  String authorAvatar;
  bool authorIsVerified;
  String? authorTierBadge;
  
  // Processing
  String? processingJobId;
  int? processingProgress;          // 0-100
  List<String> qualityVariants;     // ['360p', '480p', '720p', '1080p']
  
  // Captions
  List<ReelCaption>? autoCaptions;  // Server-generated subtitles
  String? altText;                  // Accessibility text
}
```

### Supporting Models Summary
| Model | Key Fields |
|-------|-----------|
| `ReelCommentV2` | id, reelId, authorId, text, mentions, gifUrl, reactions{}, replyCount, isPinned, createdAt |
| `ReelCommentReply` | id, commentId, authorId, text, mentions, gifUrl, reactions{}, createdAt |
| `ReelSound` | id, name, artist, coverUrl, audioUrl, durationMs, usageCount, isTrending, isSaved |
| `ReelHashtag` | tag, reelCount, isTrending |
| `ReelDraft` | id, clipPaths[], soundId, textOverlays[], stickers[], filters, createdAt |
| `ReelAnalytics` | reelId, plays, uniqueViewers, avgWatchTime, retentionPoints[], reachSources{}, demographics |
| `ReelCollection` | id, name, coverUrl, reelCount, createdAt |
| `ReelRemix` | id, sourceReelId, remixReelId, type, createdAt |
| `ReelTemplate` | id, name, thumbnailUrl, beatMarkers[], usageCount, isTrending |
| `ReelChallenge` | id, name, description, soundId, hashtagId, thumbnailUrl, participantCount, endsAt |
| `ReelSeries` | id, name, coverUrl, authorId, reelIds[], reelCount, createdAt |
| `ReelFilter` | id, name, previewUrl, type(preset/custom), settings{} |
| `ReelCaption` | startMs, endMs, text, language |
| `TaggedUser` | userId, username, x, y (position in frame) |

---

## 8. Design System & UI/UX (Premium Modern Design)

> **DESIGN PHILOSOPHY:** Every screen in Reels V2 must feel like a **premium, world-class app** — on par with Instagram and TikTok. NO traditional/boring layouts. NO generic Material widgets without customization. Every pixel must be intentional. If a user can't tell the difference between QP Reels V2 and Instagram Reels at first glance, the design is correct.

### 8A. Design Principles (MANDATORY for every screen)

| Principle | Rule | Anti-Pattern (NEVER DO) |
|-----------|------|------------------------|
| **Glass Morphism** | Use frosted glass (`BackdropFilter` + `ImageFilter.blur`) for all overlays, sheets, modals | Opaque white/grey backgrounds on overlays |
| **Smooth Animations** | EVERY state change has a curve-based animation (300-500ms). No instant snaps. | Instant widget replacement without transition |
| **Haptic Feedback** | Tap-to-like, bookmark, follow — all trigger subtle haptic vibration | Silent button taps with no physical feedback |
| **Micro-interactions** | Icons bounce, scale, or pulse on tap. Counters animate number changes. | Static icons that just change color |
| **Depth & Layers** | 3-layer depth: video (back) → glass overlay (mid) → interactive UI (front) | Flat 2D layout with no visual depth |
| **Edge-to-edge** | Full bleed video, transparent status bar, hidden nav during playback | Videos with black bars, visible system chrome |
| **Dark-first** | ALL reel screens are dark theme (black/near-black). Light mode only for settings/publish. | White backgrounds on any playback screen |
| **Typography** | SF Pro Display (iOS) / Google Sans (Android) — bold for counts, medium for labels, regular for captions | System default font, single weight |
| **Spacing** | 8px grid system. Consistent 12/16/20/24px padding. | Arbitrary spacing, cramped or overly spacious |
| **Touch Targets** | Minimum 44×44pt for all interactive elements | Small 24px icons that are hard to tap |

### 8B. Color & Theme System

#### Player Screen (Dark Immersive)
| Element | Value | Notes |
|---------|-------|-------|
| Background | `#000000` | Pure black (OLED-friendly, saves battery) |
| Primary overlay text | `#FFFFFF` | With `Shadow(blurRadius: 8, color: #80000000)` |
| Secondary text | `#B3FFFFFF` (70% white) | Captions, usernames |
| Tertiary text | `#80FFFFFF` (50% white) | Timestamps, counts |
| Glass overlay | `#1AFFFFFF` (10% white) + blur(20) | Tab bar, seekbar bg, sheets |
| Action icons | `#FFFFFF` | With subtle drop shadow |
| Like heart (animated) | `#FF2D55` → `#FF375F` gradient | Scale + opacity spring animation |
| Follow button (active) | Linear gradient `#4F46E5` → `#7C3AED` | Rounded pill, 32px height |
| Follow button (following) | `#33FFFFFF` border + transparent fill | Ghost style |
| Seekbar inactive | `#33FFFFFF` | 2px height |
| Seekbar active | Linear gradient `#FFFFFF` → brand color | Expands to 4px on touch |
| Sound ticker disc | Radial gradient (brand colors) | Rotates 360° every 3s |
| Trending badge | `#FF6B35` → `#FF2D55` gradient | Rounded pill with glow |
| Sponsored label | `#80FFFFFF` text on `#1AFFFFFF` bg | Subtle, non-intrusive |
| Comment sheet bg | `#0D0D0D` + blur(30) frosted glass | 80% height, rounded top 20px |
| Boost CTA button | `#4F46E5` → `#7C3AED` gradient | Full-width, rounded 12px, bold text |

#### Camera & Editor Screen
| Element | Value |
|---------|-------|
| Background | `#0A0A0A` (near-black) |
| Tool bar bg | `#1A1A1A` + blur(10) |
| Selected tool | White icon + `#4F46E5` underline |
| Unselected tool | `#80FFFFFF` icon |
| Recording indicator | `#FF3B30` pulsing circle |
| Segment progress | Each segment different brand color gradient |
| Timer countdown | `#FFFFFF` 72pt bold, scale-in animation |
| Caption input bg | `#1A1A1A` rounded 16px |

#### Publish & Settings Screen
| Element | Value |
|---------|-------|
| Background | `#FAFAFA` (light) / `#0A0A0A` (dark mode) |
| Card bg | `#FFFFFF` / `#1A1A1A` with rounded 16px + subtle shadow |
| Section divider | `#F0F0F0` / `#1F1F1F` (1px) |
| Primary button | Gradient `#4F46E5` → `#7C3AED`, rounded 12px, 48px height |
| Secondary button | `#F0F0F0` / `#1F1F1F` bg, rounded 12px |
| Toggle (ON) | `#4F46E5` track |
| Input field | `#F5F5F5` / `#1A1A1A` bg, rounded 12px, 48px height |

### 8C. Animation & Motion Design

| Interaction | Animation | Duration | Curve |
|-------------|-----------|----------|-------|
| **Double-tap like** | Heart scales 0→1.2→1.0, then fades after 800ms. Particle burst (6 mini-hearts scatter outward). Haptic: medium impact. | 600ms | `Curves.elasticOut` |
| **Bookmark save** | Icon fills from bottom-up (like pouring ink). Subtle bounce at end. Haptic: light. | 400ms | `Curves.easeOutBack` |
| **Follow button** | Pill shrinks to checkmark circle, color fills from left. Confetti burst (3 tiny dots). Haptic: success. | 500ms | `Curves.easeInOutCubic` |
| **Comment sheet open** | Slides up from bottom with spring physics. Background dims with `#80000000`. Video keeps playing (dimmed). | 400ms | `spring(damping: 0.85)` |
| **Share sheet open** | Slides up, icons pop in sequentially (50ms stagger per icon). | 350ms + stagger | `Curves.easeOutCubic` |
| **Action icon tap** | Scale 1.0 → 0.85 → 1.1 → 1.0. Color change simultaneous. | 300ms | `Curves.elasticOut` |
| **Reel transition (swipe)** | Current reel scales to 0.95 + blurs. Next reel slides in full. Parallax: next reel moves 20% faster than current exits. | 350ms | `Curves.easeInOutCubic` |
| **Seekbar expand** | Height 2px → 4px, thumb circle appears (scale 0→1), translucent time tooltip fades in above thumb. | 200ms | `Curves.easeOut` |
| **Caption expand** | Text height animates smoothly. "more" fades out, full text fades in. Gradient mask at bottom for truncated state. | 300ms | `Curves.easeInOut` |
| **Sound ticker** | Disc image rotates infinitely (3s per rotation). Pauses on video pause (rotation friction slow-down). | Infinite | `Curves.linear` |
| **Feed tab switch** | Active tab: text scales 1.0→1.1, weight bold, underline slides to position. Inactive shrinks. | 250ms | `Curves.easeInOut` |
| **Loading shimmer** | Gradient sweep left-to-right on dark skeleton. Multiple layers: video (full), avatar (circle), text (3 lines). | 1500ms loop | Linear |
| **Reaction picker** | Opens radially from like button. Each emoji bounces in with 30ms stagger. Long-press hold scales selected emoji. | 300ms + stagger | `Curves.bounceOut` |
| **Profile peek** | Long-press avatar → glass card scales from avatar position, fade-in bio/stats. Release → spring close. | 400ms | `spring(damping: 0.8)` |
| **Number counter** | Digits slide up/down (slot machine effect) when count changes. | 300ms | `Curves.easeOutCubic` |
| **Page transitions** | Camera → Editor: shared element hero (video thumbnail). Editor → Publish: horizontal slide. | 400ms | `Curves.easeInOutCubic` |
| **Error/retry state** | Gentle shake (3 cycles, ±4px), then show retry button with fade-in. | 400ms | `Curves.elasticIn` |
| **Pull-to-refresh** | Custom: brand logo spins as indicator (not default Material spinner). | Until complete | `Curves.linear` rotation |

### 8D. Component Design Specs

#### Action Bar (Right Side)
```
┌──────┐
│      │
│  ┌─┐ │  Avatar: 36px circle, 2px white border
│  │A│ │  "+" badge: 18px blue circle, bottom-right
│  └─┘ │  Glow ring if live
│      │
│  ♥   │  Icon: 28px, SF Symbols weight: semibold
│  12K │  Count: SF Mono 11px, medium weight
│      │  Spacing: 2px between icon and count
│  💬  │  Same sizing as above
│  340 │
│      │
│  ↗   │  Share: 26px icon
│      │
│  🔖  │  Bookmark: 26px, fills on save
│      │
│  ⋯   │  More: 24px
│      │
│  ┌─┐ │  Sound disc: 32px circle, rotating
│  │♫│ │  Album art if available, note icon if not
│  └─┘ │  3px white border, rounded
│      │
└──────┘
  Width: 52px column
  Item spacing: 20px vertical
  Position: right: 8px, bottom: 120px (above nav)
  Background: none (icons have individual shadows)
```

#### Author & Caption Area (Bottom-Left)
```
┌──────────────────────────────────────┐
│  @username · Follow                  │  Name: 14px bold white, shadow
│                                      │  · separator: 8px spacing
│  Caption text here with #hashtag     │  Follow: 12px semi-bold, pill bg
│  and @mention that is tappable...    │  Caption: 13px regular, max 2 lines
│  ...more                             │  "more": 13px semi-bold white
│                                      │  Gradient fade at line 2 bottom
│  🎵 Song Name - Artist ············ │  Sound: 12px, marquee if >200px
└──────────────────────────────────────┘
  Position: left: 12px, bottom: 100px
  Max width: screen_width - 72px (leaves room for action bar)
  Line spacing: 4px
  Caption tap: expands to max 8 lines
  Hashtag style: same color but bold
  Mention style: same color but bold, tappable
```

#### Feed Tab Bar (Top)
```
┌─────────────────────────────────────────┐
│  ● For You │ Following │ Trending      │
└─────────────────────────────────────────┘
  Position: top: SafeArea.top + 4px, centered
  Background: transparent (no bar bg)
  Active tab: 15px bold white, 1.1x scale
  Inactive tab: 14px medium, #B3FFFFFF
  Underline: 20px wide, 2px height, rounded, slides to active
  Spacing: 24px between tabs
  Tap: haptic light + underline slide animation
```

#### Comment Sheet
```
┌─────────────────────────────────────────────┐
│  ─── (drag handle: 40×4px, #4D4D4D, r2)    │
│                                              │
│  Comments  (3,241)         [Top ▼] [Newest]  │  Header: 16px bold
│  ─────────────────────────────────────────── │  Divider: #1F1F1F
│                                              │
│  📌 @creator: Pinned comment text here       │  Pinned: amber left border
│     ♥ 12K  · Reply  · 2h                    │  Meta: 11px, #80FFFFFF
│                                              │
│  ┌─┐ @user1: Comment text here               │  Avatar: 28px circle
│  │ │  ♥ 234  · Reply  · 5h                   │  Name: 13px bold
│  └─┘                                         │  Text: 13px regular
│      ── View 12 replies                      │  Replies: indented 40px
│                                              │
│  ┌─┐ @user2: Another comment                 │
│  │ │  ♥ 45  · Reply  · 8h                    │
│  └─┘                                         │
│                                              │
│  ┌──────────────────────────────── [GIF] [→] │  Input: 44px height
│  │ Add a comment...                          │  Bg: #1A1A1A
│  └───────────────────────────────────────── │  Send: gradient pill
└─────────────────────────────────────────────┘
  Background: #0D0D0D + BackdropFilter blur(30)
  Corner radius: top 20px
  Height: 70% of screen
  Drag to dismiss
  Smooth scroll with velocity-based physics
```

#### Camera Screen
```
┌─────────────────────────────────────────┐
│  [✕]                    [⚡ Flash] [🔄] │  Top: glass bar bg, 56px
│                                         │
│                                         │
│     ┌───────────────────────────┐       │
│     │                           │       │
│     │   CAMERA VIEWFINDER       │       │  Full-screen, rounded 0
│     │   (edge-to-edge)          │       │  Aspect: 9:16
│     │                           │       │
│     │   [AR Effect Preview]     │       │  AR overlay if selected
│     │                           │       │
│     └───────────────────────────┘       │
│                                         │
│  Right rail (vertical, glass bg):       │
│    [🎵 Sound]                           │  Icon + label, 10px font
│    [⏱ Timer]                            │  Selected: white bg pill
│    [⚡ Speed]                            │
│    [✨ Effect]                           │
│    [🔲 Green]                           │
│    [💡 Align]                           │
│                                         │
│  ══════╤══════╤══════╤══════ (segments) │  Progress: 4px, gradient per segment
│                                         │  Active segment pulses
│  ┌────────┐  ┌──────┐  ┌────────┐      │
│  │  ┌──┐  │  │  ◉   │  │  ✓    │      │  Gallery: 44px rounded 8, last photo
│  │  │📱│  │  │ 72px  │  │ Next  │      │  Capture: 72px, white ring 3px
│  │  └──┘  │  │      │  │       │      │  Next: gradient pill, appears after 1 clip
│  └────────┘  └──────┘  └────────┘      │
│                                         │
│    [15s] [30s] [60s] [90s]              │  Pills: 28px height, 12px font
│                                         │  Selected: white bg + black text
│                                         │  Others: glass bg + white text
└─────────────────────────────────────────┘
```

#### Editor Screen
```
┌─────────────────────────────────────────┐
│  [✕ Discard]   Edit Reel   [Undo][Redo]│  Top bar: glass bg
│                                         │
│  ┌───────────────────────────────┐      │
│  │                               │      │
│  │    VIDEO PREVIEW              │      │  Rounded 12px on editor
│  │    (with text/sticker overlays)│      │  Pinch-to-zoom in preview
│  │    Tap to play/pause          │      │
│  │                               │      │
│  └───────────────────────────────┘      │
│                                         │
│  ◁ ┌──┬──┬──┬──┬──┬──┐ ▷              │  Timeline: horizontal scroll
│    │c1│TR│c2│TR│c3│TR│                  │  Clips: 60px thumbs, rounded 6
│    └──┴──┴──┴──┴──┴──┘                  │  TR: transition icon between clips
│  ▷ ═════════●═══════════                │  Playhead: thin white line + dot
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ [Trim][Text][Sticker][Draw]     │    │  Tool tabs (scrollable)
│  │ [Filter][Effect][Audio][Speed]  │    │  Selected: gradient underline
│  │ [Adjust][Template][Voiceover]   │    │  Each opens bottom panel
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │  Tool panel (bottom)
│  │  (Shows selected tool's UI)     │    │  slide-up animation, 200px height
│  │  e.g. Filter carousel / Sliders │    │  glass bg + rounded top 16
│  └─────────────────────────────────┘    │
│                                         │
│           [ → Next ]                    │  Gradient pill, 48px, full width -32px
└─────────────────────────────────────────┘
```

#### Publish Screen
```
┌─────────────────────────────────────────┐
│  [← Back]    New Reel                   │  Top bar: standard app bar
│                                         │
│  ┌────────────────────────────────────┐ │
│  │ ┌──────┐  Write a caption...       │ │  Card: rounded 16, shadow
│  │ │      │  Use #hashtags & @mentions │ │  Thumb: 80×120, rounded 12
│  │ │ THUMB│  Rich text with autocomplete│ │  Input: expanding, min 100px
│  │ │      │                           │ │
│  │ └──────┘                           │ │
│  └────────────────────────────────────┘ │
│                                         │
│  ┌────────────────────────────────────┐ │  Cover Photo section
│  │ 🖼  Cover Photo            [Edit]  │ │  Rounded 16, show selected frame
│  │ ┌──┐┌──┐┌──┐┌──┐┌──┐             │ │  Frame strip: horizontal scroll
│  │ │f1││f2││f3││f4││f5│  or Upload ↑ │ │  60×80px per frame, rounded 8
│  └────────────────────────────────────┘ │
│                                         │
│  ─── Settings ─────────────────────── │  Section header: 12px caps, gray
│                                         │
│  📍 Add Location                   →  │  Each row: 52px height, icon 20px
│  👥 Tag People                     →  │  Icon color: #4F46E5
│  📂 Topics (max 3)                 →  │  Divider: #F0F0F0, indent 52px
│  🔒 Public                     [▼]   │  Dropdown: glass select
│  💬 Everyone can comment       [▼]   │
│  🔄 Allow Remix                   ●   │  Toggle: brand purple when ON
│  ⬇️  Allow Download               ●   │
│                                         │
│  ─── Share To ────────────────────── │
│  📰 Also post to Feed              ●   │
│  📱 Also share to Story            ●   │
│                                         │
│  ─── Advanced ───────────────────── │
│  🕐 Schedule for later             →  │
│  👥 Invite Collaborator            →  │
│  🔬 A/B Thumbnail Test             →  │
│                                         │
│  ┌──────────────┐ ┌──────────────────┐ │  Bottom: pinned, 80px
│  │  Save Draft   │ │  Publish Now ▶  │ │  Draft: outlined, Publish: gradient
│  └──────────────┘ └──────────────────┘ │  Both: 48px height, rounded 12
└─────────────────────────────────────────┘
```

### 8E. Responsive & Device-Specific Design

| Device | Adaptations |
|--------|-------------|
| **Small phone (<375px width)** | Action bar icons shrink to 24px, caption area max 1 line before "more", timeline clips 48px |
| **Standard phone (375-414px)** | Default sizing as specified above |
| **Large phone (>414px, Pro Max)** | Action bar spacing increases, timeline clips 72px, more caption visible |
| **Tablet** | Split view: reel on left 60%, comments/info on right 40%. Timer/editor tools in sidebar. |
| **Notch/Dynamic Island** | All top UI elements clear `SafeArea.top` + 4px. No content under notch. |
| **Bottom home indicator** | Bottom nav and bottom-pinned buttons clear `SafeArea.bottom`. |
| **OLED screens** | Pure `#000000` black (not `#121212`). Maximizes OLED power savings. |
| **120Hz displays** | All animations render at screen refresh rate (no frame drops). |

### 8F. Accessibility Design

| Feature | Implementation |
|---------|---------------|
| **Contrast ratio** | All text on video: min 4.5:1 (ensured by text shadow + semi-transparent bg when needed) |
| **Font scaling** | Respects system font size. All text uses `sp` units. Layouts flex without overflow. |
| **Screen reader** | Every icon has `Semantics` label. Reels announce: "Reel by [author], [caption], [like count] likes" |
| **Reduce motion** | If `MediaQuery.reduceMotion`, disable: particle effects, parallax, rotation. Keep: slide transitions (faster). |
| **Color blind** | Don't rely on color alone. All status indicators have icon + color + text. |
| **One-handed use** | All primary actions (like, comment, share) reachable in bottom 60% of screen |

### 8G. Design Anti-Patterns (FORBIDDEN)

| NEVER DO THIS | DO THIS INSTEAD |
|---------------|-----------------|
| Default `CircularProgressIndicator` | Custom shimmer skeleton matching content layout |
| White/grey backgrounds on reel screens | Pure black / glass morphism overlays |
| Material `BottomSheet` with white bg | Custom sheet with `#0D0D0D` + `BackdropFilter.blur(30)` |
| Material `SnackBar` for errors | Custom toast with glass bg, icon, slide-in animation |
| Default `AppBar` on reel screens | Transparent status bar, custom glass overlay |
| `AlertDialog` for confirmations | Custom modal with blur background, rounded 20px, glass bg |
| Plain `TextField` with underline | Custom input with dark bg, rounded 12px, no border, focus glow |
| Default `Switch` widget | Custom toggle with brand purple, smooth thumb animation |
| `Text` with default style | Always specify `fontWeight`, `fontSize`, `color`, `shadows` |
| Empty state with just text | Illustration + title + subtitle + CTA button, centered |
| `ListView` without scroll physics | Always `BouncingScrollPhysics()` (iOS-style bounce) |
| Hard edges / sharp corners | Minimum `borderRadius: 8px` on all containers |
| Static numbers (123 → 124) | Animated digit transitions (slot machine style) |

---

## 9. Sponsored & Promoted Reels (CampaignV2 Integration)

> **Critical:** Promoted reels are served from the existing **CampaignV2 / Ads Manager V2** system — NOT a separate ad pipeline. Reels V2 is a consumer of the existing ad serve infrastructure.

### How Sponsored Reels Work (Architecture)

```
┌──────────────────────────────────────────────────────────┐
│  CampaignV2 Backend (EXISTING)                           │
│  POST /api/campaigns-v2/boost   → Creates AdCampaign    │
│       source_reel_id + source_content_type: "reel"       │
│  GET  /api/campaigns-v2/serve?placement=Reels&count=N    │
│       → Returns eligible sponsored reels (AdServeCtrl)   │
│  POST /api/campaigns-v2/beacon  → Logs impression        │
│  POST /api/campaigns-v2/beacon/batch → Batch impressions │
└──────────────────────────────────────────────────────────┘
           │                           ▲
           ▼                           │
┌──────────────────────────────────────────────────────────┐
│  Reels V2 Flutter Client                                 │
│                                                          │
│  ReelsFeedController:                                    │
│   1. Fetch organic reels → /api/v2/reels/feed/for-you   │
│   2. Fetch sponsored reels → /api/campaigns-v2/serve     │
│      (placement=Reels, count=2, per page)                │
│   3. MERGE: Insert 1 sponsored reel every 5-7 organic    │
│   4. On view → POST /api/campaigns-v2/beacon (impression)│
│   5. On click → POST /api/campaigns-v2/beacon (click)    │
│                                                          │
│  ReelsBoostController:                                   │
│   1. User taps "Boost" on own reel                       │
│   2. Opens boost flow → budget, targeting, schedule       │
│   3. POST /api/campaigns-v2/boost (source_reel_id=...)   │
│   4. Campaign goes through admin approval → goes live     │
└──────────────────────────────────────────────────────────┘
```

### Sponsored Reel Display Rules
| Rule | Detail |
|------|--------|
| Frequency | 1 sponsored reel per 5-7 organic reels (configurable server-side) |
| Label | "Sponsored" badge below author name (non-removable, legal compliance) |
| CTA button | "Shop Now", "Learn More", etc. from `Ad.call_to_action` |
| Destination | Opens `Ad.destination_url` in in-app browser or deep link |
| Skip-able | User can swipe past (counts as impression, not click) |
| "Hide Ad" | "Not interested" → `POST /api/campaigns-v2/beacon` with event=`hide` |
| "Why this ad?" | Shows targeting reason (e.g. "Based on your interests in Technology") |
| Frequency cap | Max N impressions per user per day (from `AdSet.frequency_cap`) |
| Budget gating | Ad stops serving when `AdSet.daily_budget` exhausted |

### Sponsored Reel UI Overlay
```
┌─────────────────────────────┐
│                             │
│     [SPONSORED REEL VIDEO]  │
│                             │
│                             │
│  @brand · Sponsored    [♥]  │  ← "Sponsored" label (white, semi-transparent)
│  Ad headline text      [💬] │
│  Description...        [↗]  │
│                             │
│  ┌─────────────────────────┐│
│  │   [Shop Now →]          ││  ← CTA button (primary color, full width)
│  └─────────────────────────┘│
│  🎵 Sound name ···    [⋯]  │  ← "⋯" opens: Hide Ad, Why this ad?, Report ad
│  ═══════════════════        │
└─────────────────────────────┘
```

### Files for Sponsored Reels Integration

```
lib/app/modules/reelsV2/
├── sponsored/
│   ├── controllers/
│   │   └── reels_sponsored_controller.dart     # Fetch & merge sponsored reels
│   ├── widgets/
│   │   ├── sponsored_reel_overlay.dart          # "Sponsored" badge + CTA button
│   │   ├── sponsored_cta_button.dart            # Call-to-action button (dynamic)
│   │   ├── why_this_ad_sheet.dart               # "Why this ad?" bottom sheet
│   │   └── ad_feedback_menu.dart                # Hide ad, report ad options
│   ├── models/
│   │   └── sponsored_reel_model.dart            # Maps CampaignV2 Ad → reel format
│   └── services/
│       └── reels_ad_serve_service.dart           # Wraps /campaigns-v2/serve + /beacon
│
├── boost/
│   ├── bindings/
│   │   └── reels_boost_binding.dart
│   ├── controllers/
│   │   └── reels_boost_controller.dart          # Boost own reel (budget, targeting, submit)
│   ├── views/
│   │   └── reels_boost_view.dart                # Boost creation form (full-page)
│   └── widgets/
│       ├── boost_budget_selector.dart           # Budget slider + daily/lifetime toggle
│       ├── boost_audience_picker.dart           # Location, age, gender, interests
│       ├── boost_schedule_picker.dart           # Start/end date
│       ├── boost_preview_card.dart              # Preview how boosted reel will look
│       ├── boost_cta_selector.dart              # CTA dropdown (Learn More, Shop Now, etc.)
│       ├── boost_performance_card.dart          # Live performance stats (after launch)
│       └── boost_status_badge.dart              # Draft/Pending/Active/Paused/Completed
```

### Boost Flow (User Creating Promoted Reel)
```
User's Reel → Tap "⋯" More → "Boost Reel"
    │
    ▼
┌──────────── Boost Reel Screen ────────────┐
│  [Reel Preview]                           │
│                                           │
│  Goal:  ○ More Views  ○ Profile Visits    │
│         ○ Website Traffic  ○ Messages      │
│                                           │
│  Audience:                                │
│    📍 Location: [Select]                  │
│    👤 Age: [18] - [65]                    │
│    ⚧ Gender: All / Male / Female          │
│    🎯 Interests: [Add keywords]           │
│                                           │
│  Budget & Duration:                        │
│    💰 $[5] per day   (Est: 500-1.2K views)│
│    📅 Duration: [7 days]                  │
│    📊 Total: $35.00                       │
│                                           │
│  CTA Button: [Shop Now ▼]                 │
│  Website: [https://...]                   │
│                                           │
│  [  Boost Reel — $35.00  ]               │
└───────────────────────────────────────────┘
    │
    ▼
POST /api/campaigns-v2/boost
  body: { source_reel_id, budget, targeting, cta, ... }
    │
    ▼
Admin Approval → Campaign ACTIVE → Reel served as Sponsored
```

### API Integration Map (CampaignV2 Endpoints Used)

| ReelsV2 Action | CampaignV2 Endpoint | Method |
|----------------|---------------------|--------|
| Fetch sponsored reels for feed | `GET /api/campaigns-v2/serve?placement=Reels` | AdServeController |
| Log impression (reel viewed) | `POST /api/campaigns-v2/beacon` | BeaconController |
| Log batch impressions | `POST /api/campaigns-v2/beacon/batch` | BeaconController |
| Log click (CTA tapped) | `POST /api/campaigns-v2/beacon` (event=click) | BeaconController |
| Hide ad / feedback | `POST /api/campaigns-v2/beacon` (event=hide) | BeaconController |
| Create boost campaign | `POST /api/campaigns-v2/boost` | CampaignV2Controller |
| Get boost status | `GET /api/campaigns-v2/campaigns/:id` | CampaignV2Controller |
| Get boost analytics | `GET /api/campaigns-v2/analytics/:campaignId` | BeaconController |
| Get boost demographics | `GET /api/campaigns-v2/analytics/:campaignId/demographics` | BeaconController |
| Ad engagement (reactions) | `POST /api/campaigns-v2/engagement/reaction` | AdEngagementController |
| Ad engagement (comments) | `POST /api/campaigns-v2/engagement/comment` | AdEngagementController |

---

## 10. Performance & Scalability Strategy (Serving Bulk Users)

> **Goal:** Serve 100K–1M+ concurrent users viewing/creating reels with <200ms feed load and <50ms video start. This section covers EVERY layer: client, network, CDN, API, and database.

### 10A. Video Delivery Pipeline (CDN-First Architecture)

```
┌─────────────┐     ┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│   Creator    │     │  qp-api     │     │  Processing  │     │  CDN Edge    │
│   uploads    │────▶│  receives   │────▶│  Worker      │────▶│  (CloudFront │
│   raw video  │     │  chunk      │     │  (FFmpeg)    │     │   /BunnyCDN) │
└─────────────┘     └─────────────┘     │              │     └──────┬───────┘
                                         │  Generates:  │            │
                                         │  • 360p.mp4  │     ┌──────▼───────┐
                                         │  • 480p.mp4  │     │  Global Edge │
                                         │  • 720p.mp4  │     │  Servers     │
                                         │  • 1080p.mp4 │     │  (50+ PoPs)  │
                                         │  • thumb.jpg │     └──────┬───────┘
                                         │  • poster.webp│           │
                                         └──────────────┘     ┌──────▼───────┐
                                                               │  User Device │
                                                               │  (nearest    │
                                                               │   edge node) │
                                                               └──────────────┘
```

| Strategy | Detail |
|----------|--------|
| **Multi-quality transcoding** | Server generates 4 variants (360p/480p/720p/1080p) via FFmpeg worker |
| **CDN distribution** | Videos served from edge node closest to user (not from origin API) |
| **Adaptive bitrate** | Client starts 480p, upgrades/downgrades based on real-time bandwidth |
| **HLS streaming** | Generate `.m3u8` playlists with segment files for true adaptive streaming |
| **Thumbnail strip** | Pre-generate 10-frame thumbnail strip for instant seek preview |
| **Poster frame** | WebP poster image loads in <50ms (shown before video buffer starts) |
| **Pre-signed URLs** | CDN URLs are pre-signed with 24hr expiry (no auth overhead per request) |
| **Cache headers** | `Cache-Control: public, max-age=86400` on video files (CDN caches 24hr) |

### 10B. Smart Video Preloading (Enhanced for Bulk)

| Strategy | Detail |
|----------|--------|
| **Pool size** | 5 controllers (2 prev + current + 2 next) |
| **Adaptive pool** | Reduce to 3 on low-RAM devices (<3GB), expand to 7 on high-RAM |
| **Quality ladder** | Start 480p → if WiFi + >10Mbps → upgrade to 720p/1080p mid-play |
| **Thumbnail-first** | Show cached WebP poster instantly, video loads behind it |
| **1-second rule** | Preload first 1 second of next 2 reels (not full video) — enough for instant start |
| **Bandwidth probe** | On app open, measure download speed → set initial quality tier |
| **Zero-frame start** | Poster → first keyframe → full video stream (user sees content in <100ms) |
| **Cache policy** | LRU cache, max 500MB on device, auto-evict oldest |
| **Background fetch** | Prefetch next 5 thumbnails + first-second of next 2 videos while current plays |
| **WiFi vs Cellular** | WiFi: preload 2 full reels ahead. Cellular: preload 1-second chunks only |
| **Seek optimization** | Pre-decoded keyframes at 0%, 25%, 50%, 75% for instant scrubbing |

### 10C. Feed Pagination & Scalability

| Strategy | Detail |
|----------|--------|
| **Cursor-based pagination** | NOT offset-based. Uses `lastId` + `lastScore` cursors (O(1) vs O(n) offset) |
| **Page size** | 10 reels per page (tested optimal: enough for ~30s of swiping) |
| **Prefetch trigger** | Load next page when 3 reels from end (user never sees loading) |
| **Feed cache** | Cache current page in GetStorage — instant restore on tab switch |
| **Stale-while-revalidate** | Show cached feed instantly, refresh in background |
| **Dedup** | Client-side `Set<String>` of seen reel IDs → no repeated content |
| **Empty guard** | If API returns <3 reels, auto-switch to trending fallback |
| **Error recovery** | Retry failed loads silently (3x with exponential backoff), then show retry CTA |
| **Rate limit awareness** | If API returns 429, back off and show cached content |

### 10D. Memory Management (Critical for Bulk Viewing)

| Strategy | Detail |
|----------|--------|
| **Controller disposal** | Dispose controllers outside 5-reel window IMMEDIATELY |
| **Video buffer limit** | Each VideoPlayerController buffers max 10s ahead (not entire video) |
| **Image cache** | `CachedNetworkImage` with 200MB max, FIFO eviction |
| **Comment lazy-load** | Comments sheet loads ONLY when user taps comment icon |
| **Reaction defer** | Reaction list fetches ONLY on user tap |
| **Sticker/GIF lazy** | GIPHY loads on picker open, thumbnail-first |
| **Draft in filesystem** | Drafts stored on disk (not in RAM), loaded on demand |
| **Memory pressure listener** | Listen to `SystemChannels.lifecycle` → on `memoryWarning` → dispose extra controllers + clear image cache |
| **Isolate for processing** | FFmpeg operations run in separate Dart isolate (never blocks UI thread) |

### 10E. Upload Optimization (Bulk Creators)

| Strategy | Detail |
|----------|--------|
| **Client-side compression** | FFmpeg H.264 encoding, CRF 23, target <50MB for 60s reel |
| **Chunked upload** | Multipart upload in 2MB chunks, resume on failure (each chunk has checksum) |
| **Background upload** | Uses `WorkManager` / `flutter_background_service` — continues after app close |
| **Parallel upload** | UP TO 2 reels uploading simultaneously (queued if more) |
| **Progress indicator** | Real-time upload % shown in sticky notification + in-app banner |
| **Retry logic** | Exponential backoff (1s → 2s → 4s → 8s → 16s), max 5 retries per chunk |
| **Server processing** | After upload, server FFmpeg worker transcodes → generates quality variants → pushes to CDN |
| **Processing status** | WebSocket/polling for processing progress (0% → "Encoding 720p" → "Generating thumbnails" → "Published") |
| **Duplicate detection** | Server computes video fingerprint hash → reject true duplicates |

### 10F. API Response Optimization

| Strategy | Detail |
|----------|--------|
| **Lean payloads** | Feed endpoint returns ONLY fields needed for feed display (no full reel detail) |
| **Field selection** | `?fields=id,videoUrl,thumbnailUrl,authorName,likeCount,caption` — no over-fetching |
| **CDN URLs in response** | API returns CDN URLs directly (no client-side URL construction) |
| **gzip/brotli** | All API responses compressed (brotli preferred, 20-30% smaller than gzip) |
| **ETag caching** | API sends ETag → client caches → next request sends `If-None-Match` → 304 Not Modified |
| **Batch endpoints** | Batch view tracking, batch impressions (1 request per 10 events, not per-event) |
| **Connection pooling** | Dio HTTP client reuses TCP connections (keep-alive) |
| **Request dedup** | If same endpoint called while previous is in-flight, return same Future (no duplicate requests) |

### 10G. Database Query Optimization (Backend)

| Strategy | Detail |
|----------|--------|
| **Compound indexes** | `{ status: 1, createdAt: -1 }` for feed queries |
| **Covered queries** | Feed index includes projected fields to avoid collection scan |
| **Read replicas** | Feed reads from secondary replica set (write to primary) |
| **Materialized views** | Pre-computed "trending" list refreshed every 5 minutes (not computed per-request) |
| **Aggregation pipeline** | Feed ranking uses single `$match → $addFields → $sort → $limit` pipeline |
| **TTL indexes** | Auto-delete tracking/impression docs after 90 days |
| **Sharding ready** | Reel documents keyed by `authorId` hash for future horizontal sharding |
| **Capped collections** | View tracking uses capped collection (automatic FIFO, no manual cleanup) |
| **Connection pooling** | MongoDB driver poolSize=50 (handles concurrent feed requests) |

### 10H. Real-Time Engagement (WebSocket for Bulk Users)

| Feature | Implementation |
|---------|---------------|
| **Live view count** | WebSocket broadcasts view count every 5s for currently-playing reels |
| **Live like count** | Debounced — batch like count updates every 3s |
| **Live comment stream** | New comments push to open comment sheets in real-time |
| **Typing indicator** | "X is typing..." in comment sheet |
| **Boost live stats** | Real-time impression/click count for active boost campaigns |
| **Scaling** | Socket.IO with Redis adapter → multiple Node.js instances share sessions |
| **Fallback** | If WebSocket fails, fall back to 10s polling (graceful degradation) |

### 10I. Offline & Poor Network Resilience

| Scenario | Handling |
|----------|----------|
| **No network** | Show cached feed (last successful page), "No connection" banner |
| **Slow network (<1Mbps)** | Auto-switch to 360p, disable preloading (current only) |
| **Intermittent** | Retry queue for failed reactions/comments/views — send when back online |
| **Upload interrupted** | Resume from last successful chunk (checksum verified) |
| **Draft auto-save** | Every 10s auto-save draft to local filesystem (survives crash) |
| **Optimistic UI** | Like/save/follow update UI instantly, sync to server in background |

### 10J. Scalability Metrics & Monitoring

| Metric | Target | Alert Threshold |
|--------|--------|-----------------|
| Feed API p50 latency | <100ms | >300ms |
| Feed API p99 latency | <500ms | >1s |
| Video start time (perceived) | <200ms | >500ms |
| Upload throughput | >5MB/s on WiFi | <1MB/s |
| Memory usage (app) | <300MB during reel viewing | >500MB |
| Cache hit rate (CDN) | >90% | <70% |
| Concurrent viewers per reel | 100K+ | N/A |
| API requests/sec (feed) | 10K rps | >80% capacity |
| Error rate (API) | <0.1% | >1% |
| WebSocket connections | 50K per node | >80% capacity |

---

## 11. Navigation & V1/V2 Comparison Strategy

> **This section documents the dual-nav approach.** During development and testing, Reels V2 lives as an **additional** tab in the bottom navigation — sitting right next to the existing V1 Reels tab. This allows instant side-by-side comparison without disrupting V1 users.

### Why Dual-Nav (Not Feature Flags)
| Approach | Pros | Cons |
|----------|------|------|
| **Feature flag** | Hidden from users, clean nav | Can't compare side-by-side, difficult A/B testing on same device |
| **Dual-nav (chosen)** | Instant comparison, dev-friendly, no flag complexity | Extra nav item (temporary) |

### Bottom Nav Configuration

**Normal Profile (Current V1):**
```
[Home] [Reels] [Friends] [Marketplace] [Notifications] [Profile]
  0      1        2           3              4             5
```

**Normal Profile (With V2 Added):**
```
[Home] [Reels] [V2 ✨] [Friends] [Marketplace] [Notifications] [Profile]
  0      1       2        3           4              5             6
```

**Page Profile (With V2 Added):**
```
[Home] [Reels] [V2 ✨] [Pages] [Marketplace] [Notifications] [Profile]
  0      1       2       3          4              5             6
```

### V2 Button Visual Differentiation
- Same `QpIcon.reels` icon but with a **small gradient sparkle badge** (8px, top-right of icon)
- Label: `"V2 ✨"` (shorter to save nav space)
- Icon tint: subtle gradient overlay (#4F46E5 → #7C3AED) vs V1's standard white
- When V2 is fully validated: remove V1 tab, V2 becomes "Reels" at index 1 (Phase 12B)

### TabController Index Mapping Updates

```dart
// BEFORE (V1 only — current)
static const _normalNavToTab = [0, 1, 2, 4, 5, 6];  // 6 bottom items → 7 tabs
static const _pageNavToTab   = [0, 1, 2, 3, 4, 5];   // 6 bottom items → 6 tabs

// AFTER (V1 + V2 dual-nav)
static const _normalNavToTab = [0, 1, NEW_V2_IDX, 2, 4, 5, 6];  // 7 bottom items → 8 tabs
static const _pageNavToTab   = [0, 1, NEW_V2_IDX, 2, 3, 4, 5];  // 7 bottom items → 7 tabs
```

### Memory & Performance of Dual-Nav
- V2 tab uses `AutomaticKeepAliveClientMixin` — stays alive when switching to V1
- V2 videos **pause immediately** when switching away (identical to V1 behavior)
- Memory budget: V1 and V2 should **not** both preload videos simultaneously
- If device memory < 2GB: show warning before enabling V2 tab

### Removal Timeline
1. **Phase 12 (Now):** Add V2 tab next to V1 → develop & test
2. **Phase 12B (After validation):** Remove V1 tab → V2 becomes sole "Reels"
3. **Phase 12C (Clean up):** Archive/delete V1 code from codebase

---

## 12. Migration & Rollout Strategy

### Feature Flag System
```dart
// In EarningConfigService or a new ReelsConfigService
class ReelsConfigService extends GetxService {
  final useReelsV2 = false.obs;    // Toggle V1 ↔ V2
  final v2Features = <String, bool>{
    'remix': false,
    'abThumbnail': false,
    'greenScreen': false,
    'autoCaptions': false,
    'scheduling': false,
    'collections': false,
    'analytics': false,
  }.obs;
}
```

### Rollout Phases
| Phase | Scope | Rollback |
|-------|-------|----------|
| Alpha | Dev team only (flag ON for dev accounts) | Instant flag OFF |
| Beta | 5% of users (random cohort) | Flag OFF for cohort |
| Staged | 25% → 50% → 75% | Gradual flag adjustment |
| GA | 100% (default ON) | Flag still available |
| Sunset V1 | Remove V1 code | N/A (V1 code deleted) |

### V1 → V2 Data Continuity

> **Consistent with Section 6A Isolation Mandate:** V2 uses ALL-NEW collections. V1 data stays in V1 collections untouched.

| Data Type | V1 → V2 Handling |
|-----------|------------------|
| **Existing reels** | Stay in V1 `reels` collection. V2 `reels_v2` starts empty. New reels created via V2 go to `reels_v2`. |
| **User profiles, followers, following** | Shared at platform level (not reel-specific). Both V1 and V2 use the same `users` collection. |
| **Bookmarks / Saved reels** | V2 has new `reel_v2_bookmarks` collection. V1 bookmarks stay in V1. Users re-bookmark favorites in V2. |
| **Watch history** | V2 has new `reel_v2_watch_history` collection. V1 history stays in V1. |
| **Comments & Reactions** | V1 comments stay with V1 reels. V2 reels get fresh V2 comments/reactions. |
| **Drafts** | V1 drafts NOT compatible with V2 (different format). No migration. |
| **Sounds / Audio** | V2 has new `reel_v2_sounds` collection. Popular sounds can be re-imported via admin script. |
| **Analytics** | V2 analytics start fresh in `reel_v2_analytics`. V1 analytics stay in V1. |

**Post-Sunset V1 Migration (Phase 12C, optional):**
- A one-time migration script can convert high-performing V1 reels into `reels_v2` format
- Script maps V1 fields → V2 schema, generates missing fields with defaults
- Only run after V1 sunset decision — NOT during dual-nav period

---

## Appendix A — Route Plan

### New Routes for V2
| Route Constant | Path | View | Binding |
|---------------|------|------|---------|
| `REELS_V2` | `/reels-v2` | `ReelsV2View` | `ReelsV2Binding` |
| `REELS_V2_CAMERA` | `/reels-v2/camera` | `ReelsCameraView` | `ReelsCameraBinding` |
| `REELS_V2_EDITOR` | `/reels-v2/editor` | `ReelsEditorView` | `ReelsEditorBinding` |
| `REELS_V2_PUBLISH` | `/reels-v2/publish` | `ReelsPublishView` | `ReelsPublishBinding` |
| `REELS_V2_PREVIEW` | `/reels-v2/preview` | `ReelsPreviewView` | — |
| `REELS_V2_DRAFTS` | `/reels-v2/drafts` | `ReelsDraftView` | `ReelsDraftBinding` |
| `REELS_V2_REMIX` | `/reels-v2/remix` | `RemixDuetView` | `ReelsRemixBinding` |
| `REELS_V2_STITCH` | `/reels-v2/stitch` | `RemixStitchView` | `ReelsRemixBinding` |
| `REELS_V2_ANALYTICS` | `/reels-v2/analytics` | `ReelsAnalyticsDashboardView` | `ReelsAnalyticsBinding` |
| `REELS_V2_REEL_INSIGHT` | `/reels-v2/insight/:id` | `ReelInsightView` | `ReelsAnalyticsBinding` |
| `REELS_V2_SEARCH` | `/reels-v2/search` | `ReelsSearchView` | `ReelsSearchBinding` |
| `REELS_V2_MUSIC` | `/reels-v2/music` | `MusicLibraryView` | `ReelsAudioBinding` |
| `REELS_V2_SOUNDTRACK` | `/reels-v2/soundtrack/:id` | `SoundtrackPageView` | `ReelsAudioBinding` |
| `REELS_V2_HASHTAG` | `/reels-v2/hashtag/:tag` | `HashtagFeedView` | — |
| `REELS_V2_LOCATION` | `/reels-v2/location/:id` | `LocationFeedView` | — |
| `REELS_V2_COLLECTIONS` | `/reels-v2/collections` | `CollectionsView` | — |
| `REELS_V2_SETTINGS` | `/reels-v2/settings` | `ReelsSettingsView` | — |
| `REELS_V2_DETAIL` | `/reels-v2/reel/:id` | `ReelDetailView` | — |
| `REELS_V2_BOOST` | `/reels-v2/boost` | `ReelsBoostView` | `ReelsBoostBinding` |

---

## Appendix B — New Packages to Add (pubspec.yaml)

```yaml
# Video Processing
ffmpeg_kit_flutter: ^6.0.3          # FFmpeg for trim, merge, effects, encoding

# Audio
just_audio: ^0.9.39                 # Advanced audio playback for music library

# Gallery
wechat_assets_picker: ^9.0.0        # Instagram-style gallery picker (multi-select)
photo_manager: ^3.2.2               # Gallery access and permissions

# UI / Animation
lottie: ^3.1.0                      # Lottie animations (heart burst, stickers)
shimmer: ^3.0.0                     # Loading shimmer effects

# Stickers & Drawing
giphy_get: ^3.5.3                   # GIF sticker picker (Giphy API)
flutter_drawing_board: ^0.4.4       # Freehand drawing canvas
flutter_colorpicker: ^1.1.0         # Full-spectrum color picker

# Caching
cached_network_image: ^3.3.1        # Network image caching with placeholders
flutter_cache_manager: ^3.3.1       # Video/file caching

# Sharing
share_plus: ^9.0.0                  # Native OS share sheet

# ML / Accessibility
google_mlkit_text_recognition: ^0.12.0  # Auto-caption generation

# Storage
path_provider: ^2.1.3               # Local file paths for drafts & cache
```

---

## Appendix C — File Count Summary

| Phase | New Files | Modified Files | Total |
|-------|-----------|---------------|-------|
| **Phase 0B — Backend Foundation (qp-api)** | **~63** | **1** | **~64** |
| Phase 0 — Flutter Foundation & Core Player | 18 | 2 | 20 |
| Phase 1 — Playback UX & Gestures | 12 | 0 | 12 |
| Phase 2 — Interactions & Comments | 14 | 2 | **16 ✅** |
| Phase 3 — Camera & Recording | 11 | 1 | **12 ✅** |
| Phase 4 — Editing Suite | 19 | 1 | **20 ✅** |
| Phase 5 — Filters, Effects & Green Screen | 10 | 0 | **10 ✅** |
| Phase 6 — Audio & Sound System | 13 | 1 | **14 ✅** |
| Phase 7 — Publishing & Drafts | 17 | 1 | **18 ✅** |
| Phase 8 — Remix & Collaboration | 9 | 1 | **10 ✅** |
| Phase 9 — Discovery, Search & Collections | 14 | 2 | **16 ✅** |
| Phase 10 — Creator Analytics | 12 | 2 | **14 ✅** |
| Phase 11 — Settings & Accessibility | 8 | 0 | **8 ✅** |
| Phase 12 — Navigation & V1/V2 Comparison | 0 | 5 | **5 ✅** |
| Phase 12B — Full Integration (deferred) | 5 | 6 | **11 ✅** |
| Phase 13 — Sponsored Reels & Boost | 17 | 3 | **20 ✅** |
| **TOTAL** | **~238** | **~29** | **~267** |

### Backend vs Frontend File Breakdown
| Component | Files | Location |
|-----------|-------|----------|
| **Backend (qp-api)** | ~63 | `controller/ReelsV2/`, `models/ReelsV2/`, `services/ReelsV2/`, `routes/reels-v2/`, `validators/ReelsV2/`, `socket/reels-v2/`, `queue/`, `cronjob/`, `tests/reels-v2/` |
| **Frontend (Flutter)** | ~175 | `lib/app/modules/NAVIGATION_MENUS/reels_v2/` |
| **Modified (existing)** | ~29 | `tab_view.dart`, `app_routes.dart`, `index.js`, etc. |

---

---

## 13. Testing Strategy

### Backend Testing (qp-api)

| Layer | Tool | Coverage Target | Files |
|-------|------|----------------|-------|
| **Unit tests** | Jest | All controllers + services | `tests/reels-v2/*.test.js` |
| **API integration** | Supertest + Jest | All 70+ endpoints | `tests/reels-v2/integration/*.test.js` |
| **Load testing** | Artillery / k6 | Feed endpoint at 1K rps | `tests/reels-v2/load/feed-load.yml` |
| **Database** | MongoDB Memory Server | Schema validation, indexes | Runs in-memory during CI |

**Backend test rules:**
- Every controller function has at least 1 happy-path + 1 error-path test
- All validators tested with invalid inputs (missing fields, wrong types, boundary values)
- Feed endpoint tested with 10K+ reels in DB to verify pagination performance
- Rate limiting tested (verify 429 response after threshold)
- Zero references to V1 test files

### Flutter Testing

| Layer | Tool | Coverage Target |
|-------|------|-----------------|
| **Unit tests** | flutter_test | All controllers, services, models | 
| **Widget tests** | flutter_test | All custom widgets (player, action bar, comment sheet) |
| **Integration tests** | integration_test | Full flows: view feed, create reel, boost reel |
| **Golden tests** | golden_toolkit | Key screens (feed, camera, editor, publish) |

**Flutter test rules:**
- Every GetX controller tested with mock API service
- Video player mocked (never load real video in tests)
- Widget tests verify: renders correctly, handles tap events, shows loading/error states
- Integration tests run against staging API (not mocked)
- Golden tests compare pixel output against approved screenshots

### Test Execution
```bash
# Backend
cd qp-api && npm test -- --testPathPattern=reels-v2

# Flutter unit + widget
cd x-QpApsMain && flutter test test/reels_v2/

# Flutter integration
flutter test integration_test/reels_v2/
```

---

## 14. Security & Content Moderation

### Authentication & Authorization

| Concern | Implementation |
|---------|----------------|
| **Auth middleware** | All V2 routes use existing `authenticateToken` middleware — no anonymous access |
| **Ownership checks** | Edit/delete reel → verify `req.user._id === reel.author_id` (403 if not owner) |
| **Admin routes** | `/api/v2/reels/admin/*` → require `isAdmin` middleware |
| **Rate limiting** | Per-endpoint: 10 creates/min, 30 reactions/min, 20 comments/min, 100 feed reads/min |
| **Input validation** | All write endpoints validated by V2 validators (express-validator). Reject invalid early. |
| **File upload** | Max 500MB per video, allowed MIME types: `video/mp4`, `video/quicktime`, `video/webm` only |
| **Caption sanitization** | Strip HTML tags, limit 2200 chars, sanitize markdown injection |
| **URL validation** | Boost destination URLs validated against allowlist (no `javascript:`, `data:` schemes) |

### Content Moderation Pipeline

```
User uploads reel
       │
       ▼
┌─────────────────┐     ┌──────────────┐     ┌──────────────┐
│  Auto-Moderation │────▶│  If flagged:  │────▶│  Admin Queue  │
│  (on upload)     │     │  status =     │     │  Manual review│
│                  │     │  "under_review"│     │  approve/reject│
│  • File type     │     └──────────────┘     └──────────────┘
│  • File size     │
│  • Malware scan  │     ┌──────────────┐
│  • Duplicate hash│────▶│  If clean:    │
│                  │     │  status =     │
└─────────────────┘     │  "published"  │
                        └──────────────┘
```

### Abuse Prevention

| Threat | Mitigation |
|--------|------------|
| **Spam reels** | Rate limit 10 creates/min + duplicate hash detection |
| **Comment spam** | Rate limit + cooldown (5s between comments from same user) |
| **Reaction spam** | One reaction per user per reel (upsert pattern) |
| **Report abuse** | Max 5 reports/day per user to prevent weaponized reporting |
| **Bot detection** | Unusual patterns (100+ views from same IP) → flag for review |
| **Copyright** | Audio fingerprint matching against licensed library (future phase) |

---

## Appendix D — Audit Checklist (Pre-Implementation Verification)

- [x] All features in Section 2 inventory have corresponding Phase coverage
- [x] All Phase files referenced exist in Section 4 file structure
- [x] All 70+ endpoints in Section 6B are covered by Phase 0B backend tasks
- [x] Dart models in 7B match Mongoose schemas in 7A (field parity)
- [x] Section 12 data continuity aligns with Section 6A isolation mandate
- [x] Cron jobs defined for: scheduled publish, trending computation, analytics rollup
- [x] FFmpeg worker queue defined in Phase 0B
- [x] Phase dependency graph documented (parallel tracks identified)
- [x] Testing strategy covers backend + Flutter layers
- [x] Security & auth requirements documented
- [x] Content moderation pipeline defined
- [x] All new packages listed in Appendix B
- [x] File count in Appendix C reflects all phases

---

*🔒 **LOCKED PLAN** — This plan is the single source of truth for Reels V2 implementation. 15 phases (0B + 0–13), ~267 files. **Phase 0B (backend) MUST be completed first** — all V2 APIs proven with Postman before any Flutter work begins. Every backend file is 100% NEW — zero imports from V1 controllers/models/services. 14 new MongoDB collections, all with proper indexes. V1 code is NEVER modified. V2 data is fully isolated from V1 (new collections, new controllers, new services). Sponsored reels integrate with existing CampaignV2/Ads Manager V2 backend — no new ad infrastructure required. Plan reviewed, gaps fixed, and locked for implementation.*
