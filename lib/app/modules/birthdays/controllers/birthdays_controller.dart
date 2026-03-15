import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repository/birthday_repository.dart';

class BirthdaysController extends GetxController {
  final BirthdayRepository _repo = BirthdayRepository();

  // ─── State ──────────────────────────────────────────────
  RxBool isLoading = true.obs;
  RxBool isError = false.obs;

  RxList<Map<String, dynamic>> todayBirthdays = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> recentBirthdays = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> upcomingBirthdays =
      <Map<String, dynamic>>[].obs;

  /// TextEditingControllers for today birthday wish inputs (keyed by user id)
  final Map<String, TextEditingController> _wishControllers = {};

  /// Track which today-birthday users have already been wished
  RxSet<String> wishedUserIds = <String>{}.obs;

  // ─── Birthday message suggestions ───────────────────────
  static const List<String> _birthdayMessages = [
    'Happy Birthday! 🎂',
    'Have a great birthday! 🎉',
    'Wishing you a wonderful birthday! 🎈',
    'Hope your birthday is amazing! 🥳',
    'Happy Birthday! Hope it\'s a great one! 🎊',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchBirthdays();
  }

  @override
  void onClose() {
    for (final c in _wishControllers.values) {
      c.dispose();
    }
    _wishControllers.clear();
    super.onClose();
  }

  // ─── Public API ─────────────────────────────────────────

  /// Get or create a TextEditingController for a today-birthday user
  TextEditingController wishControllerFor(String userId, int index) {
    return _wishControllers.putIfAbsent(userId, () {
      final msg = _birthdayMessages[index % _birthdayMessages.length];
      return TextEditingController(text: msg);
    });
  }

  /// Fetch all birthdays from backend
  Future<void> fetchBirthdays() async {
    isLoading.value = true;
    isError.value = false;

    try {
      final response = await _repo.getBirthdays();
      if (response.isSuccessful && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as Map<String, dynamic>? ?? {};

        todayBirthdays.value =
            List<Map<String, dynamic>>.from(results['today'] ?? []);
        recentBirthdays.value =
            List<Map<String, dynamic>>.from(results['recent'] ?? []);
        upcomingBirthdays.value =
            List<Map<String, dynamic>>.from(results['upcoming'] ?? []);
      } else {
        isError.value = true;
      }
    } catch (e) {
      debugPrint('BirthdaysController.fetchBirthdays error: $e');
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Post a birthday wish to a friend's timeline
  Future<bool> postBirthdayWish(String toUserId) async {
    final controller = _wishControllers[toUserId];
    if (controller == null || controller.text.trim().isEmpty) return false;

    try {
      final response = await _repo.createBirthdayPost(
        toUserId: toUserId,
        description: controller.text.trim(),
      );
      if (response.isSuccessful) {
        wishedUserIds.add(toUserId);
        return true;
      }
    } catch (e) {
      debugPrint('BirthdaysController.postBirthdayWish error: $e');
    }
    return false;
  }

  // ─── Helpers ────────────────────────────────────────────

  String getFullName(Map<String, dynamic> user) {
    final first = user['first_name'] ?? '';
    final last = user['last_name'] ?? '';
    return '$first $last'.trim();
  }

  String getProfilePic(Map<String, dynamic> user) {
    return user['profile_pic']?.toString() ?? '';
  }

  String getUsername(Map<String, dynamic> user) {
    return user['username']?.toString() ?? '';
  }

  /// Format birthday date for display — "Today, 14 March"
  String formatBirthdayLabel(Map<String, dynamic> user) {
    final daysFromToday = user['days_from_today'] as int? ?? 0;
    final birthDay = user['birth_day'] as int? ?? 1;
    final birthMonth = user['birth_month'] as int? ?? 1;

    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final monthName = (birthMonth >= 1 && birthMonth <= 12)
        ? months[birthMonth]
        : '';

    if (daysFromToday == 0) {
      return 'Today, $birthDay $monthName';
    } else if (daysFromToday == 1) {
      return 'Tomorrow, $birthDay $monthName';
    } else if (daysFromToday == -1) {
      return 'Yesterday, $birthDay $monthName';
    } else if (daysFromToday < 0) {
      final daysAgo = user['days_ago'] as int? ?? daysFromToday.abs();
      return '${daysAgo} days ago, $birthDay $monthName';
    } else {
      return 'In $daysFromToday days, $birthDay $monthName';
    }
  }
}
