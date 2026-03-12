import 'package:flutter/material.dart';

import '../models/api_response.dart';
import '../models/wallet_crypto/mint_event_model.dart';
import '../services/api_communication.dart';
import '../utils/snackbar.dart';

import '../config/constants/api_constant.dart';
import '../models/bill_detail_model.dart';
import '../models/bill_type_model.dart';
import '../models/card_detail_model.dart';
import '../models/send_money_model.dart';
import '../models/transaction_history_model.dart';
import '../models/wallet_crypto/send_money_event_model.dart';
import '../models/wallet_crypto/withdraw_event_model.dart';
import '../models/wallet_summery_model.dart';
import '../models/withdraw_model.dart';

class WalletRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  Create Payment Intent for Stripe Payment Sheet                        ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<Map<String, dynamic>> createPaymentIntent(
      {required String amount}) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/create-payment-intent',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      requestData: {'amount': amount},
      enableLoading: true,
    );

    return response.data as Map<String, dynamic>;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  Validate Payment after presenting Payment Sheet                       ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> validatePayment(
      {required String paymentIntentId, required String clientSecret}) async {
    final response = await _apiCommunication.doGetRequest(
        apiEndPoint:
            'wallet/payment-validation-for-mobile?payment_intent=$paymentIntentId&redirect_status=succeeded&payment_intent_client_secret=$clientSecret',
        enableLoading: true,
        responseDataKey: ApiConstant.FULL_RESPONSE);
    return response;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  Get Wallet Summary Details                                           ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Future<WalletSummeryModel?> getWalletSummary() async {
    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'wallet/getting-wallet-summary',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
    );

    if (response.isSuccessful) {
      return WalletSummeryModel.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  Get All Transaction History                                          ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<List<TransactionHistoryModel>> getTransactionList() async {
    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'wallet/getting-transection-history',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
    );

    if (response.isSuccessful) {
      return ((response.data as Map<String, dynamic>)['result'] as List)
          .map((e) => TransactionHistoryModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  Get Filtered Transaction List (by Date, Type, Transaction ID)        ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<List<TransactionHistoryModel>> getFilteredTransactionList({
    String? from,
    String? to,
    String? transactionId,
    String? type,
  }) async {
    final Map<String, dynamic> queryParameters = {};

    if (from != null) queryParameters['from'] = from;
    if (to != null) queryParameters['to'] = to;
    if (transactionId != null) queryParameters['trxId'] = transactionId;
    if (type != null) queryParameters['type'] = type;

    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'wallet/getting-transection-history',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      queryParameters: queryParameters,
    );

    if (response.isSuccessful) {
      return ((response.data as Map<String, dynamic>)['result'] as List)
          .map((e) => TransactionHistoryModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  Get Filtered Bill List (by Date & Type )                             ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<List<TransactionHistoryModel>> getFilteredBillIndividualList({
    String? from,
    String? to,
  }) async {
    final Map<String, dynamic> queryParameters = {};

    if (from != null) queryParameters['from'] = from;
    if (to != null) queryParameters['to'] = to;

    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'campaign/list-bill-individual',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      queryParameters: queryParameters,
    );

    if (response.isSuccessful) {
      return ((response.data as Map<String, dynamic>)['result']['list'] as List)
          .map((e) => TransactionHistoryModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  Get MY Send Money Transaction List                                   ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<List<SendMoneyHistoryModel>> getSendMoneyList() async {
    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'wallet/send-money-list',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
    );

    if (response.isSuccessful) {
      return ((response.data as Map<String, dynamic>)['result'] as List)
          .map((e) => SendMoneyHistoryModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  Get Withdraw Money Transaction List                                  ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<List<WithdrawMoneyModel>> getWithdrawMoneyList() async {
    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'wallet/withdraw-money-list',
      responseDataKey: 'result',
      enableLoading: true,
    );

    if (response.isSuccessful) {
      // response.data should be List<dynamic> at this point
      if (response.data is List) {
        final data = (response.data as List)
            .map((e) => WithdrawMoneyModel.fromJson(e))
            .toList();
        return data;
      } else {
        debugPrint('Expected List but got: ${response.data.runtimeType}');
      }
    }
    return [];
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  Get Bill Payment History                                             ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<List<BillDetailsModel>> getBillHistoryList() async {
    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'campaign/list-bill',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
    );

    if (response.isSuccessful) {
      return ((response.data as Map<String, dynamic>)['result'] as List)
          .map((e) => BillDetailsModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  Get Saved User Cards                                                 ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getUserCardList() async {
    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'wallet/getting-all-card',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: false,
    );

    if (response.isSuccessful) {
      return response.copyWith(
          data: ((response.data as Map<String, dynamic>)['result'] as List)
              .map((e) => CardDetailsModel.fromJson(e))
              .toList());
    } else {
      showErrorSnackkbar(message: 'Please try aging later');
      return response;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  Get Available Transaction Types                                      ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getTransactionTypes() async {
    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'wallet/getting-transection-history-types',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
    );

    if (response.isSuccessful) {
      return response.copyWith(
          data: ((response.data as Map<String, dynamic>)['result'] as List)
              .map((e) => BillTypeModel.fromJson(e))
              .toList());
    } else {
      showErrorSnackkbar(message: 'Please try aging later');
      return response;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  Get Available bill Types                                      ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getBillTypes() async {
    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'wallet/getting-wallet-bill-types',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
    );

    if (response.isSuccessful) {
      return response.copyWith(
          data: ((response.data as Map<String, dynamic>)['result'] as List)
              .map((e) => BillTypeModel.fromJson(e))
              .toList());
    } else {
      showErrorSnackkbar(message: 'Please try aging later');
      return response;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  Get List of Supported Countries                                      ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getCountryList() async {
    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'list-all-country',
      responseDataKey: 'result',
      enableLoading: true,
    );

    if (response.isSuccessful) {
      return response.copyWith(
          data:
              (response.data as List).map((e) => e.toString().trim()).toList());
    } else {
      showErrorSnackkbar(message: 'Please try aging later');
      return response;
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  Send Money to another user                                           ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> sendMoney({
    required String recipientAddress,
    required String amount,
    required String password,
    required String remarks,
  }) async {
    final response = await _apiCommunication.doPostRequest(
        apiEndPoint: 'wallet/send-money',
        enableLoading: true,
        requestData: {
          'recipient_address': recipientAddress,
          'amount': amount,
          'password': password,
          'remarks': remarks,
        },
        responseDataKey: ApiConstant.FULL_RESPONSE);

    return response;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  Withdraw Money to a Card                                              ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> withdrawMoney({
    required String cardId,
    required String amount,
    required String password,
    required String remarks,
  }) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/withdraw-money',
      enableLoading: true,
      responseDataKey: ApiConstant.DATA_RESPONSE,
      requestData: {
        'card_id': cardId,
        'amount': amount,
        'password': password,
        'remarks': remarks,
      },
    );

    return response;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  Withdraw Money to a BANK                                              ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> withdrawMoneyToBank({
    required String amount,
    required String password,
    required String remarks,
    required String accountHolderName,
    required String bankName,
    required int accountNumber,
    required int routingNumber,
  }) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/withdraw-money',
      enableLoading: true,
      responseDataKey: ApiConstant.DATA_RESPONSE,
      requestData: {
        'account_holder_name': accountHolderName,
        'bank_name': bankName,
        'account_number': accountNumber,
        'routing_number': routingNumber,
        'amount': amount.toString(),
        'password': password,
        'remarks': remarks,
      },
    );

    return response;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  Pay a Bill from Wallet                                                ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> payBill({
    required String walletId,
    required String amount,
    required String totalAmount,
  }) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'campaign/pay-bill',
      enableLoading: true,
      requestData: {
        'reference_wallet_bill_id': walletId,
        'amount': amount,
        'total_bill_amount': totalAmount,
      },
    );

    return response.isSuccessful;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  Add a New Card                                                        ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> addCard({
    required String holderName,
    required String cardNumber,
    required String expiry,
    required String country,
    required String cvc,
    required String postalCode,
    required bool isDefault,
  }) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/add-card',
      enableLoading: true,
      requestData: {
        'card_holder_name': holderName,
        'card_number': cardNumber,
        'expiry': expiry,
        'country': country,
        'cvc': cvc,
        'postal_code': postalCode,
        'isForDefaultPayment': isDefault,
      },
    );

    return response.isSuccessful;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  Delete an Existing Card                                               ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> deleteCard({required String cardId}) async {
    final response = await _apiCommunication.doDeleteRequest(
      apiEndPoint: 'wallet/delete-card/$cardId',
      enableLoading: true,
    );

    return response.isSuccessful;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  Set a Card as Default                                                 ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> setDefaultCard(
      {required String cardId, required bool isDefault}) async {
    final response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'wallet/set-default/$cardId',
      enableLoading: true,
      requestData: {'isForDefaultPayment': isDefault},
    );

    return response.isSuccessful;
  }

  // $┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓━┓━┓
  // $┃ ┃ ┃ ┃ ┃ ┃ ┃       BLOCK CHAIN INSTIGATION API START       ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃
  // $┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛━┛━┛

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET CONNECTED PUBLIC ADDRESS                                         ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<String> getCryptoWalletPublicAddress() async {
    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'wallet/get-public-address',
      enableLoading: false,
      responseDataKey: ApiConstant.DATA_RESPONSE,
    );

    if (response.isSuccessful) {
      return (response.data as Map<String, dynamic>)['publicAddress'];
    } else {
      return '';
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  SAVE PUBLIC ADDRESS FOR CONNECTION                                    ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> saveCryptoWalletPublicAddress(
      {required String publicAddress}) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/store-public-address',
      enableLoading: true,
      requestData: {'connectedAddress': publicAddress},
    );

    return response.isSuccessful;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  UPDATE WALLET CONNECTION STATUS                                       ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> updateCryptoWalletConnectionStatus(
      {required bool status, required String publicAddress}) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/update-wallet-connection-status',
      enableLoading: false,
      requestData: {'pubAddress': publicAddress, 'isConnected': status},
    );

    return response.isSuccessful;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  DELETE CONNECT PUBLIC ADDRESS                                         ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> deleteConnectedPublicAddress(
      {required String publicAddress}) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/update-wallet-archive-status',
      enableLoading: true,
      requestData: {'publicAddress': publicAddress},
    );

    return response.isSuccessful;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  CREATE MINT REQUEST |SUCCESS OR FAILED|                              ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> saveMintRequest({
    required String requestId,
    required String to,
    required String amountInWei,
    required String signature,
    required bool isMinted,
  }) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/create-mint-event',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      requestData: {
        'requestId': requestId,
        'to': to,
        'amountInWei': amountInWei,
        'signature': signature,
        'isMinted': isMinted,
      },
    );

    return response.isSuccessful;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  CREATE SEND MONEY REQUEST |FAILED|                                   ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> saveSendMoneyRequest({
    required String requestId,
    required String amountInWei,
    required String to,
    required String signature,
  }) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/store-send-money-event',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      requestData: {
        'requestId': requestId,
        'to': to,
        'amountInWei': amountInWei,
        'signature': signature,
      },
    );

    return response.isSuccessful;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  CREATE WITHDRAW REQUEST | FAILED|                                    ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> saveWithdrawRequest({
    required String requestId,
    required String amountInWei,
    required String signature,
  }) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/store-withdraw-money-event',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      requestData: {
        'requestId': requestId,
        'amountInWei': amountInWei,
        'signature': signature,
      },
    );

    return response.isSuccessful;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  UPDATE MINT REQUEST |SUCCESS OR FAILED|                              ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> updateMintRequest({
    required String requestId,
    required bool isMinted,
  }) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/update-mint-event',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      requestData: {
        'requestId': requestId,
        'isMinted': isMinted,
      },
    );

    return response.isSuccessful;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  UPDATE SEND MONEY REQUEST |SUCCESS OR FAILED|                        ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> updateSendMoneyRequest({
    required String requestId,
    required bool isSent,
  }) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/update-send-money-event-status',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      requestData: {
        'requestId': requestId,
        'isSent': isSent,
      },
    );

    return response.isSuccessful;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  UPDATE WITHDRAW REQUEST |SUCCESS OR FAILED|                          ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> updateWithdrawRequest({
    required String requestId,
    required bool isWithdrawn,
  }) async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/update-withdraw-money-event-status',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
      requestData: {
        'requestId': requestId,
        'isWithdrawn': isWithdrawn,
      },
    );

    return response.isSuccessful;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL MINT DATA OF TRANSACTION BY USER                             ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<List<MintEventModel>> getAllMintEventsByUser() async {
    final response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'wallet/get-all-mint-events-by-user',
      enableLoading: true,
      responseDataKey: ApiConstant.DATA_RESPONSE,
    );

    if (response.isSuccessful) {
      return (response.data as List)
          .map(
            (e) => MintEventModel.fromJson(e),
          )
          .toList();
    } else {
      return [];
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL SEND MONEY OF TRANSACTION BY USER                            ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<List<SendMoneyEventModel>> getAllSendMoneyEventsByUser() async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/get-all-send-money-events-by-user-id',
      enableLoading: true,
      responseDataKey: ApiConstant.DATA_RESPONSE,
    );

    if (response.isSuccessful) {
      return (response.data as List)
          .map(
            (e) => SendMoneyEventModel.fromJson(e),
          )
          .toList();
    } else {
      return [];
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL WITHDRAW DATA OF TRANSACTION BY USER                         ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<List<WithdrawnEventModel>> getAllWithdrawEventsByUser() async {
    final response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'wallet/get-all-withdraw-money-events-by-user-id',
      enableLoading: true,
      responseDataKey: ApiConstant.DATA_RESPONSE,
    );

    if (response.isSuccessful) {
      return (response.data as List)
          .map(
            (e) => WithdrawnEventModel.fromJson(e),
          )
          .toList();
    } else {
      return [];
    }
  }

// #┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓━┓━┓
// #┃ ┃ ┃ ┃ ┃ ┃ ┃   BLOCK CHAIN INSTIGATION API START END  ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃
// #┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛━┛━┛
}
