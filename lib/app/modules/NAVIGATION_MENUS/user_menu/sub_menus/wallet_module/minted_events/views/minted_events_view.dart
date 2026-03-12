import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../models/wallet_crypto/mint_event_model.dart';
import '../widgets/mint_event_card.dart';
import '../widgets/withdraw_event_card.dart';

import '../../../../../../../models/wallet_crypto/send_money_event_model.dart';
import '../../../../../../../models/wallet_crypto/withdraw_event_model.dart';
import '../controllers/minted_events_controller.dart';
import '../widgets/send_money_card.dart';

class MintedEventsView extends GetView<MintedEventsController> {
  const MintedEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wallet'.tr),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Mint'.tr),
              Tab(text: 'Send Money'.tr),
              Tab(text: 'Withdrawals'.tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Mint Events (existing content)
            _buildMintEventsTab(),
            // Tab 2: Transactions
            _buildTransactionsTab(),
            // Tab 3: Withdrawals
            _buildWithdrawalsTab(),
          ],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
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
      ),
    );
  }

  Widget _buildMintEventsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getAllMintEvents();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Obx(
          () => controller.mintEvents.value.isEmpty
              ? SizedBox(
                  height: 200,
                  child: Center(
                    child: Text('No Data for preview'.tr),
                  ),
                )
              : ListView.separated(
                  controller: controller.scrollController,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: controller.mintEvents.value.length,
                  itemBuilder: (context, index) {
                    MintEventModel model = controller.mintEvents.value[index];
                    return MintEventActionCard(
                      mintEventModel: model,
                      onMintPressed: () {
                        debugPrint(model.toString());
                        controller.mintARequest(mintEventModel: model);
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                ),
        ),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getAllSendMoneyEvents();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Obx(
          () => controller.isSendMoneyLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.sendMoneyEvents.value.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text('Transactions'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('No transactions available'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      controller: controller.scrollController,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: controller.sendMoneyEvents.value.length,
                      itemBuilder: (context, index) {
                        SendMoneyEventModel model =
                            controller.sendMoneyEvents.value[index];
                        return SendMoneyCard(
                          sendMoneyEventModel: model,
                          onMintPressed: () {
                            // showWarningSnackkbar(message: 'This Feature is under development');
                            controller.sendMoneyForRetry(model: model);
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    ),
        ),
      ),
    );
  }

  Widget _buildWithdrawalsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getAllWithdrawnMoneyEvents();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Obx(
          () => controller.isWithdrawnLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.withdrawnEvents.value.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text('Withdrawals'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('No withdrawals available'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      controller: controller.scrollController,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: controller.withdrawnEvents.value.length,
                      itemBuilder: (context, index) {
                        WithdrawnEventModel model =
                            controller.withdrawnEvents.value[index];
                        return WithdrawEventCard(
                          withdrawEventModel: model,
                          onMintPressed: () {
                            controller.withdrawRetry(model: model);
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    ),
        ),
      ),
    );
  }
}
