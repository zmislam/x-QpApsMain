import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../models/api_response.dart';
import '../../../../../../repository/reels_repository.dart';
import '../../../model/reels_model.dart';
import '../../../model/reels_creator_suggestion_model.dart';

class ReelsSearchController extends GetxController {
  final ReelsRepository _reelsRepository = ReelsRepository();

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  Rx<List<ReelsModel>> searchResults = Rx([]);
  RxList<ReelsCreatorSuggestion> creatorSuggestions = <ReelsCreatorSuggestion>[].obs;
  RxList<String> recentSearches = <String>[].obs;
  RxBool isSearching = false.obs;
  RxBool isLoadingResults = false.obs;
  RxBool isLoadingSuggestions = false.obs;
  RxString query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSuggestions();
    searchFocusNode.requestFocus();

    // Debounce search input
    debounce(query, (_) => _performSearch(), time: const Duration(milliseconds: 400));
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void onSearchChanged(String value) {
    query.value = value.trim();
    if (value.trim().isEmpty) {
      searchResults.value = [];
      isSearching.value = false;
    } else {
      isSearching.value = true;
    }
  }

  void clearSearch() {
    searchController.clear();
    query.value = '';
    searchResults.value = [];
    isSearching.value = false;
    searchFocusNode.requestFocus();
  }

  void submitSearch(String value) {
    if (value.trim().isEmpty) return;
    final trimmed = value.trim();

    // Add to recent searches (max 10, no duplicates)
    recentSearches.remove(trimmed);
    recentSearches.insert(0, trimmed);
    if (recentSearches.length > 10) {
      recentSearches.removeLast();
    }

    query.value = trimmed;
    _performSearch();
  }

  void removeRecentSearch(String term) {
    recentSearches.remove(term);
  }

  void tapSuggestion(String suggestion) {
    searchController.text = suggestion;
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );
    submitSearch(suggestion);
  }

  Future<void> _loadSuggestions() async {
    isLoadingSuggestions.value = true;
    try {
      final ApiResponse response = await _reelsRepository.getSearchSuggestions(limit: 15);
      if (response.isSuccessful && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final topCreators = data['topCreators'] as List? ?? [];
        creatorSuggestions.value = topCreators
            .map((e) => ReelsCreatorSuggestion.fromMap(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    isLoadingSuggestions.value = false;
  }

  void refreshSuggestions() {
    _loadSuggestions();
  }

  Future<void> _performSearch() async {
    final q = query.value;
    if (q.isEmpty) return;

    isLoadingResults.value = true;
    try {
      final ApiResponse response = await _reelsRepository.searchReels(
        query: q,
        limit: 20,
        skip: 0,
      );
      if (response.isSuccessful && response.data != null) {
        searchResults.value = response.data as List<ReelsModel>;
      } else {
        searchResults.value = [];
      }
    } catch (_) {
      searchResults.value = [];
    } finally {
      isLoadingResults.value = false;
    }
  }
}
