import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import '../../../../../models/api_response.dart';
import '../../../../../repository/cart_repository.dart';
import '../../../../../config/constants/api_constant.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../data/market_place_data.dart';
import '../../../../../models/wallet_summery_model.dart';
import '../../../../../repository/utility_repository.dart';
import '../../../../../services/api_communication.dart';
import '../../../../../services/wallet_management_service.dart';
import '../../../../../utils/wallet_util/improved_permit_signer.dart';
import '../../marketplace_products/controllers/marketplace_controller.dart';
import '../models/address_book_model.dart';
import '../models/my_cart_model.dart';

enum CheckoutStep { cartReview, address, payment }

enum PaymentMethod { wallet, stripe, qpeu, qpg, earnings }

class CartController extends GetxController {
  late ApiCommunication _apiCommunication;
  late MarketPlaceData _marketPlaceData;
  Map<String, TextEditingController> couponCodeControllers = {};

  RxBool isLoadingMarketplaceProduct = true.obs;
  RxList<StoreData> storeDetailsList = <StoreData>[].obs;

  MarketplaceController get marketplaceController =>
      Get.find<MarketplaceController>();

  // ── Checkout step ──
  Rx<CheckoutStep> currentStep = CheckoutStep.cartReview.obs;
  Rx<PaymentMethod> selectedPaymentMethod = PaymentMethod.wallet.obs;
  RxBool isPlacingOrder = false.obs;

  // ── Price state ──
  var subTotal = 102.0.obs;
  var shipping = 'Free'.obs;
  var discount = 60.0.obs;
  var tax = 14.0.obs;
  var total = 1030.97.obs;
  RxString couponCode = ''.obs;
  var isCouponApplied = <String, bool>{}.obs;

  RxInt productQuantity = 1.obs;
  var selectedAddressId = ''.obs;

  var recipientName = ''.obs;
  var phoneNumber = ''.obs;
  var saveAddress = false.obs;
  var storeDiscountedSubTotals = <String, RxDouble>{}.obs;
  var appliedCouponText = <String, String>{}.obs;
  RxList<MyAddressData> addressList = <MyAddressData>[].obs;
  var wallerSummery = WalletSummeryModel().obs;
  double totalPayable = 0.00;

  RxString selectedAddress = ''.obs;
  RxString contact = ''.obs;
  RxBool showAddressBook = false.obs;
  RxBool showAddressForm = false.obs;
  var selectedWard = ''.obs;
  var selectedCity = ''.obs;
  var selectedCountry = ''.obs;
  var selectedState = ''.obs;
  var selectedZipCode = ''.obs;
  RxInt cartCount = 0.obs;

  // ── Billing address ──
  RxBool sameAsShipping = true.obs;
  RxString billingAddressId = ''.obs;
  RxString billingAddress = ''.obs;
  RxString billingCountry = ''.obs;
  RxString billingState = ''.obs;
  RxString billingCity = ''.obs;
  RxString billingZipCode = ''.obs;
  RxString billingRecipientName = ''.obs;
  RxString billingPhone = ''.obs;

  // ── Geo-cascading dropdown data (shipping) ──
  RxList<String> countryList = <String>[].obs;
  RxList<String> stateList = <String>[].obs;
  RxList<String> cityList = <String>[].obs;
  RxBool isLoadingCountries = false.obs;
  RxBool isLoadingStates = false.obs;
  RxBool isLoadingCities = false.obs;

  // ── Geo-cascading dropdown data (billing) ──
  RxList<String> billingCountryList = <String>[].obs;
  RxList<String> billingStateList = <String>[].obs;
  RxList<String> billingCityList = <String>[].obs;
  RxBool isLoadingBillingCountries = false.obs;
  RxBool isLoadingBillingStates = false.obs;
  RxBool isLoadingBillingCities = false.obs;

  // ── Earning balance ──
  RxDouble earningBalance = 0.0.obs;
  RxBool isLoadingEarningBalance = false.obs;

  final CartRepository cartRepository = CartRepository();
  final UtilityRepository utilityRepository = UtilityRepository();

  // ══════════════════════════════════════════════════════════════════════════
  // STEP NAVIGATION
  // ══════════════════════════════════════════════════════════════════════════

  int get stepIndex => currentStep.value.index;

  void goToStep(CheckoutStep step) {
    currentStep.value = step;
  }

  void nextStep() {
    if (currentStep.value == CheckoutStep.cartReview) {
      if (storeDetailsList.isEmpty) return;
      currentStep.value = CheckoutStep.address;
    } else if (currentStep.value == CheckoutStep.address) {
      if (selectedAddress.value.isEmpty && selectedAddressId.value.isEmpty) {
        Get.snackbar('Address Required', 'Please select or add a shipping address',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      currentStep.value = CheckoutStep.payment;
      getWalletSummery();
      fetchEarningBalance();
    }
  }

  void previousStep() {
    if (currentStep.value == CheckoutStep.payment) {
      currentStep.value = CheckoutStep.address;
    } else if (currentStep.value == CheckoutStep.address) {
      currentStep.value = CheckoutStep.cartReview;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CART OPERATIONS
  // ══════════════════════════════════════════════════════════════════════════

  void updateTotal(double price) {
    subTotal.value = price * productQuantity.value;
  }

  //===============================================Get Cart List ========================================//
  Future<void> getCartDetails() async {
    debugPrint('Fetching cart details...');

    isLoadingMarketplaceProduct.value = true;
    update();

    final apiResponse = await cartRepository.getCartDetails();

    isLoadingMarketplaceProduct.value = false;
    update();

    if (apiResponse.isSuccessful) {
      final List<dynamic> data = apiResponse.data as List<dynamic>;
      storeDetailsList.value = data.map((e) {
        return StoreData.fromMap(e);
      }).toList();

      for (var store in storeDetailsList) {
        if (!couponCodeControllers.containsKey(store.storeId)) {
          couponCodeControllers[store.storeId ?? ''] = TextEditingController();
        }
      }

      marketplaceController.cartCount.value = storeDetailsList.fold<int>(
        0,
        (sum, store) => sum + (store.myProduct?.length ?? 0),
      );
      cartCount.value = marketplaceController.cartCount.value;
    } else {
      debugPrint('Failed to load cart details: ${apiResponse.message}');
    }
  }

  //===============================================Delete Cart From List ========================================//
  Future<void> deleteCartItem({String? cartId}) async {
    isLoadingMarketplaceProduct.value = true;
    update();

    final apiResponse = await cartRepository.removeProductFromOnlineCart(cartId: cartId);

    isLoadingMarketplaceProduct.value = false;
    update();

    if (apiResponse.isSuccessful) {
      getCartDetails();
      marketplaceController.decrementCartCount();
      Get.snackbar(
        'Product Removed',
        'Item removed from cart successfully!',
        backgroundColor: PRIMARY_COLOR,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to remove item from cart',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  //=====================================Apply Coupon===========================================//
  void applyCouponForStore(String storeId) async {
    String enteredCouponCode = couponCodeControllers[storeId]?.text.trim() ?? '';

    if (appliedCouponText[storeId] == enteredCouponCode) {
      Get.snackbar(
        'Warning',
        'Coupon already applied!',
        backgroundColor: Colors.yellow,
        colorText: Colors.black,
      );
      return;
    }

    final StoreData? store = storeDetailsList.firstWhereOrNull((store) => store.storeId == storeId);
    if (store == null) {
      Get.snackbar(
        'Error',
        'Store not found!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final apiResponse = await cartRepository.applyCouponOnAProductFrom(
      storeId: storeId,
      enteredCouponCode: enteredCouponCode,
      subTotal: calculateSubTotalForStore(store),
    );

    if (apiResponse.isSuccessful) {
      double discountSubTotal = (apiResponse.data as Map<String, dynamic>)['discount_sub_total_amount']?.toDouble() ?? 0.0;

      storeDiscountedSubTotals[storeId] = discountSubTotal.obs;
      isCouponApplied[storeId] = true;
      appliedCouponText[storeId] = enteredCouponCode;
      couponCodeControllers[storeId]?.clear();
    } else {
      debugPrint('Error: ${apiResponse.message}');
    }
  }

//=====================================Update Product Quantity api===========================================//
  void updateCartProductQuantity({String? cartId, int? quantity}) async {
    final apiResponse = await cartRepository.updateTheQuantityOfProductInCart(
      cartId: cartId,
      quantity: quantity,
    );

    if (apiResponse.isSuccessful) {
      getCartDetails();
    } else {
      debugPrint('Error: ${apiResponse.message}');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ADDRESS OPERATIONS
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> getAddressList() async {
    try {
      final apiResponse = await utilityRepository.getAllAddressesInList();

      if (apiResponse.isSuccessful) {
        if (apiResponse.data != null) {
          addressList.value = List.from(apiResponse.data as List<MyAddressData>);
          if (addressList.isNotEmpty) {
            setDefaultAddress();
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching address list: $e');
    }
  }

  void setDefaultAddress() {
    if (addressList.isNotEmpty && selectedAddress.isEmpty) {
      selectAddress(addressList[0]);
    }
  }

  void selectAddress(MyAddressData address) {
    selectedAddress.value = address.address ?? 'No Address';
    selectedAddressId.value = address.id ?? '';
    contact.value = address.recipientsPhoneNumber ?? '';
    selectedWard.value = address.ward ?? '';
    selectedCity.value = address.city ?? '';
  }

  Future<void> deleteAddressFromList(String addressId) async {
    final apiResponse = await cartRepository.deleteAddress(addressId);
    if (apiResponse.isSuccessful) {
      addressList.removeWhere((a) => a.id == addressId);
      if (selectedAddressId.value == addressId) {
        selectedAddressId.value = '';
        selectedAddress.value = '';
        contact.value = '';
        if (addressList.isNotEmpty) {
          selectAddress(addressList[0]);
        }
      }
      Get.snackbar('Deleted', 'Address removed successfully',
          backgroundColor: PRIMARY_COLOR, colorText: Colors.white);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GEO-CASCADING (SHIPPING)
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> fetchCountries() async {
    if (countryList.isNotEmpty) return; // Already fetched
    isLoadingCountries.value = true;
    try {
      final apiResponse = await cartRepository.getCountries();
      if (apiResponse.isSuccessful && apiResponse.data != null) {
        final List<dynamic> data = apiResponse.data is List ? apiResponse.data as List : [];
        countryList.value = data.map((e) => (e['name'] ?? '').toString()).where((n) => n.isNotEmpty).toList();
      }
    } catch (e) {
      debugPrint('Error fetching countries: $e');
    } finally {
      isLoadingCountries.value = false;
    }
  }

  Future<void> fetchStates(String country) async {
    stateList.clear();
    cityList.clear();
    selectedState.value = '';
    selectedCity.value = '';
    if (country.isEmpty) return;

    isLoadingStates.value = true;
    try {
      final apiResponse = await cartRepository.getStates(country);
      if (apiResponse.isSuccessful && apiResponse.data != null) {
        final data = apiResponse.data;
        if (data is Map && data['states'] != null) {
          final List<dynamic> states = data['states'] is List ? data['states'] : [];
          stateList.value = states.map((e) {
            if (e is Map) return (e['name'] ?? '').toString();
            return e.toString();
          }).where((n) => n.isNotEmpty).toList();
        } else if (data is List) {
          stateList.value = data.map((e) => e.toString()).where((n) => n.isNotEmpty).toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching states: $e');
    } finally {
      isLoadingStates.value = false;
    }
  }

  Future<void> fetchCities(String country, String state) async {
    cityList.clear();
    selectedCity.value = '';
    if (country.isEmpty || state.isEmpty) return;

    isLoadingCities.value = true;
    try {
      final apiResponse = await cartRepository.getCities(country, state);
      if (apiResponse.isSuccessful && apiResponse.data != null) {
        final data = apiResponse.data;
        if (data is List) {
          cityList.value = data.map((e) => e.toString()).where((n) => n.isNotEmpty).toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching cities: $e');
    } finally {
      isLoadingCities.value = false;
    }
  }

  void onCountryChanged(String? country) {
    if (country == null) return;
    selectedCountry.value = country;
    fetchStates(country);
  }

  void onStateChanged(String? state) {
    if (state == null) return;
    selectedState.value = state;
    fetchCities(selectedCountry.value, state);
  }

  void onCityChanged(String? city) {
    if (city == null) return;
    selectedCity.value = city;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GEO-CASCADING (BILLING)
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> fetchBillingCountries() async {
    if (billingCountryList.isNotEmpty) return;
    isLoadingBillingCountries.value = true;
    try {
      final apiResponse = await cartRepository.getCountries();
      if (apiResponse.isSuccessful && apiResponse.data != null) {
        final List<dynamic> data =
            apiResponse.data is List ? apiResponse.data as List : [];
        billingCountryList.value = data
            .map((e) => (e['name'] ?? '').toString())
            .where((n) => n.isNotEmpty)
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching billing countries: $e');
    } finally {
      isLoadingBillingCountries.value = false;
    }
  }

  Future<void> fetchBillingStates(String country) async {
    billingStateList.clear();
    billingCityList.clear();
    billingState.value = '';
    billingCity.value = '';
    if (country.isEmpty) return;

    isLoadingBillingStates.value = true;
    try {
      final apiResponse = await cartRepository.getStates(country);
      if (apiResponse.isSuccessful && apiResponse.data != null) {
        final data = apiResponse.data;
        if (data is Map && data['states'] != null) {
          final List<dynamic> states =
              data['states'] is List ? data['states'] : [];
          billingStateList.value = states.map((e) {
            if (e is Map) return (e['name'] ?? '').toString();
            return e.toString();
          }).where((n) => n.isNotEmpty).toList();
        } else if (data is List) {
          billingStateList.value = data
              .map((e) => e.toString())
              .where((n) => n.isNotEmpty)
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching billing states: $e');
    } finally {
      isLoadingBillingStates.value = false;
    }
  }

  Future<void> fetchBillingCities(String country, String state) async {
    billingCityList.clear();
    billingCity.value = '';
    if (country.isEmpty || state.isEmpty) return;

    isLoadingBillingCities.value = true;
    try {
      final apiResponse = await cartRepository.getCities(country, state);
      if (apiResponse.isSuccessful && apiResponse.data != null) {
        final data = apiResponse.data;
        if (data is List) {
          billingCityList.value = data
              .map((e) => e.toString())
              .where((n) => n.isNotEmpty)
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching billing cities: $e');
    } finally {
      isLoadingBillingCities.value = false;
    }
  }

  void onBillingCountryChanged(String? country) {
    if (country == null) return;
    billingCountry.value = country;
    fetchBillingStates(country);
  }

  void onBillingStateChanged(String? state) {
    if (state == null) return;
    billingState.value = state;
    fetchBillingCities(billingCountry.value, state);
  }

  void onBillingCityChanged(String? city) {
    if (city == null) return;
    billingCity.value = city;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ORDER DATA BUILDERS
  // ══════════════════════════════════════════════════════════════════════════

  Map<String, dynamic> _buildAddressData() {
    final Map<String, dynamic> addressData = selectedAddressId.isNotEmpty
        ? {'address_id': selectedAddressId.value}
        : {
            'address': selectedAddress.value,
            'country': selectedCountry.value,
            'state': selectedState.value,
            'city': selectedCity.value,
            'ward': selectedWard.value,
            'zip_code': selectedZipCode.value,
            'recipients_name': recipientName.value,
            'recipients_phone_number': contact.value,
            'save_to_address_book': saveAddress.value,
          };

    if (sameAsShipping.value) {
      addressData['same_address'] = true;
    } else {
      if (billingAddressId.isNotEmpty) {
        addressData['billing_address_id'] = billingAddressId.value;
      } else {
        addressData['billing_address'] = billingAddress.value;
        addressData['billing_country'] = billingCountry.value;
        addressData['billing_state'] = billingState.value;
        addressData['billing_city'] = billingCity.value;
        addressData['billing_recipient_name'] = billingRecipientName.value;
        addressData['billing_phone_number'] = billingPhone.value;
      }
    }

    return addressData;
  }

  List<Map<String, dynamic>> _buildOrderData() {
    return storeDetailsList.expand((store) {
      return store.myProduct?.map((product) {
            return <String, dynamic>{
              'product_id': product.id,
              'variant_id': product.productVariants?.id,
              'store_id': store.storeId,
              'seller_id': product.userId,
              'sell_main_price': product.productVariants?.mainPrice,
              'sell_price': product.productVariants?.sellPrice,
              'quantity': product.quantity,
              'sub_total_amount':
                  (product.productVariants?.sellPrice ?? 0) *
                      (product.quantity ?? 1),
            };
          }).toList() ??
          <Map<String, dynamic>>[];
    }).toList();
  }

  List<Map<String, dynamic>> _buildStoreData() {
    return storeDetailsList.map((store) {
      return {
        'store_id': store.storeId,
        'coupon_code': appliedCouponText[store.storeId] ?? '',
        'coupon_amount': (calculateSubTotalForStore(store) -
            (storeDiscountedSubTotals[store.storeId]?.value ??
                calculateSubTotalForStore(store))),
        'delivery_charge': 0,
        'sub_total_amount': calculateSubTotalForStore(store),
        'vat': calculateTaxForStore(store),
        'total_amount': calculateTotalPayable(),
      };
    }).toList();
  }

  List<String?> _buildCartIds() {
    return storeDetailsList.expand((store) {
      return store.myProduct
              ?.map((product) => product.cartId)
              .where((cartId) => cartId != null)
              .toList() ??
          <String?>[];
    }).toList();
  }

  Map<String, dynamic> _buildFullOrderPayload() {
    return {
      'total_amount': calculateTotalPayable(),
      'order_data': _buildOrderData(),
      'store_data': _buildStoreData(),
      'cart_ids': _buildCartIds(),
      ..._buildAddressData(),
    };
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CHECKOUT / PLACE ORDER
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> placeOrder() async {
    isPlacingOrder.value = true;

    try {
      switch (selectedPaymentMethod.value) {
        case PaymentMethod.wallet:
          await _placeOrderWithWallet();
          break;
        case PaymentMethod.stripe:
          await _placeOrderWithStripe();
          break;
        case PaymentMethod.qpeu:
          await _placeOrderWithQPEU();
          break;
        case PaymentMethod.qpg:
          await _placeOrderWithQPG();
          break;
        case PaymentMethod.earnings:
          await _placeOrderWithEarnings();
          break;
      }
    } finally {
      isPlacingOrder.value = false;
    }
  }

  Future<void> _placeOrderWithWallet() async {
    final payload = _buildFullOrderPayload();
    final apiResponse = await cartRepository.placeOrder(requestData: payload);

    if (apiResponse.isSuccessful) {
      _handleOrderSuccess('Order placed successfully using QP Balance!');
    } else {
      _handleOrderError(apiResponse.message ?? 'Failed to place order');
    }
  }

  Future<void> _placeOrderWithStripe() async {
    // Step 1: Create payment intent on server
    final orderPayload = _buildFullOrderPayload();
    final requestData = {
      'amount': calculateTotalPayable(),
      'orderData': orderPayload,
    };

    final apiResponse = await cartRepository.createStripeCheckoutIntent(
        requestData: requestData);

    if (!apiResponse.isSuccessful) {
      _handleOrderError(apiResponse.message ?? 'Stripe checkout failed');
      return;
    }

    final data = apiResponse.data as Map<String, dynamic>;
    final clientSecret = data['clientSecret'] as String?;
    final paymentIntentId = data['paymentIntentId'] as String?;

    if (clientSecret == null || paymentIntentId == null) {
      _handleOrderError('Invalid payment response from server');
      return;
    }

    // Step 2: Initialize and present Stripe PaymentSheet
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          allowsDelayedPaymentMethods: true,
          merchantDisplayName: 'Quantum Possibility',
          googlePay: const PaymentSheetGooglePay(
            testEnv: true,
            currencyCode: 'EUR',
            merchantCountryCode: 'IE',
          ),
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'IE',
          ),
          returnURL: '${ApiConstant.SERVER_IP_PORT}/api/market-place/order/stripe-checkout-success',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        _handleOrderError('Payment was cancelled');
      } else {
        _handleOrderError(e.error.localizedMessage ?? 'Payment failed');
      }
      return;
    }

    // Step 3: Confirm payment on server and create order
    final confirmResponse =
        await cartRepository.confirmStripePaymentMobile(requestData: {
      'paymentIntentId': paymentIntentId,
      'clientSecret': clientSecret,
    });

    if (confirmResponse.isSuccessful) {
      _handleOrderSuccess('Order placed successfully via Stripe!');
    } else {
      _handleOrderError(
          confirmResponse.message ?? 'Order creation failed after payment');
    }
  }

  // ── Token addresses for gasless checkout (Arbitrum Sepolia) ──
  static const String _qpeuTokenAddress =
      '0xF14CB79966F6b40092D324720Fe020b85228A7A0';
  static const String _qpgTokenAddress =
      '0x2c199a1082d4fe9c75f5650e8fa18a26ea043c99';
  static const String _qpeuTokenName = 'Quantum Possibilities Euro';
  static const String _qpgTokenName = 'Quantum Possibilities Gold Coin';
  static const int _chainId = 421614; // Arbitrum Sepolia

  Future<void> _placeOrderWithQPEU() async {
    await _placeOrderWithGaslessToken(
      tokenAddress: _qpeuTokenAddress,
      tokenName: _qpeuTokenName,
      checkoutCall: (data) =>
          cartRepository.gaslessCheckoutQPEU(requestData: data),
      successLabel: 'QPEU',
      errorLabel: 'QPEU checkout failed',
    );
  }

  Future<void> _placeOrderWithQPG() async {
    await _placeOrderWithGaslessToken(
      tokenAddress: _qpgTokenAddress,
      tokenName: _qpgTokenName,
      checkoutCall: (data) =>
          cartRepository.gaslessCheckoutQPG(requestData: data),
      successLabel: 'QPG',
      errorLabel: 'QPG checkout failed',
    );
  }

  Future<void> _placeOrderWithGaslessToken({
    required String tokenAddress,
    required String tokenName,
    required Future<ApiResponse> Function(Map<String, dynamic>) checkoutCall,
    required String successLabel,
    required String errorLabel,
  }) async {
    // Step 1: Check wallet is connected
    final walletService = Get.find<WalletManagementService>();
    final walletAddress = walletService.myCryptoAccountAddress.value;

    if (walletAddress.isEmpty) {
      _handleOrderError(
          'Please connect your crypto wallet first from Wallet settings');
      return;
    }

    // Step 2: Fetch admin wallet address (the spender)
    final adminResponse = await cartRepository.getAdminWalletAddress();
    if (!adminResponse.isSuccessful) {
      _handleOrderError('Failed to fetch payment configuration');
      return;
    }
    final adminData = adminResponse.data as Map<String, dynamic>;
    final spenderAddress = adminData['adminAddress'] as String?;
    if (spenderAddress == null || spenderAddress.isEmpty) {
      _handleOrderError('Payment spender address not configured');
      return;
    }

    // Step 3: Sign EIP-2612 permit
    final amount = calculateTotalPayable();
    final amountInWei =
        BigInt.from((amount * 1e18).toInt()); // 18 decimals
    final deadline = BigInt.from(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600); // 1 hour

    PermitSignatureResult permitResult;
    try {
      final permitSigner = ImprovedPermitSignature(
        appKit: walletService.appKitModal,
        web3Client: walletService.ethProvider,
      );

      permitResult = await permitSigner.signPermitWithValidation(
        tokenName: tokenName,
        version: '1',
        chainId: _chainId,
        verifyingContract: tokenAddress,
        owner: walletAddress,
        spender: spenderAddress,
        value: amountInWei,
        deadline: deadline,
      );
    } catch (e) {
      _handleOrderError('Permit signing failed: ${e.toString()}');
      return;
    }

    // Step 4: Call gasless checkout API
    final orderPayload = _buildFullOrderPayload();
    final requestData = {
      'walletAddress': walletAddress,
      'permitSignature': permitResult.signature,
      'deadline': deadline.toInt(),
      'amount': amount,
      'orderData': orderPayload,
    };

    final apiResponse = await checkoutCall(requestData);

    if (apiResponse.isSuccessful) {
      final data = apiResponse.data as Map<String, dynamic>;
      _handleOrderSuccess(
          'Order placed with $successLabel! TxHash: ${data['txHash'] ?? ''}');
    } else {
      _handleOrderError(apiResponse.message ?? errorLabel);
    }
  }

  Future<void> _placeOrderWithEarnings() async {
    final amount = calculateTotalPayable();

    // Check sufficient earning balance
    if (earningBalance.value < amount) {
      _handleOrderError(
          'Insufficient earning balance. Available: €${earningBalance.value.toStringAsFixed(2)}, Required: €${amount.toStringAsFixed(2)}');
      return;
    }

    // Step 1: Deduct from earning balance
    final itemCount = storeDetailsList.fold<int>(
        0, (sum, store) => sum + (store.myProduct?.length ?? 0));
    final deductResponse =
        await cartRepository.payWithEarningBalance(requestData: {
      'amount': amount,
      'purpose': 'product_purchase',
      'metadata': {'description': 'Product purchase - $itemCount items'},
    });

    if (!deductResponse.isSuccessful) {
      _handleOrderError(
          deductResponse.message ?? 'Failed to deduct earning balance');
      return;
    }

    final deductData = deductResponse.data as Map<String, dynamic>;
    final innerData = deductData['data'] as Map<String, dynamic>?;
    final transactionId = innerData?['transaction_id'] as String?;

    if (transactionId == null || transactionId.isEmpty) {
      _handleOrderError('Failed to get payment transaction ID');
      return;
    }

    // Step 2: Create order with the transaction ID
    final orderPayload = _buildFullOrderPayload();
    final apiResponse =
        await cartRepository.checkoutWithEarning(requestData: {
      'transactionId': transactionId,
      'orderData': orderPayload,
      'paymentMethod': 'earning_balance',
    });

    if (apiResponse.isSuccessful) {
      _handleOrderSuccess('Order placed using Earning Balance!');
    } else {
      _handleOrderError(apiResponse.message ?? 'Earnings checkout failed');
    }
  }

  void _handleOrderSuccess(String message) {
    Get.back();
    Get.snackbar('Order Placed', message,
        backgroundColor: PRIMARY_COLOR, colorText: Colors.white);
    getCartDetails();
    currentStep.value = CheckoutStep.cartReview;
  }

  void _handleOrderError(String message) {
    Get.snackbar('Error', message,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  //===============================================Get Wallet Summary ========================================//

  Future<void> getWalletSummery() async {
    final apiResponse = await _apiCommunication.doGetRequest(responseDataKey: ApiConstant.FULL_RESPONSE, apiEndPoint: 'wallet/getting-wallet-summary', enableLoading: true);
    if (apiResponse.isSuccessful) {
      wallerSummery.value = WalletSummeryModel.fromJson(((apiResponse.data as Map<String, dynamic>)));
    }
  }

  Future<void> fetchEarningBalance() async {
    isLoadingEarningBalance.value = true;
    final apiResponse = await cartRepository.getEarningPaymentBalance();
    if (apiResponse.isSuccessful) {
      final data = apiResponse.data as Map<String, dynamic>;
      final balanceData = data['data'] as Map<String, dynamic>?;
      earningBalance.value =
          (balanceData?['available_balance'] ?? 0).toDouble();
    }
    isLoadingEarningBalance.value = false;
  }

  //===================== All Calculation Functions ==============================//

  double calculateSubTotalForStore(StoreData store) {
    return store.discountedSubTotal ??
        store.myProduct?.fold(0.0, (sum, product) {
          return sum! + (product.productVariants?.sellPrice ?? 0) * (product.quantity ?? 1);
        }) ??
        0.0;
  }

  double calculateTotalForStore(StoreData store) {
    double subTotal = calculateSubTotalForStore(store);
    double tax = calculateTaxForStore(store);
    return subTotal + tax;
  }

  double calculateTaxForStore(StoreData store) {
    return store.myProduct?.fold(0.0, (sum, product) {
          double price = (product.productVariants?.sellPrice ?? 0).toDouble();
          double vatPercentage = (product.vat ?? 0) / 100;
          int quantity = product.quantity ?? 1;
          return sum! + (price * vatPercentage * quantity);
        }) ??
        0.0;
  }

  double calculateTotalProductPrice() {
    return storeDetailsList.fold(0.0, (sum, store) {
      return sum + calculateSubTotalForStore(store);
    });
  }

  double calculateTotalDiscount() {
    return storeDetailsList.fold(0.0, (sum, store) {
      double subTotal = calculateSubTotalForStore(store);
      double discountedSubTotal = storeDiscountedSubTotals[store.storeId]?.value ?? subTotal;
      return sum + (subTotal - discountedSubTotal);
    });
  }

  double calculateTotalTax() {
    return storeDetailsList.fold(0.0, (sum, store) {
      return sum + calculateTaxForStore(store);
    });
  }

  double calculateTotalPayable() {
    return storeDetailsList.fold(0.0, (sum, store) {
      double subTotal = storeDiscountedSubTotals[store.storeId]?.value ?? calculateSubTotalForStore(store);
      double tax = calculateTaxForStore(store);
      totalPayable = sum + subTotal + tax;
      return totalPayable;
    });
  }

  double calculateTotalShipping() {
    return storeDetailsList.fold(0.0, (sum, store) {
      return sum + (store.myProduct?.first.shippingCharge ?? 0).toDouble();
    });
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    _marketPlaceData = MarketPlaceData();
    super.onInit();
  }
}
