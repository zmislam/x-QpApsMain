import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../repository/cart_repository.dart';

import '../../../../../config/constants/api_constant.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../data/market_place_data.dart';
import '../../../../../models/wallet_summery_model.dart';
import '../../../../../repository/utility_repository.dart';
import '../../../../../services/api_communication.dart';
import '../../marketplace_products/controllers/marketplace_controller.dart';
import '../models/address_book_model.dart';
import '../models/my_cart_model.dart';

class CartController extends GetxController {
  late ApiCommunication _apiCommunication;
  late MarketPlaceData _marketPlaceData;
  Map<String, TextEditingController> couponCodeControllers = {};

  RxBool isLoadingMarketplaceProduct = true.obs;
  RxList<StoreData> storeDetailsList = <StoreData>[].obs;

  MarketplaceController marketplaceController = Get.find();

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
  var appliedCouponText = <String, String>{}.obs; //
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
  RxInt cartCount = 0.obs;

  final CartRepository cartRepository = CartRepository();
  final UtilityRepository utilityRepository = UtilityRepository();

  void updateTotal(double price) {
    subTotal.value = price * productQuantity.value;
  }

  //===============================================Get Cart List ========================================//
  Future<void> getCartDetails() async {
    // Clear the previous product list
    // storeDetailsList.clear();

    debugPrint('Fetching cart details...');

    isLoadingMarketplaceProduct.value = true;
    update();

    final apiResponse = await cartRepository.getCartDetails();

    isLoadingMarketplaceProduct.value = false;
    update();

    if (apiResponse.isSuccessful) {
      final List<dynamic> data = apiResponse.data as List<dynamic>;
      storeDetailsList.value = data.map((e) {
        // final storeId = e['storeId'] ?? '';
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

      debugPrint('Cart Count:::::::::::::::: ${marketplaceController.cartCount.value}::::::::::::::::::::');
      debugPrint('Cart Count:::::::::::::::: ${cartCount.value}::::::::::::::::::::');
      debugPrint('Cart details loaded successfully');
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

      debugPrint('Product Removed  successfully');
    } else {
      debugPrint('Failed to load cart details: ${apiResponse.message}');
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
  //================================= Get Address Book ======================================//

  Future<void> getAddressList() async {
    debugPrint('Fetching address list...');

    try {
      final apiResponse = await utilityRepository.getAllAddressesInList();

      if (apiResponse.isSuccessful) {
        if (apiResponse.data != null) {
          addressList.value = List.from(apiResponse.data as List<MyAddressData>);

          if (addressList.isNotEmpty) {
            setDefaultAddress();
          }

          debugPrint('Address list fetched successfully: ${addressList.length} addresses found.');
        } else {
          debugPrint('No addresses found.');
        }
      } else {
        debugPrint('Failed to fetch address list: ${apiResponse.message}');
      }
    } catch (e) {
      debugPrint('Error fetching address list: $e');
    }
  }

//=================================== Select Address =======================================//
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

//=================================== CheckOut/ Place order =======================================//

  Future<void> placeOrder() async {
    final addressData = selectedAddressId.isNotEmpty
        ? {'address_id': selectedAddressId.value}
        : {
            'address': selectedAddress.value,
            'city': selectedCity.value,
            'ward': selectedWard.value,
            'recipients_name': recipientName.value,
            'recipients_phone_number': contact.value,
            'save_to_address_book': saveAddress.value,
          };

    final orderData = storeDetailsList.expand((store) {
      return store.myProduct?.map((product) {
            return {
              'product_id': product.id,
              'variant_id': product.productVariants?.id,
              'store_id': store.storeId,
              'seller_id': product.userId,
              'sell_main_price': product.productVariants?.mainPrice,
              'sell_price': product.productVariants?.sellPrice,
              'quantity': product.quantity,
              'sub_total_amount': (product.productVariants?.sellPrice ?? 0) * (product.quantity ?? 1),
            };
          }).toList() ??
          [];
    }).toList();

    final storeData = storeDetailsList.map((store) {
      return {
        'store_id': store.storeId,
        'coupon_code': appliedCouponText[store.storeId] ?? '',
        'coupon_amount': (calculateSubTotalForStore(store) - (storeDiscountedSubTotals[store.storeId]?.value ?? calculateSubTotalForStore(store))),
        'delivery_charge': 0,
        'sub_total_amount': calculateSubTotalForStore(store),
        'total_amount': calculateTotalPayable(),
      };
    }).toList();

    final cartIds = storeDetailsList.expand((store) {
      return store.myProduct?.map((product) => product.cartId).where((cartId) => cartId != null).toList() ?? [];
    }).toList();

    final orderPlacementDTOMap = {
      'total_amount': calculateTotalPayable(),
      'order_data': orderData,
      'store_data': storeData,
      'cart_ids': cartIds,
      ...addressData,
    };

    final apiResponse = await cartRepository.placeOrder(requestData: orderPlacementDTOMap);

    if (apiResponse.isSuccessful) {
      Get.back();
      Get.snackbar(
        'Order Placed',
        'Your order has been placed successfully!',
        backgroundColor: PRIMARY_COLOR,
        colorText: Colors.white,
      );
      getCartDetails();
      debugPrint('Order placed successfully.');
    } else {
      Get.snackbar(
        'Error',
        'Failed to place the order: ${apiResponse.message}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('Failed to place the order: ${apiResponse.message}');
    }
  }

  //===============================================Get Wallet Summay ========================================//

  // #┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  //  ┃ TODO:  REMOVE THIS [getWalletSummery] API CALL TO SEPARATE REPOSITORY  ┃
  // #┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> getWalletSummery() async {
    final apiResponse = await _apiCommunication.doGetRequest(responseDataKey: ApiConstant.FULL_RESPONSE, apiEndPoint: 'wallet/getting-wallet-summary', enableLoading: true);
    if (apiResponse.isSuccessful) {
      wallerSummery.value = WalletSummeryModel.fromJson(((apiResponse.data as Map<String, dynamic>)));

      debugPrint('wallet summery value.................${wallerSummery.value}');
    } else {}
  }
  //===================== All Calculation Functions ==============================//
//===================== All Calculation Functions ==============================//
//===================== Store-based Calculation Functions ==============================//

// Calculate subtotal for store
  double calculateSubTotalForStore(StoreData store) {
    return store.discountedSubTotal ??
        store.myProduct?.fold(0.0, (sum, product) {
          return sum! + (product.productVariants?.sellPrice ?? 0) * (product.quantity ?? 1);
        }) ??
        0.0;
  }

// Calculate total price for store (subtotal + tax)
  double calculateTotalForStore(StoreData store) {
    double subTotal = calculateSubTotalForStore(store);
    double tax = calculateTaxForStore(store);
    return subTotal + tax;
  }

// Calculate tax for store (based on percentage)
  double calculateTaxForStore(StoreData store) {
    return store.myProduct?.fold(0.0, (sum, product) {
          double price = (product.productVariants?.sellPrice ?? 0).toDouble();

          double vatPercentage = (product.vat ?? 0) / 100;
          int quantity = product.quantity ?? 1;
          return sum! + (price * vatPercentage * quantity);
        }) ??
        0.0;
  }

//===================== Total Calculation Functions ==============================//

// Calculate the total product price across all stores (subtotal)
  double calculateTotalProductPrice() {
    return storeDetailsList.fold(0.0, (sum, store) {
      return sum + calculateSubTotalForStore(store);
    });
  }

// Method to calculate total discount across all stores
  double calculateTotalDiscount() {
    return storeDetailsList.fold(0.0, (sum, store) {
      double subTotal = calculateSubTotalForStore(store);
      double discountedSubTotal = storeDiscountedSubTotals[store.storeId]?.value ?? subTotal;
      return sum + (subTotal - discountedSubTotal);
    });
  }

// Method to calculate total tax across all stores (based on percentage)
  double calculateTotalTax() {
    return storeDetailsList.fold(0.0, (sum, store) {
      return sum + calculateTaxForStore(store);
    });
  }

// Method to calculate the total payable amount across all stores
  double calculateTotalPayable() {
    return storeDetailsList.fold(0.0, (sum, store) {
      double subTotal = storeDiscountedSubTotals[store.storeId]?.value ?? calculateSubTotalForStore(store);
      double tax = calculateTaxForStore(store);
      totalPayable = sum + subTotal + tax;
      return totalPayable;
    });
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    _marketPlaceData = MarketPlaceData();

    //! API CALL COMMENTED OUT ----------------------
    // getCartDetails();
    // getAddressList();
    // setDefaultAddress();

    super.onInit();
  }
}
