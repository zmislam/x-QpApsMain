import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../components/button.dart';
import '../../../../../../components/dropdown.dart';
import '../../../../../../components/text_form_field.dart';
import '../../../../../../components/wallet/transaction_header.dart';
import '../../../../../../components/wallet/transaction_history_tile.dart';
import '../../../../../../components/wallet/wallet_drawer_widget.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../models/bill_type_model.dart';
import '../../../../../../models/transaction_history_model.dart';
import '../controllers/wallet_controller.dart';

class TransactionHistory extends GetView<WalletController> {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getTransactionType();
    return Scaffold(
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text('Transaction History '.tr,
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
          controller.searchController.clear();
          controller.getTransactionList();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: Get.height,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                 Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Transaction History'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Container(
                        width: Get.width - 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: controller.searchController,
                            decoration:  InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search'.tr,
                                hintStyle: TextStyle(color: Colors.grey)),
                            onChanged: (value) {
                              controller.tranxNo.value =
                                  controller.searchController.text;
                              controller.getFilterTransactionList();
                            },
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: [
                                     Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Text('Filter'.tr,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: const Icon(
                                              Icons.cancel_outlined)),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                 Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Text('Bill Type'.tr,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Obx(
                                  () => Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: BorderlessDropDownField(
                                      hint: 'Transaction type',
                                      list: controller.billTypeList.value,
                                      onChanged: (billType) {
                                        controller.billType.value =
                                            (billType as BillTypeModel).value ??
                                                '';
                                      },
                                      selectedItem: null,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                 Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Text('Date Range'.tr,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 180,
                                      child: ClickableTextFormField(
                                        label: 'Start Date'.tr,
                                        suffixIcon:
                                            Icons.calendar_month_outlined,
                                        controller:
                                            controller.startDateController,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1950, 1, 1),
                                            lastDate: DateTime.now(),
                                          ).then((value) {
                                            if (value != null) {
                                              controller.startDateController
                                                      .text =
                                                  '${value.year}-${value.month}-${value.day}';
                                              controller.startDate.value =
                                                  controller
                                                      .startDateController.text;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 180,
                                      child: ClickableTextFormField(
                                        label: 'End Date'.tr,
                                        suffixIcon:
                                            Icons.calendar_month_outlined,
                                        controller:
                                            controller.endDateController,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1950, 1, 1),
                                            lastDate: DateTime.now(),
                                          ).then((value) {
                                            if (value != null) {
                                              controller
                                                      .endDateController.text =
                                                  '${value.year}-${value.month}-${value.day}';
                                              controller.endDate.value =
                                                  controller
                                                      .endDateController.text;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PrimaryButton(
                                      onPressed: () {
                                        controller.getFilterTransactionList();
                                        Get.back();
                                      },
                                      text: 'Submit'.tr,
                                      horizontalPadding: 150,
                                      verticalPadding: 12,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          // backgroundColor: Colors.white,
                        );
                      },
                      child: Image.asset(
                        AppAssets.TRANSACTION_FILTER_ICON,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
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
                      itemCount: controller.transactionList.value.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        TransactionHistoryModel model =
                            controller.transactionList.value[index];

                        return TransactionHistoryTile(
                          transactionHistoryModel: model,
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
