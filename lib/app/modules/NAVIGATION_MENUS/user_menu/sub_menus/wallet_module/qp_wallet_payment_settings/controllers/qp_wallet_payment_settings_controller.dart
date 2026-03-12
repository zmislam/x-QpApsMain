import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/snackbar.dart';

import '../../../../../../../repository/wallet_repository.dart';
import '../../../../../../../services/wallet_management_service.dart';

class QpWalletPaymentSettingsController extends GetxController {
  final WalletRepository walletRepository = WalletRepository();
  final WalletManagementService walletManagementService =
      Get.find<WalletManagementService>();

  final cardNameHolderController = TextEditingController();
  final cardNumberController = TextEditingController();
  final cardExpiryController = TextEditingController();
  final cardCVVController = TextEditingController();
  final postCodeController = TextEditingController();
  final selectedCountryController = TextEditingController();

  RxString cardExpDate = ''.obs;

  RxBool is_default_payment = false.obs;

  final formKey = GlobalKey<FormState>();

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  ADD CARD                                                              ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> addCard() async {
    if (formKey.currentState!.validate()) {
      bool status = await walletRepository.addCard(
        holderName: cardNameHolderController.text,
        cardNumber: cardNumberController.text,
        expiry: cardExpDate.value,
        country: selectedCountryController.text,
        cvc: cardCVVController.text,
        postalCode: postCodeController.text,
        isDefault: is_default_payment.value,
      );

      if (status) {
        is_default_payment.value = false;
        cardExpDate.value = '';
        cardNameHolderController.clear();
        cardNumberController.clear();
        cardExpiryController.clear();
        cardCVVController.clear();
        postCodeController.clear();
        selectedCountryController.clear();

        walletManagementService.getAllUserCards(forcePull: true);
        showSuccessSnackkbar(message: 'Card added Successfully');
      } else {
        showSuccessSnackkbar(message: 'Please try again');
      }
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  SET DEFAULT CARD                                                      ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Future<void> setDefaultCard(
      {required String cardId, required bool isForDefaultPayment}) async {
    bool status = await walletRepository.setDefaultCard(
        cardId: cardId, isDefault: isForDefaultPayment);
    if (status) {
      showSuccessSnackkbar(message: 'Card Set as default Successfully');
      walletManagementService.getAllUserCards(forcePull: true);
    } else {
      showSuccessSnackkbar(message: 'Please try again');
    }
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃   DELETE CARD WITH CARD ID                                             ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> deleteCard({required String cardId}) async {
    bool status = await walletRepository.deleteCard(cardId: cardId);
    if (status) {
      showSuccessSnackkbar(message: 'Card Deleted Successfully');
      walletManagementService.getAllUserCards(forcePull: true);
    } else {
      showSuccessSnackkbar(message: 'Please try again');
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  STATE FUNCTIONS                                                       ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  @override
  void onInit() {
    walletManagementService.getAllCountries();
    walletManagementService.getAllUserCards();
    super.onInit();
  }
}
