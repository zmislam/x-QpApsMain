import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../../add_product/controllers/add_product_controller.dart';

/// EditProductController extends AddProductController
/// and pre-populates fields from existing product data.
class EditProductController extends AddProductController {
  final SellerRepository _editRepo = SellerRepository();
  final RxBool isLoadingProduct = true.obs;
  String? productId;

  @override
  bool get isEditMode => true;

  @override
  void onInit() {
    super.onInit();
    productId = Get.arguments?['product_id'] as String?;
    if (productId != null) {
      _loadProductData();
    } else {
      isLoadingProduct.value = false;
    }
  }

  Future<void> _loadProductData() async {
    isLoadingProduct.value = true;
    final response =
        await _editRepo.getProductDetailsForSeller(productId: productId!);
    isLoadingProduct.value = false;

    if (response.isSuccessful) {
      final data = response.data;
      Map<String, dynamic> product = {};

      if (data is List && data.isNotEmpty) {
        product = data[0] as Map<String, dynamic>? ?? {};
      } else if (data is Map<String, dynamic>) {
        product = data;
      }

      _populateFields(product);
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to load product');
    }
  }

  void _populateFields(Map<String, dynamic> p) {
    productNameCtrl.text = p['product_name'] as String? ?? '';
    descriptionCtrl.text = p['description'] as String? ?? '';
    selectedCategory.value = p['category_name'] as String? ?? '';
    selectedBrand.value = p['brand_name'] as String? ?? '';
    selectedCondition.value = p['condition'] as String? ?? 'new';
    listingType.value = p['listing_type'] as String? ?? 'item';
    hideFromFriends.value = p['hide_from_friends'] == true;

    mainPriceCtrl.text = (p['base_main_price'] ?? p['main_price'] ?? '').toString();
    sellPriceCtrl.text = (p['base_selling_price'] ?? p['sell_price'] ?? '').toString();
    stockCtrl.text = (p['stock'] ?? '').toString();
    vatCtrl.text = (p['vat'] ?? '').toString();
    taxCtrl.text = (p['tax'] ?? '').toString();

    weightCtrl.text = (p['weight'] ?? '').toString();
    lengthCtrl.text = (p['length'] ?? '').toString();
    widthCtrl.text = (p['width'] ?? '').toString();
    heightCtrl.text = (p['height'] ?? '').toString();

    final shipping = p['shipping_charge'];
    if (shipping != null && shipping.toString() == '0') {
      freeShipping.value = true;
    } else {
      shippingChargeCtrl.text = (shipping ?? '').toString();
    }

    selectedStoreId.value = p['store_id']?.toString() ?? '';
    productStatus.value = p['status'] as String? ?? 'draft';

    hasVariant.value = p['hasVariant'] == true || p['hasVariant'] == 'true';
  }

  @override
  Future<void> saveProduct() async {
    if (productId == null) {
      AppSnackbar.showError('No product ID');
      return;
    }

    if (selectedStoreId.value.isEmpty) {
      AppSnackbar.showError('Please select a store');
      return;
    }

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
    if (weightCtrl.text.isNotEmpty) data['weight'] = weightCtrl.text.trim();
    if (lengthCtrl.text.isNotEmpty) data['length'] = lengthCtrl.text.trim();
    if (widthCtrl.text.isNotEmpty) data['width'] = widthCtrl.text.trim();
    if (heightCtrl.text.isNotEmpty) data['height'] = heightCtrl.text.trim();
    if (freeShipping.value) {
      data['shipping_charge'] = '0';
    } else if (shippingChargeCtrl.text.isNotEmpty) {
      data['shipping_charge'] = shippingChargeCtrl.text.trim();
    }

    final response = await _editRepo.updateProduct(
      productId: productId!,
      productData: data,
      productImages: productImages.isNotEmpty ? productImages.toList() : null,
    );

    isSaving.value = false;

    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Product updated successfully');
      Get.back();
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to update product');
    }
  }
}
