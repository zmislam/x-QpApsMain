import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../models/api_response.dart';

import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../data/login_creadential.dart';
import '../../../../../../models/bill_detail_model.dart';
import '../../../../../../models/bill_type_model.dart';
import '../../../../../../models/card_detail_model.dart';
import '../../../../../../models/send_money_model.dart';
import '../../../../../../models/transaction_history_model.dart';
import '../../../../../../models/wallet_summery_model.dart';
import '../../../../../../models/withdraw_model.dart';
import '../../../../../../services/api_communication.dart';
import '../../../../../../utils/snackbar.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class WalletController extends GetxController {
  //TODO: Implement WalletController

  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  var wallerSummery = WalletSummeryModel().obs;
  Rx<bool> obscureText = true.obs;
  Rx<String> cardNumber = ''.obs;
  Rx<String> tranxNo = ''.obs;
  Rx<String> billType = ''.obs;
  Rx<String> startDate = ''.obs;
  Rx<String> endDate = ''.obs;
  Rx<String> cardExpDate = ''.obs;
  Rx<String> countryName = ''.obs;
  Rx<Object?> dropdownValue = Rx(null);
  RxBool is_default_payment = false.obs;
  Rx<List<TransactionHistoryModel>> transactionList = Rx([]);
  Rx<List<SendMoneyHistoryModel>> sendHistoryList = Rx([]);
  Rx<List<WithdrawMoneyModel>> withdrawHistoryList = Rx([]);
  Rx<List<BillDetailsModel>> billHistoryList = Rx([]);
  Rx<List<CardDetailsModel>> userCardList = Rx([]);
  Rx<List<BillTypeModel>> billTypeList = Rx([]);
  Rx<List<String>> countryList = Rx([]);

  TextEditingController sendRecipientController = TextEditingController();
  TextEditingController sendAmountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  TextEditingController cardNameHolderController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpController = TextEditingController();
  TextEditingController cardCVVController = TextEditingController();
  TextEditingController cardExpiryController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();

  final secrectKey = ''; // Stripe key removed for security

  createPaymentIntent() async {
    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/create-payment-intent',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      requestData: {
        'amount': sendAmountController.text.toString(),
      },
      // isFormData: true,
      enableLoading: true,
    );
    if (apiResponse.isSuccessful) {
      return apiResponse.data as Map<String, dynamic>;
    } else {}
  }

  Future<void> makePayment() async {
    Map<String, dynamic>? paymentIndentData;

    paymentIndentData = await createPaymentIntent();
    if (paymentIndentData != null) {
      try {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIndentData['clientSecret'],
              // customerId: paymentIndentData['customer'],
              allowsDelayedPaymentMethods: true,
              // customerEphemeralKeySecret: paymentIndentData['ephemeralKey'],
              googlePay: const PaymentSheetGooglePay(
                  // Currency and country code is accourding to India
                  testEnv: true,
                  currencyCode: 'USD',
                  merchantCountryCode: 'US'),
              returnURL:
                  '${ApiConstant.SERVER_IP}:82/api/wallet/payment-validation',
              merchantDisplayName: 'Quantum Posibility'),
        );

        await Stripe.instance.presentPaymentSheet();

        ApiResponse apiResponse = await _apiCommunication.doGetRequest(
          apiEndPoint:
              'wallet/payment-validation-for-mobile?payment_intent=${paymentIndentData['indentId']}&redirect_status=succeeded&payment_intent_client_secret=${paymentIndentData['clientSecret']}',
        );

        if (apiResponse.isSuccessful) {
          sendAmountController.clear();
          showSuccessSnackkbar(message: 'Add balance successfull');
          dropdownValue.value = null;
          getWalletSummery();
          getTransactionList();
        }

        debugPrint('sdfsf');
      } catch (e) {
        debugPrint('asfsfasdf');
      }
    }
  }

  Future<void> getWalletSummery() async {
    final apiResponse = await _apiCommunication.doGetRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'wallet/getting-wallet-summary',
        enableLoading: true);
    if (apiResponse.isSuccessful) {
      wallerSummery.value = WalletSummeryModel.fromJson(
          ((apiResponse.data as Map<String, dynamic>)));

      debugPrint('wallet summery value.................${wallerSummery.value}');
    } else {}
  }

  Future<void> getTransactionList() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      apiEndPoint: 'wallet/getting-transection-history',
    );
    if (apiResponse.isSuccessful) {
      transactionList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => TransactionHistoryModel.fromJson(element))
              .toList();
      transactionList.refresh();
    } else {}
  }

  Future<void> getFilterTransactionList() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      apiEndPoint:
          'wallet/getting-transection-history?from=${startDate.value.toString()}&to=${endDate.value.toString()}&trxId=${tranxNo.value}&type=${billType.value}',
    );
    if (apiResponse.isSuccessful) {
      transactionList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => TransactionHistoryModel.fromJson(element))
              .toList();
      transactionList.refresh();
    } else {}
  }

  Future<void> getSendMoneyList() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      apiEndPoint: 'wallet/send-money-list',
    );
    if (apiResponse.isSuccessful) {
      sendHistoryList.value.clear();
      sendHistoryList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => SendMoneyHistoryModel.fromJson(element))
              .toList();
      sendHistoryList.refresh();
    } else {}
  }

  Future<void> geWithdrawMoneyList() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      apiEndPoint: 'wallet/withdraw-money-list',
    );
    if (apiResponse.isSuccessful) {
      withdrawHistoryList.value.clear();
      withdrawHistoryList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => WithdrawMoneyModel.fromJson(element))
              .toList();
      withdrawHistoryList.refresh();
    } else {}
  }

  Future<void> getBillHistoryList() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      apiEndPoint: 'campaign/list-bill',
    );
    if (apiResponse.isSuccessful) {
      billHistoryList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => BillDetailsModel.fromJson(element))
              .toList();
      billHistoryList.refresh();
    } else {}
  }

  Future<void> getUserCardList() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      apiEndPoint: 'wallet/getting-all-card',
    );
    if (apiResponse.isSuccessful) {
      userCardList.value.clear();
      userCardList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => CardDetailsModel.fromJson(element))
              .toList();
      userCardList.refresh();
    } else {}
  }

  Future<void> getTransactionType() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      apiEndPoint: 'wallet/getting-transection-history-types',
    );
    if (apiResponse.isSuccessful) {
      billTypeList.value.clear();
      billTypeList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => BillTypeModel.fromJson(element))
              .toList();
      billTypeList.refresh();
      for (int i = 0; i < billTypeList.value.length; i++) {
        debugPrint('bill type........${billTypeList.value[i].value}');
      }
    } else {}
  }

  Future<void> getCountryList() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      apiEndPoint: 'list-all-country',
    );
    if (apiResponse.isSuccessful) {
      countryList.value.clear();
      countryList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((e) => e.toString())
              .toList();
      countryList.refresh();
      debugPrint('country list${countryList.value}');
    } else {}
  }

  Future<void> sendMoney() async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/send-money',
      enableLoading: true,
      requestData: {
        'recipient_email': sendRecipientController.text,
        'amount': sendAmountController.text,
        'password': passwordController.text,
        'remarks': remarkController.text,
      },
    );

    debugPrint('response............$response');
    if (response.isSuccessful) {
      sendRecipientController.clear();
      sendAmountController.clear();
      passwordController.clear();
      remarkController.clear();
      showSuccessSnackkbar(message: 'Money send successfully');
      getSendMoneyList();
      getWalletSummery();
      getTransactionList();
    } else {
      debugPrint('');
    }
  }

  Future<void> withdrawMoney() async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/withdraw-money',
      enableLoading: true,
      requestData: {
        'card_id': cardNumber.value,
        'amount': sendAmountController.text,
        'password': passwordController.text,
        'remarks': remarkController.text,
      },
    );

    debugPrint('response............$response');
    if (response.isSuccessful) {
      sendAmountController.clear();
      passwordController.clear();
      remarkController.clear();
      cardNumber.value = '';
      dropdownValue.value = null;
      showSuccessSnackkbar(message: 'Withdraw Money successfully');
      geWithdrawMoneyList();
      getWalletSummery();
      getTransactionList();
    } else {
      debugPrint('');
    }
  }

  Future<void> payBill(
      String walletId, String amount, String totalamount) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'campaign/pay-bill',
      enableLoading: true,
      requestData: {
        'reference_wallet_bill_id': walletId,
        'amount': amount,
        'total_bill_amount': totalamount,
      },
    );

    debugPrint('response............$response');
    if (response.isSuccessful) {
      showSuccessSnackkbar(message: 'Bill Pay successfully');
      getBillHistoryList();
      getWalletSummery();
      getTransactionList();
    } else {
      debugPrint('');
    }
  }

  Future<void> addCard() async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/add-card',
      enableLoading: true,
      requestData: {
        'card_holder_name': cardNameHolderController.text.toString(),
        'card_number': cardNumberController.text.toString(),
        'expiry': cardExpDate.value.toString(),
        'country': countryName.value,
        'cvc': cardCVVController.text.toString(),
        'postal_code': postCodeController.text.toString(),
        'isForDefaultPayment': is_default_payment.value
      },
    );

    debugPrint('response............${response.statusCode}');

    debugPrint('response............$response');
    if (response.isSuccessful) {
      showSuccessSnackkbar(message: 'Card add successfully');
      cardNameHolderController.clear();
      cardNumberController.clear();
      cardCVVController.clear();
      postCodeController.clear();
      cardExpiryController.clear();
      countryName.value = '';
      is_default_payment.value = false;
      getUserCardList();
    } else {
      debugPrint('');
    }
  }

  Future<void> deleteCard(String cardId) async {
    final response = await _apiCommunication.doDeleteRequest(
      apiEndPoint: 'wallet/delete-card/$cardId',
      enableLoading: true,
    );

    debugPrint('response............$response');
    if (response.isSuccessful) {
      showSuccessSnackkbar(message: 'Card delete successfully');
      getUserCardList();
    } else {
      debugPrint('');
    }
  }

  Future<void> setDefaultCard(String cardId, bool isDefalutCard) async {
    final response = await _apiCommunication.doPatchRequest(
        apiEndPoint: 'wallet/set-default/$cardId',
        enableLoading: true,
        requestData: {'isForDefaultPayment': isDefalutCard});

    debugPrint('response............$response');
    if (response.isSuccessful) {
      showSuccessSnackkbar(message: 'Default card set successfully');
      getUserCardList();
    } else {
      debugPrint('');
    }
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();
    getTransactionList();
    getWalletSummery();
    getUserCardList();
    getTransactionType();
    getCountryList();
    super.onInit();
  }
}
