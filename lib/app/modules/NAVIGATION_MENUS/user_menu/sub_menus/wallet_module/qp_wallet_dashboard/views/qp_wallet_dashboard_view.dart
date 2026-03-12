import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/drawer/wallet_drawer_widget.dart';
import '../../widgets/wallet_amount_card_with_title.dart';

import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../models/transaction_history_model.dart';
import '../../widgets/wallet_dynamic_transaction_history_tile.dart';
import '../controllers/qp_wallet_dashboard_controller.dart';

class QpWalletDashboardView extends GetView<QpWalletDashboardController> {
  const QpWalletDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QP Wallet'.tr),
        centerTitle: true,
      ),
      endDrawer: const WalletDrawer(
        isFromHomePage: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.walletManagementService.getAllDataFromSummaryAndTransaction();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller.scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // $ SUMMARY VIEW ----------------------------------------------------------------------------------
                Obx(
                  () => GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.05,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      WalletAmountCardWithTitle(
                        // iconData: QpIcon.market,
                        assetPath: AppAssets.CURRENT_BALANCE_ICON,
                        title: 'Current Balance'.tr,
                        amount: controller.walletManagementService.walletSummary.value?.walletBalance?.toStringAsFixed(2) ?? '',
                      ),
                      WalletAmountCardWithTitle(
                        assetPath: AppAssets.REWORD_BALANCE_ICON,
                        title: 'Received Balance'.tr,
                        amount: controller.walletManagementService.walletSummary.value?.totalReceivedMoneyAmount?.toStringAsFixed(2) ?? ' 0',
                      ),
                      WalletAmountCardWithTitle(
                        assetPath: AppAssets.SENT_MONEY_BALANCE_ICON,
                        title: 'Send Money'.tr,
                        amount: controller.walletManagementService.walletSummary.value?.totalSendMoneyAmount?.toStringAsFixed(2) ?? ' 0',
                      ),
                      WalletAmountCardWithTitle(
                        assetPath: AppAssets.WITHDRAW_BALANCE_ICON,
                        title: 'Withdraw Money'.tr,
                        amount: controller.walletManagementService.walletSummary.value?.totalWithdrawRequestAmount?.toStringAsFixed(2) ?? ' 0',
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // $ TRANSACTION LIST ----------------------------------------------------------------------------------
                Text('Recent Transaction'.tr,
                  style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),

                Obx(
                  () => controller.walletManagementService.transactionList.value.isEmpty
                      ? SizedBox(
                          height: 200,
                          child: Center(
                            child: Text('No Data for preview'.tr),
                          ),
                        )
                      : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: controller.walletManagementService.transactionList.value.length,
                          itemBuilder: (context, index) {
                            TransactionHistoryModel model = controller.walletManagementService.transactionList.value[index];
                            return WalletDynamicTransactionHistoryTile(
                              dynamicModel: model,
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: Obx(() {
        if (controller.showScrollToTop.value) {
          return FloatingActionButton.small(
            onPressed: () {
              controller.scrollToTop();
            },
            backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
            child: const Icon(Icons.arrow_circle_up_rounded),
          );
        }
        return const SizedBox();
      }),
    );
  }
}
