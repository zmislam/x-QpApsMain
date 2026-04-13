import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../repository/buyer_repository.dart';
import '../../../../../../repository/cart_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../models/address_model.dart';

class AddressManagementController extends GetxController {
  final BuyerRepository _buyerRepo = BuyerRepository();
  final CartRepository _cartRepo = CartRepository();

  RxList<AddressItem> addresses = <AddressItem>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDeleting = false.obs;
  RxString deletingAddressId = ''.obs;
  RxInt totalCount = 0.obs;

  // Geo cascade dropdowns
  RxList<dynamic> countries = <dynamic>[].obs;
  RxList<dynamic> states = <dynamic>[].obs;
  RxList<dynamic> cities = <dynamic>[].obs;
  RxBool isLoadingCountries = false.obs;
  RxBool isLoadingStates = false.obs;
  RxBool isLoadingCities = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    isLoading.value = true;

    final response = await _buyerRepo.getAddressList(limit: 100);

    isLoading.value = false;

    if (response.isSuccessful && response.data != null) {
      List rawList;
      if (response.data is List) {
        rawList = response.data as List;
      } else if (response.data is Map) {
        final map = response.data as Map<String, dynamic>;
        rawList = (map['results'] ?? map['data'] ?? []) as List;
        totalCount.value = (map['totalCount'] as int?) ?? 0;
      } else {
        rawList = [];
      }
      addresses.value = rawList
          .map((e) => AddressItem.fromMap(e as Map<String, dynamic>))
          .toList();
      if (totalCount.value == 0) totalCount.value = addresses.length;
    } else {
      debugPrint('Error fetching addresses: ${response.message}');
    }
  }

  Future<void> deleteAddress(String addressId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isDeleting.value = true;
    deletingAddressId.value = addressId;

    final response = await _buyerRepo.deleteAddress(addressId: addressId);

    isDeleting.value = false;
    deletingAddressId.value = '';

    if (response.isSuccessful) {
      addresses.removeWhere((a) => a.id == addressId);
      AppSnackbar.showSuccess('Address deleted');
    } else {
      AppSnackbar.showError(
          response.message ?? 'Failed to delete address');
    }
  }

  Future<void> refreshAddresses() async {
    await fetchAddresses();
  }

  // ─── Geo Cascade Methods (reuse cart_repository) ──────────
  Future<void> loadCountries() async {
    isLoadingCountries.value = true;
    final response = await _cartRepo.getCountries();
    isLoadingCountries.value = false;
    if (response.isSuccessful && response.data is List) {
      countries.value = response.data as List;
    }
  }

  Future<void> loadStates(String countryName) async {
    states.clear();
    cities.clear();
    isLoadingStates.value = true;
    final response = await _cartRepo.getStates(countryName);
    isLoadingStates.value = false;
    if (response.isSuccessful && response.data is List) {
      states.value = response.data as List;
    }
  }

  Future<void> loadCities(String countryName, String stateName) async {
    cities.clear();
    isLoadingCities.value = true;
    final response = await _cartRepo.getCities(
      countryName,
      stateName,
    );
    isLoadingCities.value = false;
    if (response.isSuccessful && response.data is List) {
      cities.value = response.data as List;
    }
  }
}
