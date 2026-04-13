import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class AddProductController extends GetxController {
  final SellerRepository _repo = SellerRepository();
  final ImagePicker _picker = ImagePicker();

  /// Override in subclass (EditProductController) to return true.
  bool get isEditMode => false;

  // ─── Step tracking ────────────────────────────────────────
  final RxInt currentStep = 0.obs;
  static const int totalSteps = 5;
  final pageController = PageController();

  // ─── Step 1: General Info ─────────────────────────────────
  final productNameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final RxString selectedCategory = ''.obs;
  final RxString selectedBrand = ''.obs;
  final RxString selectedCondition = 'new'.obs;
  final RxString listingType = 'item'.obs;
  final RxBool hideFromFriends = false.obs;

  // Category / brand lists
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> brands = <Map<String, dynamic>>[].obs;
  final RxBool isCategoriesLoading = false.obs;
  final RxBool isBrandsLoading = false.obs;

  // ─── Vehicle-specific fields ──────────────────────────────
  final vehicleMakeCtrl = TextEditingController();
  final vehicleModelCtrl = TextEditingController();
  final vehicleYearCtrl = TextEditingController();
  final vehicleMileageCtrl = TextEditingController();
  final RxString vehicleFuelType = ''.obs;
  final RxString vehicleTransmission = ''.obs;

  // ─── Property-specific fields ─────────────────────────────
  final RxString propertyType = ''.obs;
  final propertyBedroomsCtrl = TextEditingController();
  final propertyBathroomsCtrl = TextEditingController();
  final propertyAreaCtrl = TextEditingController();
  final propertyLocationCtrl = TextEditingController();

  // ─── Step 2: Media ────────────────────────────────────────
  final RxList<XFile> productImages = <XFile>[].obs;
  static const int maxImages = 10;

  // ─── Step 3: Pricing ──────────────────────────────────────
  final mainPriceCtrl = TextEditingController();
  final sellPriceCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final vatCtrl = TextEditingController();
  final taxCtrl = TextEditingController();
  final RxBool hasVariant = false.obs;
  final RxList<Map<String, dynamic>> variants = <Map<String, dynamic>>[].obs;

  // ─── Step 4: Shipping ─────────────────────────────────────
  final weightCtrl = TextEditingController();
  final lengthCtrl = TextEditingController();
  final widthCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final shippingChargeCtrl = TextEditingController();
  final RxBool freeShipping = false.obs;

  // ─── Step 5: Store & Status ───────────────────────────────
  final RxString selectedStoreId = ''.obs;
  final RxString productStatus = 'draft'.obs;
  final tagsCtrl = TextEditingController();
  final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;
  final RxBool isStoresLoading = false.obs;

  // ─── Submission ───────────────────────────────────────────
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
    _loadBrands();
    _loadStores();
  }

  @override
  void onClose() {
    pageController.dispose();
    productNameCtrl.dispose();
    descriptionCtrl.dispose();
    mainPriceCtrl.dispose();
    sellPriceCtrl.dispose();
    stockCtrl.dispose();
    vatCtrl.dispose();
    taxCtrl.dispose();
    weightCtrl.dispose();
    lengthCtrl.dispose();
    widthCtrl.dispose();
    heightCtrl.dispose();
    shippingChargeCtrl.dispose();
    tagsCtrl.dispose();
    vehicleMakeCtrl.dispose();
    vehicleModelCtrl.dispose();
    vehicleYearCtrl.dispose();
    vehicleMileageCtrl.dispose();
    propertyBedroomsCtrl.dispose();
    propertyBathroomsCtrl.dispose();
    propertyAreaCtrl.dispose();
    propertyLocationCtrl.dispose();
    super.onClose();
  }

  // ─── Data loaders ─────────────────────────────────────────
  Future<void> _loadCategories() async {
    isCategoriesLoading.value = true;
    final response = await _repo.getCategories();
    isCategoriesLoading.value = false;
    if (response.isSuccessful && response.data is List) {
      categories.value = (response.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
    }
  }

  Future<void> _loadBrands() async {
    isBrandsLoading.value = true;
    final response = await _repo.getBrands();
    isBrandsLoading.value = false;
    if (response.isSuccessful && response.data is List) {
      brands.value = (response.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
    }
  }

  Future<void> _loadStores() async {
    isStoresLoading.value = true;
    final response = await _repo.getMyStores(limit: 50);
    isStoresLoading.value = false;
    if (response.isSuccessful && response.data is List) {
      stores.value = (response.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
      // Auto-select first if only one store
      if (stores.length == 1) {
        selectedStoreId.value = stores.first['_id']?.toString() ?? '';
      }
    }
  }

  // ─── Step navigation ──────────────────────────────────────
  void nextStep() {
    if (!_validateCurrentStep()) return;
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0: // General
        if (productNameCtrl.text.trim().isEmpty) {
          AppSnackbar.showError('Product name is required');
          return false;
        }
        if (selectedCategory.value.isEmpty) {
          AppSnackbar.showError('Please select a category');
          return false;
        }
        return true;
      case 1: // Media
        if (productImages.isEmpty) {
          AppSnackbar.showError('Add at least one product image');
          return false;
        }
        return true;
      case 2: // Pricing
        if (mainPriceCtrl.text.trim().isEmpty) {
          AppSnackbar.showError('Base price is required');
          return false;
        }
        if (sellPriceCtrl.text.trim().isEmpty) {
          AppSnackbar.showError('Selling price is required');
          return false;
        }
        return true;
      case 3: // Shipping
        return true;
      case 4: // Store
        if (selectedStoreId.value.isEmpty) {
          AppSnackbar.showError('Please select a store');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  // ─── Media ────────────────────────────────────────────────
  Future<void> pickImages() async {
    final remaining = maxImages - productImages.length;
    if (remaining <= 0) {
      AppSnackbar.showError('Maximum $maxImages images allowed');
      return;
    }
    final files = await _picker.pickMultiImage(limit: remaining);
    if (files.isNotEmpty) {
      productImages.addAll(files);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < productImages.length) {
      productImages.removeAt(index);
    }
  }

  // ─── Variants ─────────────────────────────────────────────
  void addVariant() {
    variants.add({
      'sku': '',
      'main_price': '',
      'sell_price': '',
      'stock': '',
      'attribute': <String, dynamic>{},
    });
  }

  void removeVariant(int index) {
    if (index >= 0 && index < variants.length) {
      variants.removeAt(index);
    }
  }

  // ─── Submit ───────────────────────────────────────────────
  Future<void> saveProduct() async {
    if (!_validateCurrentStep()) return;

    isSaving.value = true;

    final data = <String, dynamic>{
      'store_id': selectedStoreId.value,
      'product_name': productNameCtrl.text.trim(),
      'category_name': selectedCategory.value,
      'description': descriptionCtrl.text.trim(),
      'listing_type': listingType.value,
      'condition': selectedCondition.value,
      'status': productStatus.value,
      'base_main_price': mainPriceCtrl.text.trim(),
      'base_selling_price': sellPriceCtrl.text.trim(),
      'main_price': mainPriceCtrl.text.trim(),
      'sell_price': sellPriceCtrl.text.trim(),
      'hasVariant': hasVariant.value.toString(),
      'hide_from_friends': hideFromFriends.value,
    };

    if (selectedBrand.value.isNotEmpty) {
      data['brand_name'] = selectedBrand.value;
    }
    if (stockCtrl.text.isNotEmpty) data['stock'] = stockCtrl.text.trim();
    if (vatCtrl.text.isNotEmpty) data['vat'] = vatCtrl.text.trim();
    if (taxCtrl.text.isNotEmpty) data['tax'] = taxCtrl.text.trim();

    // Shipping
    if (weightCtrl.text.isNotEmpty) data['weight'] = weightCtrl.text.trim();
    if (lengthCtrl.text.isNotEmpty) data['length'] = lengthCtrl.text.trim();
    if (widthCtrl.text.isNotEmpty) data['width'] = widthCtrl.text.trim();
    if (heightCtrl.text.isNotEmpty) data['height'] = heightCtrl.text.trim();
    if (freeShipping.value) {
      data['shipping_charge'] = '0';
    } else if (shippingChargeCtrl.text.isNotEmpty) {
      data['shipping_charge'] = shippingChargeCtrl.text.trim();
    }

    // Variants
    if (hasVariant.value && variants.isNotEmpty) {
      data['variant'] = jsonEncode(variants);
    }

    // Vehicle-specific fields
    if (listingType.value == 'vehicle') {
      if (vehicleMakeCtrl.text.isNotEmpty) {
        data['vehicle_make'] = vehicleMakeCtrl.text.trim();
      }
      if (vehicleModelCtrl.text.isNotEmpty) {
        data['vehicle_model'] = vehicleModelCtrl.text.trim();
      }
      if (vehicleYearCtrl.text.isNotEmpty) {
        data['vehicle_year'] = vehicleYearCtrl.text.trim();
      }
      if (vehicleMileageCtrl.text.isNotEmpty) {
        data['vehicle_mileage'] = vehicleMileageCtrl.text.trim();
      }
      if (vehicleFuelType.value.isNotEmpty) {
        data['vehicle_fuel_type'] = vehicleFuelType.value;
      }
      if (vehicleTransmission.value.isNotEmpty) {
        data['vehicle_transmission'] = vehicleTransmission.value;
      }
    }

    // Property-specific fields
    if (listingType.value == 'property') {
      if (propertyType.value.isNotEmpty) {
        data['property_type'] = propertyType.value;
      }
      if (propertyBedroomsCtrl.text.isNotEmpty) {
        data['property_bedrooms'] = propertyBedroomsCtrl.text.trim();
      }
      if (propertyBathroomsCtrl.text.isNotEmpty) {
        data['property_bathrooms'] = propertyBathroomsCtrl.text.trim();
      }
      if (propertyAreaCtrl.text.isNotEmpty) {
        data['property_area'] = propertyAreaCtrl.text.trim();
      }
      if (propertyLocationCtrl.text.isNotEmpty) {
        data['property_location'] = propertyLocationCtrl.text.trim();
      }
    }

    final response = await _repo.saveProduct(
      productData: data,
      productImages: productImages.isNotEmpty ? productImages.toList() : null,
    );

    isSaving.value = false;

    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Product saved successfully');
      Get.back();
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to save product');
    }
  }
}
