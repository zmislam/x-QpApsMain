import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../../../repository/wallet_repository.dart';
import '../../../../../../../services/wallet_management_service.dart';

class WalletConnectController extends GetxController {
  final WalletRepository walletRepository = WalletRepository();
  final WalletManagementService walletManagementService =
      Get.find<WalletManagementService>();

  Rx<List<String>> storedWallet = Rx([]);
  RxString accountBalance = '0'.obs;

  Future<void> getStoredWalletAddress() async {
    final data = await walletManagementService.getCryptoWalletAddress();
    storedWallet.value = data.split('');
  }

  Future<void> getAccountBalance() async {
    final balance = await walletManagementService.getConnectedAccountBalance();
    BigInt.parse(balance);

    // 1 QP = 1e18 wei
    final divisor = BigInt.from(10).pow(18);
    final balanceBigInt = BigInt.parse(balance);

    // Convert to decimal representation (e.g., 0.1234 QP)
    final readableBalance = balanceBigInt / divisor;
    balanceBigInt.remainder(divisor);

    // Combine integer and decimal parts
    final formattedBalance = '${readableBalance.toStringAsFixed(2)} QP Flex';
    accountBalance.value = formattedBalance;

    update();
  }

  void copyAddress({required String address}) {
    // 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
    //https://arb-sepolia.g.alchemy.com/v2/7aJwD9yTUzydYjeeawtuKFF3tgKQ9CID

    // Valid Address: 0x68AE7786c50461C325ef4925A292DEC1b764F741
    // Valid Address: 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720
    // 0x70997970c51812dc3a010c7d01b50e0d17dc79c8
    // 0xa3f9acaffb011658316bc15e80df55f69cb5d674
    // 0x68AE7786c50461C325ef4925A292DEC1b764F741
    // 0x278A67C2D8034406c8D60507d6551C0a5Daadfe9
    // 0x278a67c2d8034406c8d60507d6551c0a5daadfe9
    Clipboard.setData( ClipboardData(
        text: '0x70997970c51812dc3a010c7d01b50e0d17dc79c8'.tr));
  }

  @override
  void onInit() {
    getStoredWalletAddress();
    getAccountBalance();

    walletManagementService.appKitModal.addListener(
      () {
        debugPrint('LISTENER TRIGGERED');
        getAccountBalance();
        if (storedWallet.value.isEmpty) {
          getStoredWalletAddress();
        }
      },
    );
    super.onInit();
  }
}
