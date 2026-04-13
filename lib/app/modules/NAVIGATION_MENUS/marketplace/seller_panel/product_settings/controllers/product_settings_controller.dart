import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class ProductSettingsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SellerRepository _repo = SellerRepository();

  // Tab state: 0 = Attributes, 1 = Colors
  final tabIndex = 0.obs;

  // ─── Attributes ───
  final isAttrLoading = true.obs;
  final attributes = <Map<String, dynamic>>[].obs;

  // ─── Colors ───
  final isColorLoading = true.obs;
  final colors = <Map<String, dynamic>>[].obs;

  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttributes();
    fetchColors();
  }

  // ─── Attributes CRUD ───
  Future<void> fetchAttributes() async {
    isAttrLoading.value = true;
    final res = await _repo.getAttributes(limit: 200);
    isAttrLoading.value = false;
    if (res.isSuccessful && res.data is List) {
      attributes.value = (res.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
    }
  }

  Future<void> saveAttribute(
      String name, Map<String, String> values, bool isRequired) async {
    isSaving.value = true;
    final res =
        await _repo.saveAttribute(name: name, value: values, isRequired: isRequired);
    isSaving.value = false;
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Attribute created');
      fetchAttributes();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to create attribute');
    }
  }

  Future<void> updateAttribute(
      String id, String name, Map<String, String> values) async {
    isSaving.value = true;
    final res =
        await _repo.updateAttribute(attributeId: id, name: name, value: values);
    isSaving.value = false;
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Attribute updated');
      fetchAttributes();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to update');
    }
  }

  Future<void> deleteAttribute(String id) async {
    final res = await _repo.deleteAttribute(attributeId: id);
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Attribute deleted');
      fetchAttributes();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to delete');
    }
  }

  // ─── Colors CRUD ───
  Future<void> fetchColors() async {
    isColorLoading.value = true;
    final res = await _repo.getColors(limit: 200);
    isColorLoading.value = false;
    if (res.isSuccessful && res.data is List) {
      colors.value = (res.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
    }
  }

  Future<void> saveColor(String name, String hexValue) async {
    isSaving.value = true;
    final res = await _repo.saveColor(name: name, value: hexValue);
    isSaving.value = false;
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Color created');
      fetchColors();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to create color');
    }
  }

  Future<void> updateColor(String id, String name, String hexValue) async {
    isSaving.value = true;
    final res =
        await _repo.updateColor(colorId: id, name: name, value: hexValue);
    isSaving.value = false;
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Color updated');
      fetchColors();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to update');
    }
  }

  Future<void> deleteColor(String id) async {
    final res = await _repo.deleteColor(colorId: id);
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Color deleted');
      fetchColors();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to delete');
    }
  }
}
