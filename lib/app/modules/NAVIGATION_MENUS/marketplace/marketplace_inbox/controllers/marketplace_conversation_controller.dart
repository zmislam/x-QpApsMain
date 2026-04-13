import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../models/marketplace_conversation_model.dart';
import '../../../../../models/marketplace_message_model.dart';
import '../../../../../models/api_response.dart';
import '../../../../../repository/marketplace_inbox_repository.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../utils/snackbar.dart';

class MarketplaceConversationController extends GetxController {
  final MarketplaceInboxRepository _repo = MarketplaceInboxRepository();
  final LoginCredential _loginCredential = LoginCredential();

  final messages = <MarketplaceMessageModel>[].obs;
  final isLoading = true.obs;
  final isSending = false.obs;

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  String? conversationId;
  ConversationUser? otherUser;
  ConversationProduct? product;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      conversationId = args['conversationId']?.toString();
      otherUser = args['otherUser'] as ConversationUser?;
      product = args['product'] as ConversationProduct?;
    }
    if (conversationId != null) {
      fetchMessages();
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  String get currentUserId => _loginCredential.getUserData().id ?? '';

  Future<void> fetchMessages() async {
    isLoading.value = true;

    final ApiResponse response = await _repo.getConversationDetail(
      conversationId: conversationId!,
    );

    isLoading.value = false;

    if (response.isSuccessful && response.data is Map) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(response.data as Map);
      final List<dynamic> msgList = data['messages'] ?? [];
      messages.value = msgList
          .map((e) =>
              MarketplaceMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Scroll to bottom after load
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || conversationId == null) return;

    isSending.value = true;
    messageController.clear();

    final ApiResponse response = await _repo.sendReply(
      conversationId: conversationId!,
      message: text,
    );

    isSending.value = false;

    if (response.isSuccessful && response.data is Map) {
      final newMsg = MarketplaceMessageModel.fromJson(
          Map<String, dynamic>.from(response.data as Map));
      messages.add(newMsg);
      _scrollToBottom();
    } else {
      messageController.text = text; // Restore on failure
      showErrorSnackkbar(message: response.message ?? 'Failed to send message');
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 60,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
