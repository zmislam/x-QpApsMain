import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../components/button.dart';
import '../../../../../../components/wallet/bill_history_title.dart';
import '../../../../../../components/wallet/transaction_header.dart';
import '../../../../../../components/wallet/wallet_drawer_widget.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../config/constants/color.dart';
import '../../../../../../models/bill_detail_model.dart';
import '../controllers/wallet_controller.dart';

class BillView extends GetView<WalletController> {
  const BillView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getBillHistoryList();

    return Scaffold(
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text('QP Wallet Billing'.tr,
          style: TextStyle(color: Colors.black),
        ),
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
      body: RefreshIndicator(
        onRefresh: () async {
          controller.getBillHistoryList();
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Container(
                  color: Colors.white,
                  child:  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      BillTile(
                        iconPath: AppAssets.BILL_CURRENT_BALANCE_ICON,
                        title: 'Current Balance'.tr,
                        amount: '15.00',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BillTile(
                        iconPath: AppAssets.BILL_REWORD_ICON,
                        title: 'Reward Balance'.tr,
                        amount: '21.00',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BillTile(
                        iconPath: AppAssets.BILL_PAID_ICON,
                        title: 'Paid Amount'.tr,
                        amount: '115.00',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BillTile(
                        iconPath: AppAssets.BILL_DUE_ICON,
                        title: 'Total Due'.tr,
                        amount: '33.00',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Bill Detail Overview'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
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
                  thirdTitle: 'Action',
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => Expanded(
                        child: ListView.separated(
                      itemCount: controller.billHistoryList.value.length,
                      itemBuilder: (context, index) {
                        BillDetailsModel model =
                            controller.billHistoryList.value[index];

                        return BillHistoryTile(
                          billHistoryList: model,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text('Payment for invoice no: ${controller.billHistoryList.value[index].invoiceNumber}'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text('Amount : ${controller.billHistoryList.value[index].totalBillAmount}'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: PRIMARY_COLOR,
                                              fontSize: 17),
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        PrimaryButton(
                                          onPressed: () {
                                            controller.payBill(
                                                controller.billHistoryList
                                                    .value[index].id
                                                    .toString(),
                                                controller
                                                    .billHistoryList
                                                    .value[index]
                                                    .totalBillAmount
                                                    .toString(),
                                                controller
                                                    .billHistoryList
                                                    .value[index]
                                                    .totalBillAmount
                                                    .toString());

                                            Get.back();
                                          },
                                          text: 'Pay Now'.tr,
                                          horizontalPadding: 100,
                                          verticalPadding: 13,
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BillTile extends StatelessWidget {
  const BillTile(
      {super.key,
      required this.iconPath,
      required this.title,
      required this.amount});

  final String iconPath;
  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Image(
          height: 60,
          width: 60,
          image: AssetImage(iconPath),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            amount,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        )
      ],
    );
  }
}
