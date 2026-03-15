// =============================================================================
// Advance Search Controller — GetX controller for the V2 search module
// =============================================================================
// Manages:
//   - Debounced search execution (300ms)
//   - Tab state (All, People, Reels, Groups, Pages, Events, Marketplace)
//   - Per-tab cursor-based pagination
//   - Suggestions overlay (type-ahead, history, trending)
//   - User actions (friend request, follow page, join group)
//
// Created: 2026-03-14
// =============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../routes/profile_navigator.dart';
import '../models/search_result_models.dart';
import '../models/search_suggestion_model.dart';
import '../repository/advance_search_repository.dart';

// ─── Search tab enum ────────────────────────────────────────────────────────

enum SearchTab {
  all,
  people,
  reels,
  groups,
  pages,
  events,
  marketplace;

  String get label {
    switch (this) {
      case SearchTab.all:
        return 'All';
      case SearchTab.people:
        return 'People';
      case SearchTab.reels:
        return 'Reels';
      case SearchTab.groups:
        return 'Groups';
      case SearchTab.pages:
        return 'Pages';
      case SearchTab.events:
        return 'Events';
      case SearchTab.marketplace:
        return 'Marketplace';
    }
  }
}

class AdvanceSearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AdvanceSearchRepository _repo = AdvanceSearchRepository();

  // ─── Tab ─────────────────────────────────────────────────────────────────

  late TabController tabController;

  static const List<SearchTab> tabs = SearchTab.values;

  static String tabLabel(SearchTab tab) {
    switch (tab) {
      case SearchTab.all:
        return 'All';
      case SearchTab.people:
        return 'People';
      case SearchTab.reels:
        return 'Reels';
      case SearchTab.groups:
        return 'Groups';
      case SearchTab.pages:
        return 'Pages';
      case SearchTab.events:
        return 'Events';
      case SearchTab.marketplace:
        return 'Marketplace';
    }
  }

  static String _apiType(SearchTab tab) {
    switch (tab) {
      case SearchTab.all:
        return 'all';
      case SearchTab.people:
        return 'people';
      case SearchTab.reels:
        return 'reels';
      case SearchTab.groups:
        return 'groups';
      case SearchTab.pages:
        return 'pages';
      case SearchTab.events:
        return 'all'; // no separate events API; placeholder
      case SearchTab.marketplace:
        return 'marketplace';
    }
  }

  // ─── Search state ────────────────────────────────────────────────────────

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final RxString query = ''.obs;
  final RxBool hasSearched = false.obs;

  // Per-tab results
  final Rx<UnifiedSearchResult> unifiedResult =
      UnifiedSearchResult.empty().obs;

  // Per-tab paginated results (for tab-specific infinite scroll)
  final RxMap<SearchTab, List<dynamic>> tabResults = <SearchTab, List<dynamic>>{
    for (final t in SearchTab.values) t: <dynamic>[],
  }.obs;

  final RxMap<SearchTab, bool> tabLoading = <SearchTab, bool>{
    for (final t in SearchTab.values) t: false,
  }.obs;

  final RxMap<SearchTab, bool> tabLoadingMore = <SearchTab, bool>{
    for (final t in SearchTab.values) t: false,
  }.obs;

  final RxMap<SearchTab, bool> tabExhausted = <SearchTab, bool>{
    for (final t in SearchTab.values) t: false,
  }.obs;

  final RxMap<SearchTab, String?> tabCursors = <SearchTab, String?>{
    for (final t in SearchTab.values) t: null,
  }.obs;

  // ─── Suggestions / History / Trending ────────────────────────────────────

  final RxBool showSuggestions = false.obs;
  final RxList<SearchSuggestion> suggestions = <SearchSuggestion>[].obs;
  final RxList<SearchHistoryItem> recentSearches = <SearchHistoryItem>[].obs;
  final RxList<TrendingSearch> trendingSearches = <TrendingSearch>[].obs;
  final RxBool loadingSuggestions = false.obs;

  // ─── Scroll controllers per tab ─────────────────────────────────────────

  final Map<SearchTab, ScrollController> scrollControllers = {
    for (final t in SearchTab.values) t: ScrollController(),
  };

  // ─── Debounce timer ──────────────────────────────────────────────────────

  Timer? _debounce;
  static const _debounceDuration = Duration(milliseconds: 300);

  // ─── Lifecycle ───────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(_onTabChanged);

    // Listen to search input for debounced suggestions
    searchController.addListener(_onSearchTextChanged);

    // Listen to focus for showing suggestions overlay
    searchFocusNode.addListener(_onFocusChanged);

    // Setup scroll listeners for pagination
    for (final tab in SearchTab.values) {
      scrollControllers[tab]!.addListener(() => _onScroll(tab));
    }

    // Load initial data
    _loadInitialData();

    // Auto-focus search field after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    for (final sc in scrollControllers.values) {
      sc.dispose();
    }
    super.onClose();
  }

  // ─── Initial data ───────────────────────────────────────────────────────

  Future<void> _loadInitialData() async {
    // Load recent searches and trending in parallel
    final results = await Future.wait([
      _repo.getSearchHistory(limit: 20),
      _repo.getTrendingSearches(limit: 10),
    ]);
    recentSearches.value = results[0] as List<SearchHistoryItem>;
    trendingSearches.value = results[1] as List<TrendingSearch>;
  }

  // ─── Text change handler (debounced suggestions) ────────────────────────

  void _onSearchTextChanged() {
    final text = searchController.text.trim();
    query.value = text;

    _debounce?.cancel();

    if (text.isEmpty) {
      suggestions.clear();
      // Show history/trending when empty
      showSuggestions.value = searchFocusNode.hasFocus;
      return;
    }

    loadingSuggestions.value = true;
    showSuggestions.value = true;

    _debounce = Timer(_debounceDuration, () async {
      final results = await _repo.getSearchSuggestions(query: text);
      suggestions.value = results;
      loadingSuggestions.value = false;
    });
  }

  // ─── Focus handler ─────────────────────────────────────────────────────

  void _onFocusChanged() {
    if (searchFocusNode.hasFocus) {
      showSuggestions.value = true;
    }
  }

  void dismissSuggestions() {
    showSuggestions.value = false;
    searchFocusNode.unfocus();
  }

  // ─── Execute search ─────────────────────────────────────────────────────

  /// Called when user presses Enter or taps a suggestion.
  Future<void> executeSearch([String? searchQuery]) async {
    final q = searchQuery ?? searchController.text.trim();
    if (q.isEmpty) return;

    // Update search bar text if triggered from suggestion
    if (searchQuery != null && searchController.text != searchQuery) {
      searchController.text = searchQuery;
      searchController.selection =
          TextSelection.collapsed(offset: searchQuery.length);
    }

    query.value = q;
    showSuggestions.value = false;
    searchFocusNode.unfocus();
    hasSearched.value = true;

    // Save to history
    _repo.addSearchHistory(query: q);

    // Reset all tabs
    _resetAllTabs();

    // Execute based on current tab
    final currentTab = tabs[tabController.index];
    if (currentTab == SearchTab.all) {
      await _executeUnifiedSearch(q);
    } else {
      await _executeTabSearch(currentTab, q);
    }
  }

  void _resetAllTabs() {
    for (final tab in SearchTab.values) {
      tabResults[tab] = [];
      tabLoading[tab] = false;
      tabLoadingMore[tab] = false;
      tabExhausted[tab] = false;
      tabCursors[tab] = null;
    }
  }

  Future<void> _executeUnifiedSearch(String q) async {
    tabLoading[SearchTab.all] = true;
    tabResults.refresh();

    final result = await _repo.unifiedSearch(query: q);
    unifiedResult.value = result;

    // Also populate individual tab results from unified
    tabResults[SearchTab.people] = result.people.items.toList();
    tabCursors[SearchTab.people] = result.people.nextCursor;
    tabExhausted[SearchTab.people] = !result.people.hasMore;

    tabResults[SearchTab.reels] = result.reels.items.toList();
    tabCursors[SearchTab.reels] = result.reels.nextCursor;
    tabExhausted[SearchTab.reels] = !result.reels.hasMore;

    tabResults[SearchTab.pages] = result.pages.items.toList();
    tabCursors[SearchTab.pages] = result.pages.nextCursor;
    tabExhausted[SearchTab.pages] = !result.pages.hasMore;

    tabResults[SearchTab.groups] = result.groups.items.toList();
    tabCursors[SearchTab.groups] = result.groups.nextCursor;
    tabExhausted[SearchTab.groups] = !result.groups.hasMore;

    tabResults[SearchTab.marketplace] = result.marketplace.items.toList();
    tabCursors[SearchTab.marketplace] = result.marketplace.nextCursor;
    tabExhausted[SearchTab.marketplace] = !result.marketplace.hasMore;

    tabLoading[SearchTab.all] = false;
    tabResults.refresh();
  }

  Future<void> _executeTabSearch(SearchTab tab, String q) async {
    if (tab == SearchTab.events) return; // no API yet

    tabLoading[tab] = true;
    tabResults.refresh();

    switch (tab) {
      case SearchTab.people:
        final page = await _repo.searchCategory(
          category: 'people',
          query: q,
          fromJson: SearchPersonResult.fromJson,
        );
        tabResults[tab] = page.items;
        tabCursors[tab] = page.nextCursor;
        tabExhausted[tab] = !page.hasMore;
        break;
      case SearchTab.reels:
        final page = await _repo.searchCategory(
          category: 'reels',
          query: q,
          fromJson: SearchReelResult.fromJson,
        );
        tabResults[tab] = page.items;
        tabCursors[tab] = page.nextCursor;
        tabExhausted[tab] = !page.hasMore;
        break;
      case SearchTab.groups:
        final page = await _repo.searchCategory(
          category: 'groups',
          query: q,
          fromJson: SearchGroupResult.fromJson,
        );
        tabResults[tab] = page.items;
        tabCursors[tab] = page.nextCursor;
        tabExhausted[tab] = !page.hasMore;
        break;
      case SearchTab.pages:
        final page = await _repo.searchCategory(
          category: 'pages',
          query: q,
          fromJson: SearchPageResult.fromJson,
        );
        tabResults[tab] = page.items;
        tabCursors[tab] = page.nextCursor;
        tabExhausted[tab] = !page.hasMore;
        break;
      case SearchTab.marketplace:
        final page = await _repo.searchCategory(
          category: 'marketplace',
          query: q,
          fromJson: SearchMarketplaceResult.fromJson,
        );
        tabResults[tab] = page.items;
        tabCursors[tab] = page.nextCursor;
        tabExhausted[tab] = !page.hasMore;
        break;
      default:
        break;
    }

    tabLoading[tab] = false;
    tabResults.refresh();
  }

  // ─── Tab changed ────────────────────────────────────────────────────────

  void _onTabChanged() {
    if (!tabController.indexIsChanging) return;
    final tab = tabs[tabController.index];

    // Only fetch if query exists and tab hasn't been loaded yet
    if (query.value.isNotEmpty && tabResults[tab]!.isEmpty && !(tabLoading[tab] ?? false)) {
      if (tab == SearchTab.all) {
        _executeUnifiedSearch(query.value);
      } else {
        _executeTabSearch(tab, query.value);
      }
    }
  }

  // ─── Pagination (infinite scroll) ───────────────────────────────────────

  void _onScroll(SearchTab tab) {
    final sc = scrollControllers[tab]!;
    if (!sc.hasClients) return;
    if (sc.position.pixels >= sc.position.maxScrollExtent - 300) {
      _loadMore(tab);
    }
  }

  Future<void> _loadMore(SearchTab tab) async {
    if (tab == SearchTab.all || tab == SearchTab.events) return;
    if (tabLoadingMore[tab] == true) return;
    if (tabExhausted[tab] == true) return;
    if (query.value.isEmpty) return;

    final cursor = tabCursors[tab];
    if (cursor == null || cursor.isEmpty) return;

    tabLoadingMore[tab] = true;
    tabResults.refresh();

    switch (tab) {
      case SearchTab.people:
        final page = await _repo.searchCategory(
          category: 'people',
          query: query.value,
          fromJson: SearchPersonResult.fromJson,
          cursor: cursor,
        );
        tabResults[tab] = [...tabResults[tab]!, ...page.items];
        tabCursors[tab] = page.nextCursor;
        tabExhausted[tab] = !page.hasMore;
        break;
      case SearchTab.reels:
        final page = await _repo.searchCategory(
          category: 'reels',
          query: query.value,
          fromJson: SearchReelResult.fromJson,
          cursor: cursor,
        );
        tabResults[tab] = [...tabResults[tab]!, ...page.items];
        tabCursors[tab] = page.nextCursor;
        tabExhausted[tab] = !page.hasMore;
        break;
      case SearchTab.groups:
        final page = await _repo.searchCategory(
          category: 'groups',
          query: query.value,
          fromJson: SearchGroupResult.fromJson,
          cursor: cursor,
        );
        tabResults[tab] = [...tabResults[tab]!, ...page.items];
        tabCursors[tab] = page.nextCursor;
        tabExhausted[tab] = !page.hasMore;
        break;
      case SearchTab.pages:
        final page = await _repo.searchCategory(
          category: 'pages',
          query: query.value,
          fromJson: SearchPageResult.fromJson,
          cursor: cursor,
        );
        tabResults[tab] = [...tabResults[tab]!, ...page.items];
        tabCursors[tab] = page.nextCursor;
        tabExhausted[tab] = !page.hasMore;
        break;
      case SearchTab.marketplace:
        final page = await _repo.searchCategory(
          category: 'marketplace',
          query: query.value,
          fromJson: SearchMarketplaceResult.fromJson,
          cursor: cursor,
        );
        tabResults[tab] = [...tabResults[tab]!, ...page.items];
        tabCursors[tab] = page.nextCursor;
        tabExhausted[tab] = !page.hasMore;
        break;
      default:
        break;
    }

    tabLoadingMore[tab] = false;
    tabResults.refresh();
  }

  // ─── User Actions ───────────────────────────────────────────────────────

  /// Send or cancel friend request for a person result.
  Future<void> toggleFriendRequest(SearchPersonResult person) async {
    if (person.friendStatus == 'none') {
      final ok = await _repo.sendFriendRequest(person.id);
      if (ok) _updatePerson(person.id, person.copyWith(friendStatus: 'request_sent'));
    } else if (person.friendStatus == 'request_sent') {
      final ok = await _repo.cancelFriendRequest(person.id);
      if (ok) _updatePerson(person.id, person.copyWith(friendStatus: 'none'));
    }
  }

  void _updatePerson(String personId, SearchPersonResult updated) {
    // Update in unified result
    final uPeople = unifiedResult.value.people.items;
    final uIdx = uPeople.indexWhere((p) => p.id == personId);
    if (uIdx >= 0) {
      uPeople[uIdx] = updated;
      unifiedResult.refresh();
    }

    // Update in tab results
    final list = tabResults[SearchTab.people]!;
    final tIdx = list.indexWhere((p) => (p as SearchPersonResult).id == personId);
    if (tIdx >= 0) {
      list[tIdx] = updated;
      tabResults.refresh();
    }
  }

  /// Follow or unfollow a page.
  Future<void> toggleFollowPage(SearchPageResult page) async {
    if (page.isFollowing) {
      final ok = await _repo.unfollowPage(page.id);
      if (ok) _updatePage(page.id, page.copyWith(isFollowing: false));
    } else {
      final ok = await _repo.followPage(page.id);
      if (ok) _updatePage(page.id, page.copyWith(isFollowing: true));
    }
  }

  void _updatePage(String pageId, SearchPageResult updated) {
    final uPages = unifiedResult.value.pages.items;
    final uIdx = uPages.indexWhere((p) => p.id == pageId);
    if (uIdx >= 0) {
      uPages[uIdx] = updated;
      unifiedResult.refresh();
    }

    final list = tabResults[SearchTab.pages]!;
    final tIdx = list.indexWhere((p) => (p as SearchPageResult).id == pageId);
    if (tIdx >= 0) {
      list[tIdx] = updated;
      tabResults.refresh();
    }
  }

  /// Join a group.
  Future<void> toggleJoinGroup(SearchGroupResult group) async {
    if (!group.isMember) {
      final ok = await _repo.joinGroup(group.id);
      if (ok) _updateGroup(group.id, group.copyWith(isMember: true));
    }
  }

  void _updateGroup(String groupId, SearchGroupResult updated) {
    final uGroups = unifiedResult.value.groups.items;
    final uIdx = uGroups.indexWhere((g) => g.id == groupId);
    if (uIdx >= 0) {
      uGroups[uIdx] = updated;
      unifiedResult.refresh();
    }

    final list = tabResults[SearchTab.groups]!;
    final tIdx = list.indexWhere((g) => (g as SearchGroupResult).id == groupId);
    if (tIdx >= 0) {
      list[tIdx] = updated;
      tabResults.refresh();
    }
  }

  // ─── History Actions ────────────────────────────────────────────────────

  Future<void> deleteHistoryItem(SearchHistoryItem item) async {
    final ok = await _repo.deleteSearchHistoryItem(item.id);
    if (ok) {
      recentSearches.removeWhere((h) => h.id == item.id);
    }
  }

  Future<void> clearAllHistory() async {
    final ok = await _repo.clearAllSearchHistory();
    if (ok) {
      recentSearches.clear();
    }
  }

  // ─── Navigation helpers ─────────────────────────────────────────────────

  void onTapPerson(SearchPersonResult person) {
    // Save to history
    _repo.addSearchHistory(
      query: person.fullName,
      type: 'user',
      resultId: person.id,
      resultType: 'User',
    );
    ProfileNavigator.navigateToProfile(
      username: person.username,
      isFromReels: 'false',
      isFromPageReels: 'false',
    );
  }

  void onTapReel(SearchReelResult reel) {
    _repo.addSearchHistory(
      query: reel.title ?? reel.description ?? query.value,
      type: 'reel',
      resultId: reel.id,
      resultType: 'Reels',
    );
    Get.toNamed(Routes.OTHER_USER_VIDEO, arguments: {
      'reels_id': reel.id,
    });
  }

  void onTapPage(SearchPageResult page) {
    _repo.addSearchHistory(
      query: page.pageName,
      type: 'page',
      resultId: page.id,
      resultType: 'Pages',
    );
    Get.toNamed(Routes.PAGE_PROFILE, arguments: {
      'pageUsername': page.username ?? page.id,
    });
  }

  void onTapGroup(SearchGroupResult group) {
    _repo.addSearchHistory(
      query: group.groupName,
      type: 'group',
      resultId: group.id,
      resultType: 'Group',
    );
    Get.toNamed(Routes.GROUP_PROFILE, arguments: {
      'groupUsername': group.groupUsername ?? group.id,
    });
  }

  void onTapMarketplaceItem(SearchMarketplaceResult product) {
    _repo.addSearchHistory(
      query: product.title,
      type: 'product',
      resultId: product.id,
      resultType: 'Product',
    );
    Get.toNamed(Routes.PRODUCT_DETAILS, arguments: {
      'productId': product.id,
    });
  }

  /// Handle suggestion tap — either navigate directly or execute a search.
  void onTapSuggestion(SearchSuggestion suggestion) {
    if (suggestion.type == 'user' && suggestion.id != null) {
      _repo.addSearchHistory(
        query: suggestion.text,
        type: 'user',
        resultId: suggestion.id,
        resultType: 'User',
      );
      ProfileNavigator.navigateToProfile(
        username: suggestion.text,
        isFromReels: 'false',
        isFromPageReels: 'false',
      );
    } else if (suggestion.type == 'page' && suggestion.id != null) {
      _repo.addSearchHistory(
        query: suggestion.text,
        type: 'page',
        resultId: suggestion.id,
        resultType: 'Pages',
      );
      Get.toNamed(Routes.PAGE_PROFILE, arguments: {
        'pageUsername': suggestion.id,
      });
    } else if (suggestion.type == 'group' && suggestion.id != null) {
      _repo.addSearchHistory(
        query: suggestion.text,
        type: 'group',
        resultId: suggestion.id,
        resultType: 'Group',
      );
      Get.toNamed(Routes.GROUP_PROFILE, arguments: {
        'groupUsername': suggestion.id,
      });
    } else {
      // type == 'query' or fallback — execute search
      executeSearch(suggestion.text);
    }
  }

  void onTapHistoryItem(SearchHistoryItem item) {
    executeSearch(item.query);
  }

  void onTapTrending(TrendingSearch trending) {
    executeSearch(trending.query);
  }
}
