import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class SellerStoresController extends GetxController {
  final SellerRepository _repo = SellerRepository();
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;
  final RxBool hasMore = true.obs;
  final RxBool isSaving = false.obs;

  // Form fields
  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final shippingCtrl = TextEditingController();
  final deliveryCtrl = TextEditingController();
  final returnsCtrl = TextEditingController();
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);

  static const int _pageSize = 10;
  int _skip = 0;

  @override
  void onInit() {
    super.onInit();
    fetchStores();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    descriptionCtrl.dispose();
    categoryCtrl.dispose();
    shippingCtrl.dispose();
    deliveryCtrl.dispose();
    returnsCtrl.dispose();
    super.onClose();
  }

  Future<void> fetchStores({bool loadMore = false}) async {
    if (loadMore) {
      _skip += _pageSize;
    } else {
      _skip = 0;
      stores.clear();
      isLoading.value = true;
    }

    final response = await _repo.getMyStores(
      skip: _skip,
      limit: _pageSize,
    );

    isLoading.value = false;

    if (response.isSuccessful && response.data is List) {
      final items = (response.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
      stores.addAll(items);
      hasMore.value = items.length >= _pageSize;
    } else if (!loadMore) {
      AppSnackbar.showError(response.message ?? 'Failed to load stores');
    }
  }

  Future<void> pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) selectedImage.value = file;
  }

  void clearForm() {
    nameCtrl.clear();
    descriptionCtrl.clear();
    categoryCtrl.clear();
    shippingCtrl.clear();
    deliveryCtrl.clear();
    returnsCtrl.clear();
    selectedImage.value = null;
  }

  void populateForm(Map<String, dynamic> store) {
    nameCtrl.text = store['name'] as String? ?? '';
    descriptionCtrl.text = store['description'] as String? ?? '';
    categoryCtrl.text = store['category_name'] as String? ?? '';
    shippingCtrl.text = store['shipping'] as String? ?? '';
    deliveryCtrl.text = store['delivery'] as String? ?? '';
    returnsCtrl.text = store['returns'] as String? ?? '';
    selectedImage.value = null;
  }

  Future<void> saveStore() async {
    if (nameCtrl.text.isEmpty) {
      AppSnackbar.showError('Store name is required');
      return;
    }

    isSaving.value = true;
    final data = <String, dynamic>{
      'name': nameCtrl.text.trim(),
      if (descriptionCtrl.text.isNotEmpty)
        'description': descriptionCtrl.text.trim(),
      if (categoryCtrl.text.isNotEmpty)
        'category_name': categoryCtrl.text.trim(),
      if (shippingCtrl.text.isNotEmpty) 'shipping': shippingCtrl.text.trim(),
      if (deliveryCtrl.text.isNotEmpty) 'delivery': deliveryCtrl.text.trim(),
      if (returnsCtrl.text.isNotEmpty) 'returns': returnsCtrl.text.trim(),
    };

    final response = await _repo.saveStore(
      storeData: data,
      storeImage: selectedImage.value,
    );

    isSaving.value = false;

    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Store created');
      clearForm();
      fetchStores();
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to create store');
    }
  }

  Future<void> updateStore(String storeId) async {
    if (nameCtrl.text.isEmpty) {
      AppSnackbar.showError('Store name is required');
      return;
    }

    isSaving.value = true;
    final data = <String, dynamic>{
      'name': nameCtrl.text.trim(),
      'description': descriptionCtrl.text.trim(),
      'category_name': categoryCtrl.text.trim(),
      'shipping': shippingCtrl.text.trim(),
      'delivery': deliveryCtrl.text.trim(),
      'returns': returnsCtrl.text.trim(),
    };

    final response = await _repo.updateStore(
      storeId: storeId,
      storeData: data,
      storeImage: selectedImage.value,
    );

    isSaving.value = false;

    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Store updated');
      clearForm();
      fetchStores();
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to update store');
    }
  }

  Future<void> deleteStore(String storeId) async {
    final response = await _repo.deleteStore(storeId: storeId);
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Store deleted');
      stores.removeWhere((s) => s['_id'] == storeId);
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to delete store');
    }
  }
}
