import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../models/transaction_history_model.dart';

import '../../../../../../../components/text_form_field.dart';
import '../../widgets/wallet_dynamic_transaction_history_tile.dart';
import '../controllers/qp_wallet_transaction_history_controller.dart';
import '../drawer/qp_wallet_transection_history_filter_drawer.dart';

class QpWalletTransactionHistoryView extends GetView<QpWalletTransactionHistoryController> {
  const QpWalletTransactionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        title: Text('Transaction History'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              controller.scaffoldKey.currentState!.openEndDrawer();
            },
            icon: const Icon(Icons.filter_alt_outlined),
          )
        ],
      ),
      endDrawer: const WalletHistoryTransactionFilterDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Obx(() {
              return PrimaryTextFormField(
                controller: controller.searchController,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.searchText.value.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          controller.getTransactionFilteredList();
                        },
                        icon: const Icon(Icons.search),
                      )
                    : IconButton(
                        onPressed: () {
                          controller.getTransactionFilteredList();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                hinText: 'Search Transactions',
                onChanged: (value) {
                  controller.searchText.value = value ?? '';
                  return null;
                },
              );
            }),
            const SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => controller.transactionHistoryList.value.isEmpty
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
                        itemCount: controller.transactionHistoryList.value.length,
                        itemBuilder: (context, index) {
                          TransactionHistoryModel model = controller.transactionHistoryList.value[index];
                          return WalletDynamicTransactionHistoryTile(
                            dynamicModel: model,
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                      ),
              ),
            ),
          ],
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
