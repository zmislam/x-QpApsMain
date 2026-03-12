# Newsfeed Technical Documentation

## 1. Overview
This document details the architecture, components, and logic of the redeveloped mobile newsfeed (Feb 2026). The system is designed to mimic Facebook's mobile feed patterns, utilizing an **EdgeRank** algorithm for content ordering, **Optimistic UI** for instant interactions, and advanced **Performance Optimizations** for smooth scrolling.

---

## 2. Architecture

### 2.1 Core Pattern
The feed follows a **Repository-Controller-Mixin** pattern:
- **Repository (`EdgeRankRepository`)**: Handles raw API calls (`GET /api/edgerank/feed`), error handling, and data parsing.
- **Mixin (`EdgeRankFeedMixin`)**: Encapsulates feed-specific logic (pagination, cursor management, insertion tracking) to keep the main controller clean.
- **Controller (`HomeController`)**: Manages UI state, user interactions (like, comment), and bridges the repository with the view.

### 2.2 Data Flow
1.  **Fetch**: `HomeController` calls `refreshEdgeRankFeed()`.
2.  **API**: `EdgeRankRepository` requests data with a `cursor` (for pagination) and `session_seed` (for consistent ranking).
3.  **Parsers**:
    -   **Posts**: Parsed into `PostModel`.
    -   **Insertions**: Parsed into `FeedInsertionModel` (Ads, Friend Suggestions).
4.  **State**: Posts and Insertions are merged/interleaved based on `anchorPostId` and exposed via `edgeRankPosts` data stream.
5.  **View**: `HomeView` renders the list using `SliverList` and `FeedInsertionWidget`.

---

## 3. Key Components

### 3.1 Post Card (`PostCard`)
Located in `lib/app/components/post/post.dart`.
-   **Structure**:
    -   **Header**: User info, timestamp, menu (Report/Block). Varies by type (Shared, Group, Page).
    -   **Body**: Dynamic media renderer (Images, Videos, Text).
    -   **Footer**: Engagement counts and action buttons (Like, Comment, Share).
-   **Optimization**: Wrapped in `RepaintBoundary` to isolate painting instructions.

### 3.2 Story Tray (`AddStoryWidget` & `MyDayCard`)
-   **Height**: Fixed at `230px` (Cards are `200px` x `112px`).
-   **Design**: Vertical format with gradient overlays and "blue ring" avatars.
-   **Optimization**: Uses `CachedNetworkImage` for all media.

### 3.3 Post Creator (`PostCreatorBar`)
-   Reusable widget matching Facebook's "What's on your mind?" visual style.
-   Located in `lib/app/components/post/post_creator_bar.dart`.

### 3.4 Feed Insertions (`FeedInsertionWidget`)
-   Router widget that renders `SponsoredPostCard` or `FriendSuggestionCard` based on insertion type.

---

## 4. State Management & Logic

### 4.1 Optimistic Updates (Instant Interactions)
To ensure the app feels fast, interactions update the UI **before** the server responds.

**Likes (`reactOnPost`):**
1.  Update local `reactionCount` and `isLiked` status immediately.
2.  Refresh UI.
3.  Send API request.
4.  If API fails, revert local change.

**Comments (`commentOnPost` / `commentReply`):**
1.  Create a temporary `CommentModel` with a generated ID.
2.  Append to local `comments` list.
3.  Refresh UI (Comment appears instantly).
4.  Send API request.
5.  **Success**: Replace temp model with server response (sync IDs).
6.  **Failure**: Remove temp model and show error snackbar.

---

## 5. Performance Optimizations

### 5.1 Memory Management
High-resolution images (especially avatars) can crash low-end devices.
-   **Solution**: `RoundCornerNetworkImage` and `CachedNetworkImage` use `memCacheHeight` & `memCacheWidth`.
-   **Logic**: Images are decoded into memory at **3x their display size** (e.g., 50px avatar -> decoded as 150px), rather than full resolution (e.g., 1000px).

### 5.2 Scroll Performance
-   **RepaintBoundary**: Applied to `PostCard`. Prevents the entire feed from repainting when a single post (e.g., a video or like animation) updates.
-   **Concurrency**: `HomeView.onRefresh` waits for multiple API calls (`Feed`, `Stories`, `Suggestions`) in **parallel** using `Future.wait([])` instead of sequential await.

---

## 6. Design System (`FeedDesignTokens`)
Located in `lib/app/config/constants/feed_design_tokens.dart`.
-   Central source of truth for:
    -   **Colors**: `textPrimary`, `cardBg`, `scaffoldBg` (Light/Dark mode adaptive).
    -   **Dimensions**: `cardPadding`, `avatarSize`, `storyCardHeight`.
    -   **Typography**: Consistent font weights and sizes.
-   **Usage**: Always use `FeedDesignTokens.tokenName(context)` instead of hardcoded values.

---

## 7. Future Development
-   **Adding New Post Types**: Update `PostCard._buildHeader` and `_buildBody` switch cases.
-   **New Feed Insertions**: Add type to `FeedInsertionModel` and component to `FeedInsertionWidget`.
-   **Modals**: Use `ReportPostModal` pattern for future bottom sheets (drag handle + rounded top).

