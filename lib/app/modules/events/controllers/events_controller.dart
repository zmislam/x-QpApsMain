import 'package:get/get.dart';

import '../models/event_model.dart';
import '../repository/event_repository.dart';

class EventsController extends GetxController {
  final EventRepository _repo = EventRepository();

  // ─── Tab management ──────────────────────────────────────────────────
  final tabs = const ['Top', 'Local', 'This week', 'Friends', 'Following'];
  final tabKeys = const ['top', 'local', 'this_week', 'friends', 'following'];
  final selectedTabIndex = 0.obs;
  String get _currentTabKey => tabKeys[selectedTabIndex.value];

  // ─── City filter (for Local tab) ─────────────────────────────────────
  final selectedCity = ''.obs;

  // ─── Loading & data ──────────────────────────────────────────────────
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final eventsList = <EventModel>[].obs;
  final currentPage = 1.obs;
  final hasMore = true.obs;

  // Track which tabs have been loaded
  final _tabDataLoaded = <int, bool>{}.obs;

  // ─── Section header for the current tab ──────────────────────────────
  String get sectionTitle {
    switch (_currentTabKey) {
      case 'top':
        return 'Top events for you';
      case 'local':
        return 'Events near you';
      case 'this_week':
        return 'Events happening this week';
      case 'friends':
        return 'Events from friends';
      case 'following':
        return 'Events you follow';
      default:
        return 'Events';
    }
  }

  @override
  void onInit() {
    super.onInit();
    _fetchEvents();
  }

  // ─── Tab switching ───────────────────────────────────────────────────
  void onTabChanged(int index) {
    if (index == selectedTabIndex.value) return;
    selectedTabIndex.value = index;
    // Reset and fetch for the new tab
    eventsList.clear();
    currentPage.value = 1;
    hasMore.value = true;
    _fetchEvents();
  }

  // ─── Fetch events ───────────────────────────────────────────────────
  Future<void> _fetchEvents() async {
    isLoading.value = true;
    try {
      final resp = await _repo.getEvents(
        tab: _currentTabKey,
        city: _currentTabKey == 'local' ? selectedCity.value : null,
        page: currentPage.value,
      );
      if (resp.isSuccessful) {
        final data = resp.data as Map<String, dynamic>;
        final list = (data['events'] as List?)
                ?.map((e) => EventModel.fromJson(e))
                .toList() ??
            [];
        eventsList.value = list;

        final pagination = data['pagination'] as Map<String, dynamic>?;
        if (pagination != null) {
          hasMore.value =
              pagination['page'] < (pagination['totalPages'] ?? 1);
        }
        _tabDataLoaded[selectedTabIndex.value] = true;
      }
    } catch (e) {
      print('_fetchEvents error: $e');
    }
    isLoading.value = false;
  }

  /// Load more (pagination)
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    currentPage.value += 1;
    try {
      final resp = await _repo.getEvents(
        tab: _currentTabKey,
        city: _currentTabKey == 'local' ? selectedCity.value : null,
        page: currentPage.value,
      );
      if (resp.isSuccessful) {
        final data = resp.data as Map<String, dynamic>;
        final list = (data['events'] as List?)
                ?.map((e) => EventModel.fromJson(e))
                .toList() ??
            [];
        eventsList.addAll(list);

        final pagination = data['pagination'] as Map<String, dynamic>?;
        if (pagination != null) {
          hasMore.value =
              pagination['page'] < (pagination['totalPages'] ?? 1);
        }
      }
    } catch (e) {
      print('loadMore error: $e');
    }
    isLoadingMore.value = false;
  }

  /// Pull-to-refresh
  Future<void> refreshEvents() async {
    currentPage.value = 1;
    hasMore.value = true;
    await _fetchEvents();
  }

  /// Toggle interested for an event at index
  Future<void> toggleInterested(int index) async {
    final event = eventsList[index];
    if (event.id == null) return;

    // Optimistic update
    final wasInterested = event.isInterested;
    eventsList[index] = event.copyWith(
      isInterested: !wasInterested,
      interestedCount:
          event.interestedCount + (wasInterested ? -1 : 1),
    );

    try {
      final resp = await _repo.toggleInterested(event.id!);
      if (!resp.isSuccessful) {
        // Revert on failure
        eventsList[index] = event;
      }
    } catch (e) {
      eventsList[index] = event;
      print('toggleInterested error: $e');
    }
  }

  /// Toggle going for an event at index
  Future<void> toggleGoing(int index) async {
    final event = eventsList[index];
    if (event.id == null) return;

    final wasGoing = event.isGoing;
    eventsList[index] = event.copyWith(
      isGoing: !wasGoing,
      goingCount: event.goingCount + (wasGoing ? -1 : 1),
    );

    try {
      final resp = await _repo.toggleGoing(event.id!);
      if (!resp.isSuccessful) {
        eventsList[index] = event;
      }
    } catch (e) {
      eventsList[index] = event;
      print('toggleGoing error: $e');
    }
  }

  /// Update city and re-fetch for local tab
  void updateCity(String city) {
    selectedCity.value = city;
    if (_currentTabKey == 'local') {
      eventsList.clear();
      currentPage.value = 1;
      hasMore.value = true;
      _fetchEvents();
    }
  }
}
