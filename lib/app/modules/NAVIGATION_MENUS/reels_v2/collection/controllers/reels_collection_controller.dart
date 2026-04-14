import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/reels_v2_api_service.dart';
import '../../models/reel_collection_model.dart';
import '../../models/reel_v2_model.dart';
import '../../utils/reel_constants.dart';

class ReelsCollectionController extends GetxController {
  final ReelsV2ApiService _apiService = ReelsV2ApiService();

  // ─── State ────────────────────────────────────────────────
  final collections = <ReelCollectionModel>[].obs;
  final isLoading = false.obs;
  final selectedCollection = Rxn<ReelCollectionModel>();
  final collectionReels = <ReelV2Model>[].obs;
  final collectionReelsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCollections();
  }

  // ─── Collections CRUD ─────────────────────────────────────

  Future<void> loadCollections() async {
    isLoading.value = true;
    try {
      final res = await _apiService.getCollections();
      if (res.isSuccessful && res.data != null) {
        final data = res.data is Map ? (res.data as Map)['collections'] ?? [] : res.data;
        collections.value = (data as List)
            .map((e) => ReelCollectionModel.fromMap(e))
            .toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCollection(String name, {String? description}) async {
    final res = await _apiService.createCollection({
      'name': name,
      if (description != null) 'description': description,
    });
    if (res.isSuccessful) {
      await loadCollections();
      Get.snackbar('Success', 'Collection created',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> renameCollection(String collectionId, String newName) async {
    final res = await _apiService.updateCollection(collectionId, {
      'name': newName,
    });
    if (res.isSuccessful) {
      final idx = collections.indexWhere((c) => c.id == collectionId);
      if (idx != -1) {
        collections[idx] = collections[idx].copyWith(name: newName);
        collections.refresh();
      }
    }
  }

  Future<void> deleteCollection(String collectionId) async {
    final res = await _apiService.deleteCollection(collectionId);
    if (res.isSuccessful) {
      collections.removeWhere((c) => c.id == collectionId);
      Get.snackbar('Deleted', 'Collection removed',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ─── Collection Items ─────────────────────────────────────

  Future<void> loadCollectionReels(String collectionId) async {
    collectionReelsLoading.value = true;
    selectedCollection.value =
        collections.firstWhereOrNull((c) => c.id == collectionId);

    try {
      final res = await _apiService.getCollectionReels(collectionId);
      if (res.isSuccessful && res.data != null) {
        final data = res.data is Map ? (res.data as Map)['reels'] ?? [] : res.data;
        collectionReels.value =
            (data as List).map((e) => ReelV2Model.fromMap(e)).toList();
      }
    } finally {
      collectionReelsLoading.value = false;
    }
  }

  Future<void> addToCollection(String collectionId, String reelId) async {
    final res = await _apiService.addToCollection(collectionId, reelId);
    if (res.isSuccessful) {
      // Update count locally
      final idx = collections.indexWhere((c) => c.id == collectionId);
      if (idx != -1) {
        collections[idx] = collections[idx].copyWith(
          reelCount: collections[idx].reelCount + 1,
        );
        collections.refresh();
      }
    }
  }

  Future<void> removeFromCollection(String collectionId, String reelId) async {
    final res = await _apiService.removeFromCollection(collectionId, reelId);
    if (res.isSuccessful) {
      collectionReels.removeWhere((r) => r.id == reelId);
      final idx = collections.indexWhere((c) => c.id == collectionId);
      if (idx != -1) {
        collections[idx] = collections[idx].copyWith(
          reelCount: (collections[idx].reelCount - 1).clamp(0, 999999),
        );
        collections.refresh();
      }
    }
  }

  // ─── Save Reel Dialog ─────────────────────────────────────

  void showSaveToCollectionSheet(String reelId) {
    Get.bottomSheet(
      _buildCollectionPicker(reelId),
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  dynamic _buildCollectionPicker(String reelId) {
    // Returns a widget; this is a simplified placeholder
    // The actual widget is in collection_picker_sheet.dart
    return null;
  }
}
