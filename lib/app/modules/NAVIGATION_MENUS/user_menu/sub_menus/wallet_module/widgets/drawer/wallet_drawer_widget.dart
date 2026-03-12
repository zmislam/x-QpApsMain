import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../services/wallet_management_service.dart';
import '../../../../../../../utils/snackbar.dart';

import '../../../../../../../config/constants/app_assets.dart';
import '../../../../widget/wallet_connection_button.dart';

class WalletDrawer extends StatelessWidget {
  final bool isFromHomePage;

  const WalletDrawer({
    super.key,
    this.isFromHomePage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletManagementService = Get.find<WalletManagementService>();
    walletManagementService.checkStatusOfConnectionAndReconnect();

    // ? Navigation handler that checks if we need to go home first
    void navigateTo(dynamic page) {
      // @ CLOSE THE DRAWER
      Get.close(1);
      Get.toNamed(page);
    }

    return Drawer(
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header with app logo and name
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          AppAssets.APP_LOGO,
                          height: 40,
                          width: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text('Quantum\nPossibilities'.tr,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Add balance button
                  ElevatedButton.icon(
                    onPressed: () {
                      if (walletManagementService
                          .myCryptoAccountAddress.value.isNotEmpty) {
                        navigateTo(Routes.QP_WALLET_ADD_BALANCE);
                      } else {
                        showErrorSnackkbar(
                            message: 'Please connect your wallet first');
                      }
                    },
                    icon: Image.asset(
                      AppAssets.ADD_QP_ICON,
                      height: 20,
                      width: 20,
                      color: theme.colorScheme.onPrimary,
                    ),
                    label: Text('Add QP Balance'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
              ),

              // $ WALLET CONNECTION ----------------------------------------------------------------------------------

              child: Obx(() {
                bool hasWallet = walletManagementService
                    .myCryptoAccountAddress.value.isNotEmpty;
                walletManagementService.myCryptoAccountAddress.value.split('');
                debugPrint(walletManagementService.myCryptoAccountAddress.value);

                return Column(
                  children: [
                    // if (hasWallet)
                    //   Material(
                    //     color: Theme.of(context).cardColor,
                    //     borderRadius: BorderRadius.circular(10),
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //       child: RichText(
                    //         text: TextSpan(children: [
                    //           TextSpan(
                    //             text: 'Public Address: '.tr,
                    //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    //           ),
                    //           TextSpan(
                    //             text: myAddress.getRange(0, 6).join(),
                    //             style: Theme.of(context).textTheme.bodyMedium,
                    //           ),
                    //           TextSpan(text: '............'.tr, style: Theme.of(context).textTheme.bodyMedium),
                    //           TextSpan(
                    //             text: myAddress.getRange(myAddress.length - 6, myAddress.length).join(),
                    //             style: Theme.of(context).textTheme.bodyMedium,
                    //           ),
                    //         ]),
                    //       ),
                    //     ),
                    //   ),
                    // const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: WalletConnectionButton(
                            appKit: walletManagementService.appKitModal,
                            context: context,
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton.filled(
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(11),
                            backgroundColor: hasWallet
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.tertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => navigateTo(Routes.WALLET_CONNECT),
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      ],
                    ),

                    // MINT EVENTS
                    if (hasWallet)
                      _buildDrawerItem(
                        context: context,
                        padding: EdgeInsets.zero,
                        icon: AppAssets.SENDMONEY_DASHBOARD_ICON,
                        title: 'Events'.tr,
                        onTap: () => navigateTo(Routes.MINTED_EVENTS),
                        theme: theme,
                        showDivider: false,
                      ),
                  ],
                );
              }),
            ),

            // $ ----------------------------------------------------------------------------------

            // Drawer Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Section title
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                    child: Text('WALLET'.tr,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // Wallet Dashboard
                  _buildDrawerItem(
                    context: context,
                    icon: AppAssets.WITHDRAW_DASHBOARD_ICON,
                    title: 'Wallet Dashboard'.tr,
                    onTap: () => navigateTo(Routes.QP_WALLET_DASHBOARD),
                    theme: theme,
                  ),

                  // Send Money
                  _buildDrawerItem(
                    context: context,
                    icon: AppAssets.SENDMONEY_DASHBOARD_ICON,
                    title: 'Send Money'.tr,
                    onTap: () {
                      if (walletManagementService
                          .myCryptoAccountAddress.value.isNotEmpty) {
                        navigateTo(Routes.QP_WALLET_SEND_MONEY);
                      } else {
                        showErrorSnackkbar(
                            message: 'Please connect your wallet first');
                      }
                    },
                    theme: theme,
                  ),

                  // Payment Settings
                  _buildDrawerItem(
                    context: context,
                    icon: AppAssets.PAYMENTSETTING_DASHBOARD_ICON,
                    title: 'Payment Settings'.tr,
                    onTap: () => navigateTo(Routes.QP_WALLET_PAYMENT_SETTINGS),
                    theme: theme,
                  ),

                  // Section title
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 24, bottom: 8),
                    child: Text('TRANSACTIONS'.tr,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // Billing
                  _buildDrawerItem(
                    context: context,
                    icon: AppAssets.BILLING_DASHBOARD_ICON,
                    title: 'Billing'.tr,
                    onTap: () => navigateTo(Routes.QP_WALLET_BILLING),
                    theme: theme,
                  ),

                  // Withdraw
                  _buildDrawerItem(
                    context: context,
                    icon: AppAssets.WITHDRAWAL_DASHBOARD_ICON,
                    title: 'Withdraw'.tr,
                    onTap: () {
                      if (walletManagementService
                          .myCryptoAccountAddress.value.isNotEmpty) {
                        navigateTo(Routes.QP_WALLET_WITHDRAW);
                      } else {
                        showErrorSnackkbar(
                            message: 'Please connect your wallet first');
                      }
                    },
                    theme: theme,
                  ),

                  // Transaction History
                  _buildDrawerItem(
                    context: context,
                    icon: AppAssets.HISTORY_DASHBOARD_ICON,
                    title: 'Transaction History'.tr,
                    onTap: () =>
                        navigateTo(Routes.QP_WALLET_TRANSACTION_HISTORY),
                    theme: theme,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
    EdgeInsets? padding,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              icon,
              height: 24,
              width: 24,
              color: theme.colorScheme.primary,
            ),
          ),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          onTap: onTap,
          contentPadding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          tileColor: Colors.transparent,
          hoverColor: theme.colorScheme.primary.withValues(alpha: 0.05),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: theme.dividerColor.withValues(alpha: 0.1),
          ),
      ],
    );
  }
}
