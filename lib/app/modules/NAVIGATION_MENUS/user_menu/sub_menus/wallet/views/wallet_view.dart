import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/wallet/transaction_header.dart';
import '../../../../../../components/wallet/transaction_history_tile.dart';
import '../../../../../../components/wallet/wallet_card.dart';
import '../../../../../../components/wallet/wallet_drawer_widget.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../config/constants/color.dart';
import '../../../../../../models/transaction_history_model.dart';
import '../controllers/wallet_controller.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<ScaffoldState> walletFromKey = GlobalKey<ScaffoldState>();

    // ! REMOVE THIS CODE SEGMENT WHEN IN DEVELOPMENT OR MAKE IT FALSE
    // ! THIS [underConstructionFlag] IS BEING USED FOR HIDING THR DRAWER AND BODY
    bool underConstructionFlag = false;

    controller.getWalletSummery();
    controller.getTransactionList();

    return Scaffold(
        // key: walletFromKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          // backgroundColor: Colors.white,
          title: Text('QP-Wallet'.tr),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            if (!underConstructionFlag)
              Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                  ),
                );
              })
          ],
        ),
        drawer: const WalletDrawerWidget(),
        body: underConstructionFlag
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.UNDER_CONSTRUCTION,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  Text('This page is under construction'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text('it will we up and running very soon...'.tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  controller.getWalletSummery();
                  controller.getTransactionList();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: Get.height,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => Row(
                            children: [
                              Expanded(
                                child: WalletCard(
                                  iconPath: AppAssets.CURRENT_BALANCE_ICON,
                                  title: 'Current Balance'.tr,
                                  amount: controller
                                          .wallerSummery.value.walletBalance
                                          ?.toStringAsFixed(2) ??
                                      '',
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: WalletCard(
                                  iconPath: AppAssets.REWORD_BALANCE_ICON,
                                  title: 'Received Balance'.tr,
                                  amount: controller.wallerSummery.value
                                          .totalReceivedMoneyAmount
                                          ?.toStringAsFixed(2) ??
                                      '',
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => Row(
                            children: [
                              Expanded(
                                child: WalletCard(
                                  iconPath: AppAssets.SENT_MONEY_BALANCE_ICON,
                                  title: 'Send Money'.tr,
                                  amount: controller.wallerSummery.value
                                          .totalSendMoneyAmount
                                          ?.toStringAsFixed(2) ??
                                      '',
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: WalletCard(
                                  iconPath: AppAssets.WITHDRAW_BALANCE_ICON,
                                  title: 'Withdraw Money'.tr,
                                  amount: controller.wallerSummery.value
                                          .totalWithdrawRequestAmount
                                          ?.toStringAsFixed(2) ??
                                      '',
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('Recent Transaction'.tr,
                                style: TextStyle(
                                    color: PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const TransactionHeader(
                          firstTitle: 'Amount',
                          secondTitle: 'Date',
                          thirdTitle: 'Bill Type',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(() => Expanded(
                                child: ListView.separated(
                              itemCount:
                                  controller.transactionList.value.length,
                              itemBuilder: (context, index) {
                                TransactionHistoryModel model =
                                    controller.transactionList.value[index];

                                return TransactionHistoryTile(
                                  transactionHistoryModel: model,
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                            )))
                      ],
                    ),
                  ),
                ),
              ));
  }
}
