import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import '../../../../../../../models/wallet_crypto/mint_event_model.dart';
import '../../../../../../../models/wallet_crypto/send_money_event_model.dart';
import '../../../../../../../models/wallet_crypto/withdraw_event_model.dart';
import '../../../../../../../utils/snackbar.dart';

import '../../../../../../../repository/wallet_repository.dart';
import '../../../../../../../services/wallet_management_service.dart';
import '../../../../../../../utils/wallet_util/improved_permit_signer.dart';

class MintedEventsController extends GetxController
    with WidgetsBindingObserver {
  final WalletRepository walletRepository = WalletRepository();
  final WalletManagementService walletManagementService =
      Get.find<WalletManagementService>();

  final ScrollController scrollController = ScrollController();
  RxBool showScrollToTop = false.obs;

  // @ FLAG FOR REFRESH
  bool needRefresh = false;
  bool needToUpdateMint = false;
  bool needToUpdateWithdraw = false;
  bool needToUpdateSendMoney = false;

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  MINT ACTIONS                                                         ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Rx<List<MintEventModel>> mintEvents = Rx([]);
  RxBool isMintEventLoading = true.obs;
  Future<void> getAllMintEvents() async {
    isMintEventLoading.value = true;
    mintEvents.value.clear();
    mintEvents.value = await walletRepository.getAllMintEventsByUser();
    mintEvents.value = mintEvents.value.reversed.toList();
    isMintEventLoading.value = false;
  }

  Future<void> mintARequest({required MintEventModel mintEventModel}) async {
    try {
      EasyLoading.show();
      final mintEvent = await walletManagementService.validateAddBalancePayment(
        requestId: mintEventModel.requestId.toString(),
        signature: mintEventModel.signature.toString(),
        amount: mintEventModel.amountInWei.toString(),
        isUpdate: true,
      );

      debugPrint('EVENT LOG PRO MAX ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
      debugPrint('MINT HASH : $mintEvent');
      if (mintEvent != null) {
        getAllMintEvents();
        needRefresh = true;
      } else {
        needToUpdateMint = true;
      }
    } catch (error) {
      EasyLoading.dismiss();
      showErrorSnackkbar(
          message: 'This request cant be minted, Please try again later');
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  SEND MONEY ACTIONS                                                   ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Rx<List<SendMoneyEventModel>> sendMoneyEvents = Rx([]);
  RxBool isSendMoneyLoading = true.obs;
  Future<void> getAllSendMoneyEvents() async {
    isSendMoneyLoading.value = true;
    sendMoneyEvents.value.clear();
    sendMoneyEvents.value =
        await walletRepository.getAllSendMoneyEventsByUser();
    sendMoneyEvents.value = sendMoneyEvents.value.reversed.toList();
    isSendMoneyLoading.value = false;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  SEND MONEY TO AN USER MINT                                            ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Future<void> sendMoneyForRetry({required SendMoneyEventModel model}) async {
    final deadline =
        BigInt.from(DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600);
    final amountInWei = BigInt.parse(model.amountInWei.toString());

    final nonceResult = await walletManagementService.ethProvider.call(
      contract: walletManagementService.contractCoin,
      function: walletManagementService.contractCoin.function('nonces'),
      params: [
        EthereumAddress.fromHex(
            walletManagementService.myCryptoAccountAddress.value)
      ],
    );

    // Extract nonce from the result list
    final BigInt nonce = nonceResult.first as BigInt;

    debugPrint(
        'TOKEN CONTRACT NAME: ${walletManagementService.contractCoin.abi.name}');
    debugPrint('TOKEN COIN NONCE VALUE: $nonce');

    final permitSigner = ImprovedPermitSignature(
      appKit: walletManagementService.appKitModal,
      web3Client: walletManagementService.ethProvider,
    );

    final permitResult = await permitSigner.signPermitWithValidation(
      tokenName: walletManagementService.tokenName,
      version: '1',
      chainId: int.parse(walletManagementService.chainCode),
      verifyingContract: walletManagementService.contractCoin.address.hexEip55,
      owner: walletManagementService.myCryptoAccountAddress.value,
      spender: walletManagementService.contractEngin.address.hexEip55,
      value: amountInWei,
      deadline: deadline,
    );

    debugPrint(permitResult.toString());

    final rCore = '0x${permitResult.r.toRadixString(16).padLeft(64, '0')}';
    final sCore = '0x${permitResult.s.toRadixString(16).padLeft(64, '0')}';

    debugPrint(
        'VALIDATE THE SIGNER USING LOCAL OWNER _________________________________');
    final validateSigValue = await permitSigner.validatePermitSignature(
      tokenAddress: walletManagementService.contractCoin.address.hexEip55,
      owner: EthereumAddress.fromHex(
              walletManagementService.myCryptoAccountAddress.value)
          .hexEip55,
      permitResult: permitResult,
    );
    debugPrint('$validateSigValue');
    if (!validateSigValue) {
      showErrorSnackkbar(
          message: 'The signature is not valid, Please try again');
      return;
    }
    debugPrint('VALIDATE THE SIGNER _________________________________');

    final response =
        await walletManagementService.transferForRetailersWithPermit(params: [
      Uint8List.fromList(hexToBytes(model.requestId.toString())), // requestId
      EthereumAddress.fromHex(model.to.toString()), // to
      amountInWei, // amountInWei
      permitResult.deadline, // deadline
      BigInt.from(permitResult.v), // v
      Uint8List.fromList(hexToBytes(rCore)), // r
      Uint8List.fromList(hexToBytes(sCore)), // s
      Uint8List.fromList(hexToBytes(model.signature.toString())), // signature
    ], defaultParams: [
      model.requestId,
      EthereumAddress.fromHex(model.to.toString()),
      amountInWei,
      permitResult.deadline,
      BigInt.from(permitResult.v),
      rCore,
      sCore,
      model.signature
    ]);

    if (response != null) {
      getAllSendMoneyEvents();
      showSuccessSnackkbar(message: 'Money transfer was successfully');
    } else {
      needToUpdateSendMoney = true;
    }
    needRefresh = true;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  WITHDRAW ACTIONS                                                     ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Rx<List<WithdrawnEventModel>> withdrawnEvents = Rx([]);
  RxBool isWithdrawnLoading = true.obs;
  Future<void> getAllWithdrawnMoneyEvents() async {
    isWithdrawnLoading.value = true;
    withdrawnEvents.value.clear();
    withdrawnEvents.value = await walletRepository.getAllWithdrawEventsByUser();
    withdrawnEvents.value = withdrawnEvents.value.reversed.toList();
    isWithdrawnLoading.value = false;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  WITHDRAW MONEY MINT EVENT                                             ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> withdrawRetry({required WithdrawnEventModel model}) async {
    final walletEvent =
        await walletManagementService.withdrawMoneyToCard(params: [
      Uint8List.fromList(hexToBytes(model.requestId.toString())), // requestId
      BigInt.tryParse(model.amountInWei.toString()), // amountInWei
      Uint8List.fromList(hexToBytes(model.signature.toString())), // signature
    ], defaultParams: [
      model.requestId.toString(),
      BigInt.tryParse(model.amountInWei.toString()),
      model.signature.toString(),
    ]);
    debugPrint('EVENT LOG PRO MAX ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    debugPrint('WITHDRAW HASH : $walletEvent');
    if (walletEvent != null) {
      getAllWithdrawnMoneyEvents();
      needRefresh = true;
      showSuccessSnackkbar(message: 'Money withdraw was successfully');
    } else {
      needToUpdateWithdraw = true;
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  STATE FUNCTIONS                                                       ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  @override
  void onInit() {
    super.onInit();
    getAllMintEvents();
    getAllSendMoneyEvents();
    getAllWithdrawnMoneyEvents();
    WidgetsBinding.instance.addObserver(this);
    scrollController.addListener(
      () {
        if (scrollController.position.pixels > (Get.height - 250)) {
          showScrollToTop.value = true;
        } else {
          showScrollToTop.value = false;
        }
      },
    );
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    EasyLoading.dismiss();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('🟢 App in Foreground');

        Future.delayed(const Duration(milliseconds: 200), () {
          update(); // or trigger any Rx value
        });

        await Future.delayed(const Duration(seconds: 3));
        if (needToUpdateMint) {
          await getAllMintEvents();
          needToUpdateMint = false;
        }
        if (needToUpdateWithdraw) {
          await getAllWithdrawnMoneyEvents();
          needToUpdateWithdraw = false;
        }
        if (needToUpdateSendMoney) {
          await getAllSendMoneyEvents();
          needToUpdateSendMoney = false;
        }

        EasyLoading.dismiss();
        break;
      case AppLifecycleState.inactive:
        debugPrint('⚪ App is Inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('🔴 App in Background');
        break;
      case AppLifecycleState.detached:
        debugPrint('⚫ App Detached');
        break;
      case AppLifecycleState.hidden:
        debugPrint('⚫ App hidden');
    }
    super.didChangeAppLifecycleState(state);
  }
}
