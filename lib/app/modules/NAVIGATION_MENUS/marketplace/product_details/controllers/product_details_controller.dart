import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../repository/market_place_repository.dart';
import '../../../../../models/api_response.dart';
import '../../../../../services/recently_visited_service.dart';
import '../../marketplace_products/controllers/marketplace_controller.dart';
import '../models/product_details_model.dart';
import '../models/product_review_model.dart';
import '../models/related_product_model.dart';
import '../models/product_question_model.dart';

class ProductDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final MarketPlaceRepository marketPlaceRepository = MarketPlaceRepository();
  MarketplaceController get marketPlaceController =>
      Get.find<MarketplaceController>();

  // ─── Core State ────────────────────────────────────────
  RxBool isLoading = true.obs;
  RxBool isLoadingRelatedProduct = true.obs;
  RxString pId = ''.obs;
  Rx<ProductDetails?> product = Rx<ProductDetails?>(null);
  // Keep backward compat — old widgets use productDetailsList
  Rx<List<ProductDetails>> productDetailsList = Rx([]);
  Rx<List<AllRelatedProducts>> relatedProductList = Rx([]);
  Rx<List<ProductReviewDetails>> productReviewDetailsList = Rx([]);
  Rx<ReviewData?> reviewData = Rx<ReviewData?>(null);

  // ─── Variant Selection ─────────────────────────────────
  final selectedAttributes = <String, String>{}.obs;
  final RxString selectedColorId = ''.obs;
  final RxString selectedProductVariantId = ''.obs;
  RxDouble currentPrice = 0.0.obs;
  RxDouble originalPrice = 0.0.obs;
  final RxInt productQuantity = 1.obs;
  final RxInt stock = 0.obs;

  // ─── Image Carousel ────────────────────────────────────
  final RxInt currentImageIndex = 0.obs;
  late PageController imagePageController;

  // ─── Tab Bar ───────────────────────────────────────────
  late TabController tabController;
  final RxInt currentTabIndex = 0.obs;

  // ─── Q&A ───────────────────────────────────────────────
  RxList<ProductQuestion> questions = <ProductQuestion>[].obs;
  RxBool isLoadingQuestions = false.obs;
  final questionTextController = TextEditingController();

  // ─── Follow ────────────────────────────────────────────
  RxBool isFollowingStore = false.obs;

  // ─── Quick Message ─────────────────────────────────────
  final messageTextController = TextEditingController();

  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    imagePageController = PageController();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });
    initializeApiCalling();
  }

  @override
  void onClose() {
    imagePageController.dispose();
    tabController.dispose();
    questionTextController.dispose();
    messageTextController.dispose();
    super.onClose();
  }

  // ─── Initialize ────────────────────────────────────────
  Future<void> initializeApiCalling() async {
    if (_isInitialized) return;
    _isInitialized = true;

    final args = Get.arguments;
    if (args != null) {
      pId.value = args is String ? args : args.toString();
      _resetState();
      await _fetchAllData();
    }
  }

  void _resetState() {
    product.value = null;
    productDetailsList.value = [];
    relatedProductList.value = [];
    productReviewDetailsList.value = [];
    reviewData.value = null;
    questions.clear();
    productQuantity.value = 1;
    selectedAttributes.clear();
    selectedColorId.value = '';
    selectedProductVariantId.value = '';
    currentPrice.value = 0.0;
    originalPrice.value = 0.0;
    stock.value = 0;
    currentImageIndex.value = 0;
    isFollowingStore.value = false;
  }

  Future<void> _fetchAllData() async {
    isLoading.value = true;
    await getProductDetails();
    // Record recently visited
    _recordRecentlyVisited();
    // Fire these in parallel
    getRelatedMarketPlaceProduct();
    getProductReviews();
    getProductQuestions();
    trackProductView();
    isLoading.value = false;
  }

  void _recordRecentlyVisited() {
    final p = product.value;
    if (p == null || pId.value.isEmpty) return;
    RecentlyVisitedService.instance.recordVisit(
      productId: pId.value,
      productName: p.productName,
      image: p.media?.isNotEmpty == true ? p.media!.first : null,
      sellPrice: p.productVariant?.isNotEmpty == true
          ? p.productVariant!.first.sellPrice
          : null,
    );
  }

  // ─── Navigate to another product ──────────────────────
  Future<void> navigateToProduct(String productId) async {
    pId.value = productId;
    _resetState();
    currentImageIndex.value = 0;
    if (imagePageController.hasClients) {
      imagePageController.jumpToPage(0);
    }
    tabController.animateTo(0);
    await _fetchAllData();
  }

  // ─── Product Details ───────────────────────────────────
  Future<void> getProductDetails() async {
    final apiResponse = await marketPlaceRepository.getProductDetailsById(
        productId: pId.value);
    if (apiResponse.isSuccessful) {
      final p = ProductDetails.fromMap(apiResponse.data as Map<String, dynamic>);
      product.value = p;
      productDetailsList.value = [p];
      productDetailsList.refresh();
      _initializePricing();
    }
  }

  void _initializePricing() {
    final p = product.value;
    if (p?.productVariant != null && p!.productVariant!.isNotEmpty) {
      final firstVariant = p.productVariant!.first;
      currentPrice.value = firstVariant.sellPrice ?? 0.0;
      originalPrice.value = firstVariant.mainPrice ?? 0.0;
      stock.value = firstVariant.stock ?? 0;
      selectedProductVariantId.value = firstVariant.id ?? '';
    }
  }

  // ─── Related Products ─────────────────────────────────
  Future<void> getRelatedMarketPlaceProduct() async {
    isLoadingRelatedProduct.value = true;
    final apiResponse = await marketPlaceRepository
        .getRelatedMarketPlaceProductById(productId: pId.value);
    isLoadingRelatedProduct.value = false;
    if (apiResponse.isSuccessful) {
      relatedProductList.value = apiResponse.data as List<AllRelatedProducts>;
      relatedProductList.refresh();
    }
  }

  // ─── Product Reviews ──────────────────────────────────
  Future<void> getProductReviews() async {
    final apiResponse =
        await marketPlaceRepository.getProductReviewById(productId: pId.value);
    if (apiResponse.isSuccessful) {
      reviewData.value =
          ReviewData.fromMap(apiResponse.data as Map<String, dynamic>);
      productReviewDetailsList.value = reviewData.value?.review ?? [];
      productReviewDetailsList.refresh();
    }
  }

  // ─── Variant Price Fetch ──────────────────────────────
  Future<void> fetchPriceBasedOnAttributes() async {
    try {
      List<Map<String, String>> filters = selectedAttributes.entries
          .where((entry) => entry.key != 'Color')
          .map((entry) => {'name': entry.key, 'value': entry.value})
          .toList();

      final ApiResponse response =
          await marketPlaceRepository.getProductPriceBasedOnAttributesById(
        productId: pId.value,
        requestData: {
          'color_id': selectedColorId.value,
          'filter': filters,
        },
      );

      if (response.isSuccessful) {
        var variant =
            (response.data as Map<String, dynamic>)['product_variant']?[0];
        if (variant != null) {
          currentPrice.value =
              (variant['sell_price'] as num?)?.toDouble() ?? 0.0;
          originalPrice.value =
              (variant['main_price'] as num?)?.toDouble() ?? 0.0;
          stock.value = variant['stock'] as int? ?? 0;
          selectedProductVariantId.value = variant['_id'] ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error fetching price: $e');
    }
  }

  // ─── Quantity Controls ────────────────────────────────
  void incrementQuantity() {
    if (stock.value > 0 && productQuantity.value < stock.value) {
      productQuantity.value++;
    }
  }

  void decrementQuantity() {
    if (productQuantity.value > 1) {
      productQuantity.value--;
    }
  }

  // ─── View Count Tracking ──────────────────────────────
  Future<void> trackProductView() async {
    await marketPlaceRepository.incrementProductViewCount(
        productId: pId.value);
  }

  // ─── Share Product ────────────────────────────────────
  Future<void> shareProduct() async {
    final p = product.value;
    if (p == null) return;
    final text =
        '${p.productName ?? 'Check out this product'}\n€${currentPrice.value.toStringAsFixed(2)}';
    await SharePlus.instance.share(ShareParams(text: text));
    await marketPlaceRepository.incrementProductShareCount(
        productId: pId.value);
  }

  // ─── Store Follow Toggle ──────────────────────────────
  Future<void> toggleStoreFollow() async {
    final storeId = product.value?.store?.id;
    if (storeId == null) return;
    final response =
        await marketPlaceRepository.toggleStoreFollow(storeId: storeId);
    if (response.isSuccessful) {
      isFollowingStore.value = !isFollowingStore.value;
    }
  }

  // ─── Product Q&A ──────────────────────────────────────
  Future<void> getProductQuestions() async {
    isLoadingQuestions.value = true;
    final response = await marketPlaceRepository.getProductQuestions(
        productId: pId.value);
    isLoadingQuestions.value = false;
    if (response.isSuccessful && response.data is List) {
      questions.value = (response.data as List)
          .map((e) => ProductQuestion.fromMap(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> submitQuestion() async {
    final text = questionTextController.text.trim();
    if (text.isEmpty) return;
    final response = await marketPlaceRepository.askProductQuestion(
      productId: pId.value,
      question: text,
    );
    if (response.isSuccessful) {
      questionTextController.clear();
      getProductQuestions();
    }
  }

  // ─── Quick Message ────────────────────────────────────
  Future<void> sendQuickMessage() async {
    final text = messageTextController.text.trim();
    if (text.isEmpty) return;
    final response = await marketPlaceRepository.sendQuickMessage(
      productId: pId.value,
      message: text,
    );
    if (response.isSuccessful) {
      messageTextController.clear();
      Get.snackbar('Sent', 'Message sent to seller',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ─── Computed Helpers ─────────────────────────────────
  bool get hasDiscount =>
      originalPrice.value > 0 && originalPrice.value > currentPrice.value;

  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((originalPrice.value - currentPrice.value) /
                originalPrice.value) *
            100)
        .round();
  }

  bool get isInStock => stock.value > 0;

  bool get hasVariants {
    final variants = product.value?.productVariant;
    if (variants == null || variants.isEmpty) return false;
    final first = variants.first;
    return (first.attribute != null && first.attribute!.isNotEmpty) ||
        (first.color?.value != null && first.color!.value!.isNotEmpty);
  }

  double get vatInclusivePrice {
    final vat = product.value?.vat ?? 0;
    return currentPrice.value * (1 + vat / 100);
  }
}
