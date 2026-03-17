# Notification Section - Improvement Implementation Plan

**Date:** March 17, 2026  
**Project:** quantum_possibilities_flutter  
**Reference:** Facebook-style notification UI (provided reference screenshots)

---

## 1. Current vs Target Comparison

### Existing Issues (Image 1)
| Issue | Detail |
|-------|--------|
| Badge count not updating | `getUnseenNotificationsCount()` commented out in `onInit()` |
| Read/unread color not changing | Unseen count not refreshed → background color never updates |
| Notification tap redirect broken | Some types crash (null data), "Notification type not found" for unmapped types |
| "null null" display | Missing sender name fallback |
| No section grouping | All notifications in flat list |
| No action buttons | No Join/Delete, Confirm/Delete, Accept/Decline for actionable notifications |
| No 3-dot menu per item | No per-notification options (delete, show more/less, report) |
| No "Mark all as read" | No AppBar overflow menu |
| No "See previous notifications" | Infinite scroll only, no button |
| Pagination broken | `scrollController.addListener` added in `onReady` calling `super.onClose()` |
| No notification delete | No delete API or UI |

### Target Features (Reference Images 2–7)
| Feature | Detail |
|---------|--------|
| **AppBar** | "Notifications" title + hamburger + search + 3-dot menu |
| **Mark all as read** | From AppBar 3-dot menu (bottom sheet) |
| **New/Earlier sections** | Group by: unseen = "New", seen = "Earlier" |
| **Read/unread visual** | Unread = blue/highlighted bg, Read = white bg |
| **Action buttons** | Friend request: Confirm/Delete, Group invite: Join/Delete, Page invite: Accept/Decline |
| **3-dot menu per item** | Bottom sheet: Show more, Show less, Delete notification, Turn off, Report |
| **"See previous notifications"** | Button at bottom for explicit pagination |
| **Badge 99+** | Red badge on tab with cap at 99+ |
| **Rich sub-info** | Friend request shows "Active X ago · N mutual friends" |
| **Notification type icons** | Correct overlay icons per type (reel=red, group=blue, friend=blue+, page=orange) |

---

## 2. Existing API Endpoints (Available — No Changes)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `get-all-user-specific-notifications/:userId?skip=&limit=` | Paginated notifications |
| GET | `get-unseen-notification-count/:userId` | Unseen count (badge) |
| POST | `update-notification-seen-status/:notificationId` | Mark single as read (also accepts `{status: "accept"|"decline"}` for friend_request/group_invitation) |
| GET | `seen-all-user-specific-notifications/:userId` | **Mark ALL as read** |
| POST | `turn-off-notification-post` | Ignore notifications for a post |
| POST | `friend-accept-friend-request` | Accept/reject friend request (`{request_id, accept_reject_ind: 0|1}`) |
| POST | `invitation-join-request-accept-decline` | Accept/decline group invitation |
| POST | `accept-invitation` | Accept page invitation |
| POST | `declined-invitation` | Decline page invitation |

---

## 3. New API Endpoint Needed

### DELETE /delete-notification/:notificationId
**Purpose:** Delete a single notification from user's list  
**File:** `qp-api/controller/Notification/NotificationController.js` + `qp-api/routes/route.js`

---

## 4. Implementation Tasks

### Phase 1: Bug Fixes (Critical)

#### Task 1.1 — Fix badge count not updating
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/controllers/notification_controller.dart`
- **Change:** Uncomment `getUnseenNotificationsCount()` in `onInit()`
- **Change:** Fix `onReady()` calling `super.onClose()` → should call `super.onReady()`

#### Task 1.2 — Fix read/unread background color
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/components/notification_item.dart`
- **Status:** Logic already exists but depends on `notification_seen` + unseen count refresh
- **Change:** Will work once Task 1.1 is fixed; verify color distinction is visible enough

#### Task 1.3 — Fix "null null" and "Notification type not found"
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/components/notification_item.dart`
- **Change:** Add null-safe fallback for sender name: show "Someone" or empty instead of "null null"
- **Change:** Default notification text to use `model.message` instead of "Notification type not found"

#### Task 1.4 — Fix pagination / scroll listener
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/controllers/notification_controller.dart`
- **Change:** Fix `onReady` → `super.onReady()` (currently calls `super.onClose()`)
- **Change:** Remove broken `skip.value != limit` check in `_scrollListener`

#### Task 1.5 — Fix notification tap routing
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/controllers/notification_controller.dart`
- **Change:** Add null-safety checks before accessing `notification_data`, `postId`, `reelId`
- **Change:** Add missing types: `post_tags`, `page_post`, `pages`, `group_post`, `accept_invitation`
- **Change:** `UNKNOWN` type should show message or do nothing (not crash)

---

### Phase 2: UI Redesign

#### Task 2.1 — Add "Notifications" AppBar with 3-dot menu
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/views/notification_view.dart`
- **Change:** Add AppBar with title "Notifications", search icon, 3-dot PopupMenuButton/bottom sheet
- **Action:** "Mark all as read" calls `seen-all-user-specific-notifications/:userId` API

#### Task 2.2 — Add "New" / "Earlier" section headers
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/views/notification_view.dart`
- **Change:** Split `notificationList` into two groups: `notification_seen == false` → "New", `notification_seen == true` → "Earlier"
- **Change:** Show section headers only when items exist in that section

#### Task 2.3 — Add "See previous notifications" button
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/views/notification_view.dart`
- **Change:** Add a button at the bottom of the list that loads more notifications
- **Change:** Replace infinite scroll with this explicit button approach (matching reference)

#### Task 2.4 — Add 3-dot menu per notification item
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/components/notification_item.dart`
- **Change:** Add `...` (more options) icon on the right side of each notification
- **Change:** On tap → show bottom sheet with options based on notification type

#### Task 2.5 — Notification options bottom sheet
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/components/notification_options_bottom_sheet.dart` (NEW)
- **Options for group_invitation/page_invitation:**
  - Show more (future: adjust notification frequency)
  - Show less (future: adjust notification frequency)
  - Delete this notification
  - Turn off invitation notifications from this sender
  - Report issue to notifications team
- **Options for friend_request:**
  - Delete this notification
  - Report [sender name]
  - Report issue to notifications team
- **Default options:**
  - Delete this notification
  - Turn off notifications for this post (`turn-off-notification-post` API)
  - Report issue to notifications team

#### Task 2.6 — Add action buttons for actionable notifications
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/components/notification_item.dart`
- **friend_request:** Show "Confirm" (blue) + "Delete" (grey) buttons
  - Confirm → `POST friend-accept-friend-request` with `accept_reject_ind: 1`
  - Delete → `POST friend-accept-friend-request` with `accept_reject_ind: 0`
- **group_invitation / group_joining:** Show "Join" (blue) + "Delete" (grey) buttons
  - Join → `POST invitation-join-request-accept-decline` with accept
  - Delete → `POST invitation-join-request-accept-decline` with decline
- **page_invitation:** Show "Accept" (blue) + "Decline" (grey) buttons
  - Accept → `POST accept-invitation`
  - Decline → `POST declined-invitation`
- After action: update local notification status, gray out or remove buttons

---

### Phase 3: New API + Controller Updates

#### Task 3.1 — Create delete notification API endpoint
**File:** `qp-api/controller/Notification/NotificationController.js`
```javascript
const deleteNotification = async (req, res) => {
   try {
      const notification = await Notification.findOneAndDelete({
         _id: req.params.notificationId,
         notification_receiver_id: req.userId,
      });
      if (!notification) {
         return res.status(404).json({ status: 404, error: "Notification not found" });
      }
      return res.json({ status: 200, message: "Notification deleted successfully" });
   } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Internal Server Error" });
   }
};
```
**File:** `qp-api/routes/route.js` — Add route: `router.delete('/delete-notification/:notificationId', auth, deleteNotification)`

#### Task 3.2 — Add Flutter repository methods
**File:** `lib/app/repository/notification_repository.dart`
- Add `markAllAsRead(userId)` → GET `seen-all-user-specific-notifications/:userId`
- Add `deleteNotification(notificationId)` → DELETE `delete-notification/:notificationId`

#### Task 3.3 — Add controller methods
**File:** `lib/app/modules/NAVIGATION_MENUS/notification/controllers/notification_controller.dart`
- Add `markAllAsRead()` — calls API, updates all local items to `notification_seen: true`, resets badge
- Add `deleteNotification(notificationId)` — calls API, removes from local list, updates badge
- Add `acceptFriendRequest(notificationModel)` — calls friend-accept API
- Add `declineFriendRequest(notificationModel)` — calls friend-accept API with reject
- Add `acceptGroupInvitation(notificationModel)` — calls group invitation API
- Add `declineGroupInvitation(notificationModel)` — calls group invitation API
- Add `acceptPageInvitation(notificationModel)` — calls accept-invitation API
- Add `declinePageInvitation(notificationModel)` — calls declined-invitation API

---

## 5. Files Changed Summary

### API (qp-api)
| File | Action |
|------|--------|
| `controller/Notification/NotificationController.js` | Add `deleteNotification` function |
| `routes/route.js` | Add DELETE route for notification |

### Flutter (quantum_possibilities_flutter)
| File | Action |
|------|--------|
| `lib/app/modules/NAVIGATION_MENUS/notification/controllers/notification_controller.dart` | Fix bugs + add new methods |
| `lib/app/modules/NAVIGATION_MENUS/notification/views/notification_view.dart` | Full UI redesign |
| `lib/app/modules/NAVIGATION_MENUS/notification/components/notification_item.dart` | Add action buttons + 3-dot menu + fix null handling |
| `lib/app/modules/NAVIGATION_MENUS/notification/components/notification_options_bottom_sheet.dart` | **NEW** — Bottom sheet options |
| `lib/app/repository/notification_repository.dart` | Add markAllAsRead + deleteNotification |
| `lib/app/enum/notification_type_enum.dart` | Add missing types (post_tags, page_post, group_post, etc.) |
| `lib/app/models/notification.dart` | No changes needed |

---

## 6. Testing Checklist

- [ ] Badge count shows correctly and updates in real-time
- [ ] Unread notifications have highlighted background
- [ ] Read notifications have default/white background
- [ ] Tapping notification marks it as read (color changes)
- [ ] "New" section shows only unread notifications
- [ ] "Earlier" section shows only read notifications
- [ ] "Mark all as read" marks all as read and resets badge
- [ ] "See previous notifications" loads more items
- [ ] Friend request → Confirm/Delete buttons work
- [ ] Group invitation → Join/Delete buttons work
- [ ] Page invitation → Accept/Decline buttons work
- [ ] 3-dot menu shows correct options per notification type
- [ ] Delete notification removes it from list
- [ ] All notification tap redirects work correctly
- [ ] No "null null" displayed for unknown senders
- [ ] No "Notification type not found" for unknown types (uses message field)
- [ ] Pull-to-refresh works correctly
- [ ] No crashes on any notification type

---

## 7. Implementation Status — COMPLETED

### All Changes Made (March 17, 2026)

#### API (qp-api) — 2 files changed
| File | Change |
|------|--------|
| `controller/Notification/NotificationController.js` | Added `deleteNotification` function — deletes notification by ID with receiver ownership check |
| `routes/route.js` | Added `DELETE /delete-notification/:notificationId` route with auth middleware; imported `deleteNotification` |

#### Flutter (quantum_possibilities_flutter) — 6 files changed

| File | Change |
|------|--------|
| `lib/app/enum/notification_type_enum.dart` | Added 9 new types: `ACCEPT_INVITATION`, `GROUP_POST`, `PAGE_POST`, `PAGES`, `POST_TAGS`, `MONETIZATION`, `REPORT_ACTION`, `CHECK_IN`, `PAGE_LIKE`, `MENTION`. Added `hasActionButtons` getter |
| `lib/app/repository/notification_repository.dart` | Added: `markAllAsRead()`, `deleteNotification()`, `turnOffPostNotification()`, `respondToFriendRequest()`, `respondToGroupInvitation()`, `acceptPageInvitation()`, `declinePageInvitation()`. Fixed `enableLoading: false` on unseen count. Added optional `status` param to `updateNotificationSeenStatus()` |
| `lib/app/modules/.../controllers/notification_controller.dart` | **Bugs fixed:** Uncommented `getUnseenNotificationsCount()` in `onInit()`, fixed `onReady` calling `super.onClose()` → `super.onReady()`, fixed scroll listener threshold, added `scrollController.dispose()`, fixed pagination hasMoreData logic. **New methods:** `markAllAsRead()`, `deleteNotification()`, `acceptFriendRequest()`, `declineFriendRequest()`, `acceptGroupInvitation()`, `declineGroupInvitation()`, `acceptPageInvitation()`, `declinePageInvitation()`, `loadMore()`. **New getters:** `newNotifications`, `earlierNotifications`. **Routing fixes:** Null-safety for all navigation, added POST_TAGS/ACCEPT_INVITATION/PAGE_POST/PAGES/GROUP_POST/CHECK_IN/MENTION/PAGE_LIKE/MONETIZATION/REPORT_ACTION handling |
| `lib/app/modules/.../views/notification_view.dart` | **Full redesign:** Added AppBar with "Notifications" title + 3-dot menu (Mark all as read) + search icon. Split list into "New" / "Earlier" sections with headers. Added "See previous notifications" button at bottom. Improved empty state with icon. Removed 100+ lines of dead commented code |
| `lib/app/modules/.../components/notification_item.dart` | **Major update:** Added 3-dot menu (`...`) per notification item. Added inline action buttons (Confirm/Delete for friend requests, Join/Delete for group invites, Accept/Decline for page invites). Fixed "null null" sender name → safe fallback. Fixed "Notification type not found" → uses `model.message` fallback. Added unread timestamp color (primary color). Added status text for already-actioned notifications. Updated notification text for group_invitation to show `model.message` content |
| `lib/app/modules/.../components/notification_options_bottom_sheet.dart` | **NEW FILE:** Bottom sheet with notification preview header + context-sensitive options (Show more/less, Delete notification, Turn off sender, Report user, Turn off post notifications, Report issue) |

### Bug Fixes Summary
1. ✅ **Badge count not updating** — `getUnseenNotificationsCount()` was commented out in `onInit()`, now enabled
2. ✅ **Read/unread color not changing** — Fixed: unseen count now refreshes, background color uses `primary.withAlpha(0.06)` for unread vs `surface` for read
3. ✅ **`onReady` calling `super.onClose()`** — Fixed to `super.onReady()`
4. ✅ **Scroll listener broken** — Fixed threshold to `maxScrollExtent - 200` and removed broken `skip.value != limit` check
5. ✅ **"null null" display** — Safe fallback: empty string for null/missing sender names
6. ✅ **"Notification type not found"** — Uses `model.message` as fallback text
7. ✅ **Notification tap crashes** — Null-safety guards on `postId`, `reelId`, `username` before navigation
8. ✅ **Missing notification types** — Added handling for `post_tags`, `page_post`, `pages`, `group_post`, `accept_invitation`, `check_in`, `page_like`, `mention`, `monetization`, `report_action`
9. ✅ **ScrollController not disposed** — Added `scrollController.dispose()` in `onClose()`
10. ✅ **enableLoading:true on badge count API** — Changed to `false` to avoid UI blocking
