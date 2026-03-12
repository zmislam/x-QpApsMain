import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widget/wallet_connection_button.dart';

import '../controllers/wallet_connect_controller.dart';

class WalletConnectView extends GetView<WalletConnectController> {
  const WalletConnectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('My Wallet'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Wallet Overview'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    bool hasWallet = controller.walletManagementService
                        .myCryptoAccountAddress.value.isNotEmpty;
                    return Text(
                      hasWallet ? 'Connected & Active' : 'Ready to Connect',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stored Wallet Section
            Obx(() {
              bool hasWallet = controller.walletManagementService
                  .myCryptoAccountAddress.value.isNotEmpty;
              return !hasWallet && controller.storedWallet.value.isNotEmpty
                  ? _buildWalletCard(
                      context: context,
                      title: 'Previously Connected'.tr,
                      subtitle: 'Stored wallet address'.tr,
                      icon: Icons.history,
                      iconColor: Colors.orange,
                      address: controller.storedWallet.value.join(),
                      onCopy: () => controller.copyAddress(
                          address: controller.storedWallet.value.join()),
                      isStored: true,
                    )
                  : const SizedBox();
            }),

            // Connected Account Section
            Obx(() {
              bool hasWallet = controller.walletManagementService
                  .myCryptoAccountAddress.value.isNotEmpty;
              return hasWallet
                  ? _buildWalletCard(
                      context: context,
                      title: 'Connected Account'.tr,
                      subtitle: 'Active wallet address'.tr,
                      icon: Icons.link,
                      iconColor: Colors.green,
                      address: controller
                          .walletManagementService.myCryptoAccountAddress.value,
                      onCopy: () => controller.copyAddress(
                        address: controller.walletManagementService
                            .myCryptoAccountAddress.value,
                      ),
                    )
                  : const SizedBox();
            }),

            // Account Balance Section
            Obx(() {
              bool hasWallet = controller.walletManagementService
                  .myCryptoAccountAddress.value.isNotEmpty;
              return hasWallet
                  ? Container(
                      margin: const EdgeInsets.only(top: 16),
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.account_balance,
                                  color: Colors.blue.shade600,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('Account Balance'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.accountBalance.value.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade900,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text('Current balance'.tr,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
            }),

            const SizedBox(height: 32),

            // Connection Button Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.power_settings_new,
                          color: Colors.purple.shade600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Wallet Connection'.tr,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Connect or disconnect your crypto wallet'.tr,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  WalletConnectionButton(
                    appKit: controller.walletManagementService.appKitModal,
                    context: context,
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.storedWallet.value.isNotEmpty ||
                        controller.walletManagementService
                            .myCryptoAccountAddress.value.isNotEmpty) {
                      return ElevatedButton(
                        onPressed: () async {
                          await controller.walletManagementService
                              .deleteConnectedAndStoredPublicAddress(
                                  storedWalletAddress:
                                      controller.storedWallet.value.isNotEmpty
                                          ? controller.storedWallet.value.join()
                                          : null);
                          controller.getStoredWalletAddress();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
                          backgroundColor: Theme.of(context).colorScheme.error,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Delete connected wallet'.tr),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String address,
    required VoidCallback onCopy,
    bool isStored = false,
  }) {
    List<String> addressChars = address.split('');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isStored ? Colors.orange.shade200 : Colors.green.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_rounded),
                  iconSize: 18,
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: addressChars.isNotEmpty
                ? RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: addressChars.length > 16
                              ? addressChars.getRange(0, 16).join()
                              : addressChars.join(),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade800,
                                  ),
                        ),
                        if (addressChars.length > 32) ...[
                          TextSpan(
                            text: '............'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey.shade500,
                                ),
                          ),
                          TextSpan(
                            text: addressChars
                                .getRange(
                                  addressChars.length - 16,
                                  addressChars.length,
                                )
                                .join(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
                                ),
                          ),
                        ],
                      ],
                    ),
                  )
                : Text('No wallet address available'.tr,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
