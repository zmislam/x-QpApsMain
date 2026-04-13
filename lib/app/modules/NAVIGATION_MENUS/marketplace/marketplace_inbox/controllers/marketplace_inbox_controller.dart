import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../models/marketplace_conversation_model.dart';
import '../../../../../models/api_response.dart';
import '../../../../../repository/marketplace_inbox_repository.dart';
import '../../../../../routes/app_pages.dart';

class MarketplaceInboxController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final MarketplaceInboxRepository _repo = MarketplaceInboxRepository();

  final conversations = <MarketplaceConversationModel>[].obs;
  final isLoading = true.obs;
  final isFetchingMore = false.obs;
  final hasMore = true.obs;
  final selectedTab = 'all'.obs;

  int _currentPage = 1;
  static const int _limit = 20;

  late TabController tabController;
  final scrollController = ScrollController();

  static const _tabValues = ['all', 'buying', 'selling'];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_onTabChanged);
    fetchConversations();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _onTabChanged() {
    if (tabController.indexIsChanging) return;
    final tab = _tabValues[tabController.index];
    if (selectedTab.value != tab) {
      selectedTab.value = tab;
      fetchConversations(refresh: true);
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isFetchingMore.value &&
        hasMore.value) {
      loadMore();
    }
  }

  Future<void> fetchConversations({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      hasMore.value = true;
      conversations.clear();
    }

    isLoading.value = conversations.isEmpty;

    final ApiResponse response = await _repo.getConversations(
      tab: selectedTab.value,
      page: _currentPage,
      limit: _limit,
    );

    isLoading.value = false;

    if (response.isSuccessful && response.data is Map) {
      final Map<String, dynamic> fullResponse =
          Map<String, dynamic>.from(response.data as Map);
      final List<dynamic> dataList = fullResponse['data'] ?? [];
      final List<MarketplaceConversationModel> fetched = dataList
          .map((e) => MarketplaceConversationModel.fromJson(
              e as Map<String, dynamic>))
          .toList();

      conversations.addAll(fetched);

      final pagination = fullResponse['pagination'] as Map?;
      if (pagination != null) {
        final int totalPages = pagination['pages'] ?? 1;
        hasMore.value = _currentPage < totalPages;
      } else {
        hasMore.value = fetched.length >= _limit;
      }
    }
  }

  Future<void> loadMore() async {
    if (isFetchingMore.value || !hasMore.value) return;
    isFetchingMore.value = true;
    _currentPage++;
    await fetchConversations();
    isFetchingMore.value = false;
  }

  Future<void> onRefresh() async {
    await fetchConversations(refresh: true);
  }

  void openConversation(MarketplaceConversationModel conversation) {
    Get.toNamed(
      Routes.MARKETPLACE_CONVERSATION,
      arguments: {
        'conversationId': conversation.conversationId,
        'otherUser': conversation.otherUser,
        'product': conversation.product,
      },
    );
  }
}
