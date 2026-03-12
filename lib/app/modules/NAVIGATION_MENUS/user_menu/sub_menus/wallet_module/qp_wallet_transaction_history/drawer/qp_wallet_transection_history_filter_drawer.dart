import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../../models/bill_type_model.dart';
import '../controllers/qp_wallet_transaction_history_controller.dart';

import '../../../../../../../components/dropdown.dart';
import '../../../../../../../components/field_title.dart';
import '../../../../../../../components/shimmer_loaders/single_component_shimmer.dart';
import '../../../../../../../components/text_form_field.dart';
import '../../../../../../ad_manager/widgets/ads_creation_navigation_widget.dart';

class WalletHistoryTransactionFilterDrawer extends StatefulWidget {
  const WalletHistoryTransactionFilterDrawer({super.key});

  @override
  State<WalletHistoryTransactionFilterDrawer> createState() =>
      _WalletHistoryTransactionFilterDrawerState();
}

class _WalletHistoryTransactionFilterDrawerState
    extends State<WalletHistoryTransactionFilterDrawer> {
  final controller = Get.find<QpWalletTransactionHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
        child: Column(
          children: [
            Text('Transaction Filters'.tr,
                style: Theme.of(context).appBarTheme.titleTextStyle),
            const SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

            FieldTitle(title: 'Transaction Type'.tr, isRequired: false),
            Obx(
              () {
                if (!controller.walletManagementService
                    .transactionBillTypeIsLoading.value) {
                  return PrimaryDropDownFieldExtended<BillTypeModel>(
                    hint: 'Select Transaction Type',
                    items: controller
                        .walletManagementService.transactionBillTypeList.value,
                    onChanged: (value) {
                      controller.selectedTransactionType.value = value;
                    },
                    selectedItem: controller.selectedTransactionType.value,
                    displayField: (BillTypeModel item) {
                      return item.label.toString();
                    },
                    valueField: (BillTypeModel item) {
                      return item;
                    },
                  );
                } else {
                  return const SingleComponentShimmer();
                }
              },
            ),

            const SizedBox(
              height: 10,
            ),

            // $ ----------------------------------------------------------------------------------

            FieldTitle(title: 'Start Date'.tr, isRequired: true),
            PrimaryTextFormField(
              controller: controller.startDateController,
              onTap: () async {
                await selectDate(context, controller.startDateValue,
                    controller.startDateController);
              },
              hinText: 'Start Date',
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              prefixIconColor: Colors.grey,
              onChanged: (value) {
                return null;
              },
              readOnly: true,
            ),

            // $ ----------------------------------------------------------------------------------

            const SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

            FieldTitle(title: 'End Date'.tr, isRequired: true),
            PrimaryTextFormField(
              controller: controller.endDateController,
              onTap: () async {
                await selectDate(context, controller.endDateValue,
                    controller.endDateController);
              },
              hinText: 'End Date',
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              prefixIconColor: Colors.grey,
              onChanged: (value) {
                return null;
              },
              readOnly: true,
            ),

            const SizedBox(height: 20),

            AdsCreationNavigationWidget(
              actionTitleOne: 'Clear',
              actionTitleTwo: 'Apply',
              actionOneBGColor:
                  Theme.of(context).colorScheme.error.withValues(alpha: 0.6),
              actionOneOnClick: () {
                controller.clearAll();
              },
              actionTwoOnClick: () {
                controller.applyFilter();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context, RxString dateValue,
      TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 1, 1),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      controller.text = formattedDate;
      dateValue.value = pickedDate.toIso8601String();
    }
  }
}
