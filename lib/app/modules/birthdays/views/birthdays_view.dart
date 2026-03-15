import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/image.dart';
import '../../../config/constants/feed_design_tokens.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/profile_navigator.dart';
import '../controllers/birthdays_controller.dart';

/// Facebook-style Birthdays page with Today / Recent / Upcoming sections.
class BirthdaysView extends GetView<BirthdaysController> {
  const BirthdaysView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FeedDesignTokens.surfaceBg(context),
      appBar: AppBar(
        backgroundColor: FeedDesignTokens.cardBg(context),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: FeedDesignTokens.textPrimary(context)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Birthdays',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: FeedDesignTokens.textPrimary(context),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded,
                size: 26, color: FeedDesignTokens.textPrimary(context)),
            onPressed: () => Get.toNamed(Routes.ADVANCE_SEARCH),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.isError.value) {
          return _buildError(context);
        }
        if (_isEmpty) {
          return _buildEmpty(context);
        }
        return RefreshIndicator(
          onRefresh: controller.fetchBirthdays,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              // ─── Today Section ────────────────────────
              if (controller.todayBirthdays.isNotEmpty) ...[
                _SectionHeader(
                  title: 'Today\'s Birthdays',
                  count: controller.todayBirthdays.length,
                ),
                ...List.generate(controller.todayBirthdays.length, (i) {
                  final user = controller.todayBirthdays[i];
                  return _TodayBirthdayCard(user: user, index: i);
                }),
              ],

              // ─── Recent Section ───────────────────────
              if (controller.recentBirthdays.isNotEmpty) ...[
                _SectionHeader(
                  title: 'Recent Birthdays',
                  count: controller.recentBirthdays.length,
                ),
                ...controller.recentBirthdays.map((user) {
                  return _RecentBirthdayCard(user: user);
                }),
              ],

              // ─── Upcoming Section ─────────────────────
              if (controller.upcomingBirthdays.isNotEmpty) ...[
                _SectionHeader(
                  title: 'Upcoming Birthdays',
                  count: controller.upcomingBirthdays.length,
                ),
                ...controller.upcomingBirthdays.map((user) {
                  return _UpcomingBirthdayCard(user: user);
                }),
              ],
            ],
          ),
        );
      }),
    );
  }

  bool get _isEmpty =>
      controller.todayBirthdays.isEmpty &&
      controller.recentBirthdays.isEmpty &&
      controller.upcomingBirthdays.isEmpty;

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48,
              color: FeedDesignTokens.textSecondary(context)),
          const SizedBox(height: 12),
          Text('Something went wrong',
              style: TextStyle(
                  fontSize: 16,
                  color: FeedDesignTokens.textSecondary(context))),
          const SizedBox(height: 16),
          TextButton(
            onPressed: controller.fetchBirthdays,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cake_outlined, size: 64,
              color: FeedDesignTokens.textSecondary(context)),
          const SizedBox(height: 16),
          Text('No upcoming birthdays',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: FeedDesignTokens.textPrimary(context))),
          const SizedBox(height: 8),
          Text(
            'When your friends have birthdays,\nthey\'ll show up here.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: FeedDesignTokens.textSecondary(context)),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Section Header
// =============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        '$title ($count)',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: FeedDesignTokens.textPrimary(context),
        ),
      ),
    );
  }
}

// =============================================================================
// TODAY Birthday Card — avatar, name, date, wish input, Post + Messenger btns
// =============================================================================

class _TodayBirthdayCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final int index;
  const _TodayBirthdayCard({required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BirthdaysController>();
    final userId = user['_id']?.toString() ?? '';
    final name = controller.getFullName(user);
    final pic = controller.getProfilePic(user);
    final dateLabel = controller.formatBirthdayLabel(user);
    final wishCtrl = controller.wishControllerFor(userId, index);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FeedDesignTokens.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FeedDesignTokens.cardBorder(context), width: 0.5),
      ),
      child: Obx(() {
        final alreadyWished = controller.wishedUserIds.contains(userId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Avatar + Name Row ──────────────────────
            GestureDetector(
              onTap: () => _navigateToProfile(user),
              child: Row(
                children: [
                  NetworkCircleAvatar(
                    imageUrl: pic,
                    radius: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: FeedDesignTokens.textPrimary(context),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateLabel,
                          style: TextStyle(
                            fontSize: 13,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Birthday cake icon
                  Text('🎂', style: TextStyle(fontSize: 28)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            if (alreadyWished) ...[
              // ─── Already wished state ─────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: FeedDesignTokens.inputBg(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 18, color: const Color(0xFF1EBEA5)),
                    const SizedBox(width: 8),
                    Text(
                      'Birthday wish posted!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // ─── Wish Input ───────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: FeedDesignTokens.inputBg(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: wishCtrl,
                  style: TextStyle(
                    fontSize: 14,
                    color: FeedDesignTokens.textPrimary(context),
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    border: InputBorder.none,
                    hintText: 'Write a birthday wish...',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                  maxLines: 1,
                ),
              ),

              const SizedBox(height: 10),

              // ─── Post + Messenger Buttons ─────────────
              Row(
                children: [
                  // Post button (primary)
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          final success =
                              await controller.postBirthdayWish(userId);
                          if (success) {
                            Get.snackbar(
                              'Done',
                              'Birthday wish posted! 🎉',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(0xFF1EBEA5),
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              'Could not post birthday wish',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF307777),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Post',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Messenger button
                  SizedBox(
                    width: 42,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.snackbar(
                          'Messenger',
                          'Almost Ready!',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: BorderSide(
                            color: FeedDesignTokens.cardBorder(context)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        size: 18,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      }),
    );
  }
}

// =============================================================================
// RECENT Birthday Card — avatar, name, relative date, Message button
// =============================================================================

class _RecentBirthdayCard extends StatelessWidget {
  final Map<String, dynamic> user;
  const _RecentBirthdayCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BirthdaysController>();
    final name = controller.getFullName(user);
    final pic = controller.getProfilePic(user);
    final dateLabel = controller.formatBirthdayLabel(user);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FeedDesignTokens.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FeedDesignTokens.cardBorder(context), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Avatar + Name Row ──────────────────────────
          GestureDetector(
            onTap: () => _navigateToProfile(user),
            child: Row(
              children: [
                NetworkCircleAvatar(
                  imageUrl: pic,
                  radius: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: FeedDesignTokens.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateLabel,
                        style: TextStyle(
                          fontSize: 13,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ─── Message Button (full-width) ────────────────
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton.icon(
              onPressed: () {
                Get.snackbar(
                  'Messenger',
                  'Almost Ready!',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
              icon: Icon(Icons.send_rounded, size: 16,
                  color: FeedDesignTokens.textPrimary(context)),
              label: Text(
                'Send Message',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: FeedDesignTokens.textPrimary(context),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: FeedDesignTokens.cardBorder(context)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// UPCOMING Birthday Card — avatar, name, date, Messenger icon on right
// =============================================================================

class _UpcomingBirthdayCard extends StatelessWidget {
  final Map<String, dynamic> user;
  const _UpcomingBirthdayCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BirthdaysController>();
    final name = controller.getFullName(user);
    final pic = controller.getProfilePic(user);
    final dateLabel = controller.formatBirthdayLabel(user);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: FeedDesignTokens.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FeedDesignTokens.cardBorder(context), width: 0.5),
      ),
      child: GestureDetector(
        onTap: () => _navigateToProfile(user),
        child: Row(
          children: [
            NetworkCircleAvatar(
              imageUrl: pic,
              radius: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateLabel,
                    style: TextStyle(
                      fontSize: 13,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            // Messenger icon button on the right
            IconButton(
              onPressed: () {
                Get.snackbar(
                  'Messenger',
                  'Almost Ready!',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
              icon: Icon(
                Icons.send_rounded,
                size: 20,
                color: FeedDesignTokens.textSecondary(context),
              ),
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Helpers
// =============================================================================

void _navigateToProfile(Map<String, dynamic> user) {
  final username = user['username']?.toString() ?? '';
  if (username.isNotEmpty) {
    ProfileNavigator.navigateToProfile(username: username);
  }
}
