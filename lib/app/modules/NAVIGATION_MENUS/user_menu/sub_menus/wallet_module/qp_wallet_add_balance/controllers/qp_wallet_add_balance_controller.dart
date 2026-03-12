import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import '../../../../../../../routes/app_pages.dart';

import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../models/card_detail_model.dart';
import '../../../../../../../repository/wallet_repository.dart';
import '../../../../../../../services/wallet_management_service.dart';
import '../../../../../../../utils/snackbar.dart';

class QpWalletAddBalanceController extends GetxController
    with WidgetsBindingObserver {
  final WalletRepository walletRepository = WalletRepository();
  final WalletManagementService walletManagementService =
      Get.find<WalletManagementService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  Rx<CardDetailsModel?> selectedCard = Rx(null);

  // @ FLAG FOR REFRESH
  bool needRefresh = false;

  // ! CONST URL REMOVE LATER
  String returnUrl =
      '${ApiConstant.SERVER_IP}:82/api/wallet/payment-validation';
  String merchantsDisplayName = 'Quantum Possibility';

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  MAKE PAYMENT FOR ADDING BALANCE                                       ┃
  // ?┃  SEND PAYMENT REQUEST AND VALIDATE THE COMPLETION                      ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Future<bool> makePaymentForAddingBalance() async {
    Map<String, dynamic>? paymentIndentData;

    paymentIndentData = await walletRepository.createPaymentIntent(
        amount: amountController.text);
    if (paymentIndentData['clientSecret'] != null) {
      try {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIndentData['clientSecret'],
            allowsDelayedPaymentMethods: true,
            googlePay: const PaymentSheetGooglePay(
                // Currency and country code is according to India
                testEnv: true,
                currencyCode: 'USD',
                merchantCountryCode: 'US'),
            returnURL: returnUrl,
            merchantDisplayName: merchantsDisplayName,
          ),
        );

        // $ ----------------------------------------------------------------------------------

        await Stripe.instance.presentPaymentSheet();
        final response = await walletRepository.validatePayment(
            paymentIntentId: paymentIndentData['indentId'],
            clientSecret: paymentIndentData['clientSecret']);

        if (response.isSuccessful) {
          Map<String, dynamic> responseBody =
              response.data as Map<String, dynamic>;
          final userAction =
              await walletManagementService.validateAddBalancePayment(
            requestId: responseBody['requestId'],
            signature: responseBody['signature'],
            amount: responseBody['amount'],
            isUpdate: false,
          );
          if (userAction != null) {
            showSuccessSnackkbar(message: 'Added balance successfully');
          } else {
            showErrorSnackkbar(message: 'Transaction was rejected');
          }
          return true;
        } else {
          showErrorSnackkbar(
              message: 'Balance addition failed, Please try again');
          return false;
        }
      } catch (e) {
        debugPrint('STRIPE PAYMENT FAILED ------ FROM ADD BALANCE CONTROLLER');
        debugPrint('$e');
        return false;
      }
    }
    return false;
  }

  // $ VALIDATE AND SEND PAYMENT

  Future<void> validateFormAndSendPayment() async {
    if (formKey.currentState!.validate()) {
      await makePaymentForAddingBalance().then(
        (value) {
          if (value) {
            amountController.clear();
            selectedCard.value = null;
            needRefresh = true;
            Get.back();
          }
        },
      );
    }
  }

  void goToAddCardPage() {
    Get.toNamed(Routes.QP_WALLET_PAYMENT_SETTINGS);
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃ CALCULATE COMMISSION AND RECEIVABLE                                   ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  RxString commissionPercent = ''.obs;
  RxString commissionAmount = ''.obs;
  RxString receivableAmount = ''.obs;

  Future<void> calculate() async {
    try {
      if (amountController.text.isEmpty ||
          amountController.text.contains('-')) {
        final data = num.parse(amountController.text.toString());
        if (data <= 0) {
          commissionPercent.value = '';
          commissionAmount.value = '';
          receivableAmount.value = '';
        }
      }

      int amount = int.parse(amountController.text);

      final percent =
          await walletManagementService.getMintingFeeForRetailersInPercentage();
      commissionPercent.value = '$percent%';
      final cAmount =
          walletManagementService.calculateCommission(percent, amount);
      commissionAmount.value = '\$${cAmount.toStringAsFixed(3)}';
      receivableAmount.value = '\$${(amount - cAmount).toStringAsFixed(3)}';
    } catch (error) {
      commissionPercent.value = '';
      commissionAmount.value = '';
      receivableAmount.value = '';
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  STATE FUNCTIONS                                                       ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  @override
  void onInit() {
    walletManagementService.getAllUserCards(forcePull: true);
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    if (needRefresh) {
      walletManagementService.getAllDataFromSummaryAndTransaction();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       debugPrint('🟢 App in Foreground');
  //
  //       Future.delayed(const Duration(milliseconds: 200), () {
  //         update(); // or trigger any Rx value
  //       });
  //       break;
  //     case AppLifecycleState.inactive:
  //       debugPrint('⚪ App is Inactive');
  //       break;
  //     case AppLifecycleState.paused:
  //       debugPrint('🔴 App in Background');
  //       break;
  //     case AppLifecycleState.detached:
  //       debugPrint('⚫ App Detached');
  //       break;
  //     case AppLifecycleState.hidden:
  //       debugPrint('⚫ App hidden');
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }
}
