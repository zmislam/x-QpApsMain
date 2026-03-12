# Technical Specification: Mobile Newsfeed Redevelopment

| Item | Details |
| :--- | :--- |
| **Project** | Mobile Newsfeed Redevelopment ("For You" Tab) |
| **Platform** | Flutter (Mobile) |
| **Backend** | Node.js / Express (EdgeRank API) |
| **Design Pattern** | Facebook-Inspired Mobile UI |
| **Primary Goal** | Migrate to EdgeRank-driven feed and modernize the visual identity. |

---

## 1. Executive Summary
The goal of this redevelopment is to replace the current legacy newsfeed system in `quantum_possibilities_flutter` with a high-performance, algorithmically driven feed utilizing the **EdgeRank API**. Key improvements include a transition to **cursor-based pagination**, a complete **UI overhaul** inspired by modern Facebook layouts, and the introduction of **dynamic feed insertions** (ads and suggestions).

---

## 2. Architecture Overview

### 2.1 Backend Integration (EdgeRank)
The new feed architecture shifts from simple page-based fetching to a sophisticated ranking system.
- **API Endpoint:** `GET /api/edgerank/feed`
- **Pagination:** Cursor-based (Base64 string) replaces traditional `pageNo`.
- **Ranking:** Deterministic ranking per session via `session_seed`.
- **Content Types:** Interleaved list of `posts` and `insertions`.

### 2.2 Data Management (Flutter/GetX)
- **Repository Pattern:** A new `EdgeRankRepository` handles low-level HTTP communication.
- **Controller Mixin:** `EdgeRankFeedMixin` encapsulates feed state (posts, cursors, loading states) to keep `HomeController` lean.
- **Insertion Tracking:** Insertions are tracked by their relative position or anchored post IDs to ensure stable rendering during infinite scroll.

---

## 3. Design System & UI/UX

### 3.1 Design Language
The design follows the "Facebook Mobile" pattern, prioritizing whitespace, content readability, and standard interaction patterns.
- **Typography:** 15px primary text, 13px metadata.
- **Card Layout:** Full-width mobile cards with thin separators (1px) and 10px spacing blocks.
- **Dark Mode:** Full compatibility with tokens for standard FB dark colors (`#242526` backgrounds).

### 3.2 Post Card Components
| Component | Key Redesign Specifications |
| :--- | :--- |
| **Header** | 40px avatar, semi-bold name (15px), metadata row with dot separator + privacy icon. |
| **Body** | Dynamic media rendering (single/multi-image/video). |
| **Footer** | Count row (Reactions on left, Comment/Share counts on right). Equal-width action buttons. |

### 3.3 Comment System
- **Modal Transition:** Comments move from an inline bottom sheet to a **full-screen modal** context.
- **Interactions:** Support for "Most Relevant" sorting and threaded replies with indented avatars.

---

## 4. Implementation Phasing

### Phase A: Foundation & API [✓ COMPLETED]
- [x] Implement `EdgeRankRepository` and `EdgeRankFeedMixin`.
- [x] Migrate `HomeController` to use the new cursor-pagination logic.
- [x] Parse and display `whyShown` context for suggested content (via `PostModel` update).
- [x] Update `HomeView` to render the new feed.

### Phase B: Post Card & UI Rewrite [✓ COMPLETED]
- [x] Refactor the `PostCard` widget and its sub-children.
- [x] Implement the `PostCommentModal`.

### Phase C: Dynamic Insertions [✓ COMPLETED]
- [x] Build `SponsoredPostCard` and `FriendSuggestionCard`.
- [x] Implement dismiss logic.

### Phase D: Modals & Post Actions [✓ COMPLETED]
- [x] `ReportPostModal` & `ShareSheet`.

### Phase E: Stories & Polish [✓ COMPLETED]
- [x] Redesign `StoryTray` & `PostCreatorBar`.

### Phase F: Performance Optimization [✓ COMPLETED]
- [x] Concurrent Refresh & Image Caching.

### Phase G: Optimistic Updates [✓ COMPLETED]
- [x] Instant Likes, Comments, & Replies.

### Phase H: Advanced Optimization [✓ COMPLETED]
- [x] Memory & Render Performance.

---

## 5. Technical Documentation
For detailed architecture, component breakdown, and logic explanations, please refer to:
**[NEWSFEED_TECHNICAL_DOC.md](./NEWSFEED_TECHNICAL_DOC.md)**

---

## 5. Risk & Mitigations
- **API Availability:** If the EdgeRank API is not yet live, a mock adapter will be used during UI development to prevent blocking.
- **Regression:** A full backup of the legacy home module has been created at `_backup_newsfeed/` to allow for immediate rollback if critical issues arise.

---

## 6. Verification Plan
- **Performance:** Evaluate smooth scrolling and memory usage during infinite scroll.
- **UI Fidelity:** Verify avatar sizes, font weights, and color tokens against the Facebook design pattern.
- **Functionality:** Test all engagement actions (reactions, comments, sharing) against the new feed items.
