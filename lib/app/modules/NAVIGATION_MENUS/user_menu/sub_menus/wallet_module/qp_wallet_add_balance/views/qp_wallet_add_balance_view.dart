import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/button.dart';
import '../../../../../../../models/card_detail_model.dart';

import '../../../../../../../components/dropdown.dart';
import '../../../../../../../components/field_title.dart';
import '../../../../../../../components/shimmer_loaders/single_component_shimmer.dart';
import '../../../../../../../components/text_form_field.dart';
import '../../../../../../../utils/validator.dart';
import '../controllers/qp_wallet_add_balance_controller.dart';

class QpWalletAddBalanceView extends GetView<QpWalletAddBalanceController> {
  const QpWalletAddBalanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add QP Balance'.tr),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FieldTitle(title: 'Amount'.tr, isRequired: true),
                PrimaryTextFormField(
                  controller: controller.amountController,
                  hinText: '0.00',
                  keyboardInputType: TextInputType.number,
                  validator: ValidatorClass().validateMoneyWithFiveMinValue,
                  onChanged: (p0) {
                    controller.calculate();
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // $ ----------------------------------------------------------------------------------

                FieldTitle(title: 'Select Card'.tr, isRequired: true),

                Obx(
                  () {
                    if (!controller.walletManagementService.userCardIsLoading.value && controller.walletManagementService.userCardList.value.isNotEmpty) {
                      return PrimaryDropDownFieldExtended<CardDetailsModel>(
                        hint: 'Select Card',
                        items: controller.walletManagementService.userCardList.value,
                        onChanged: (value) {
                          controller.selectedCard.value = value;
                        },
                        selectedItem: controller.selectedCard.value,
                        validationText: 'Please select a card',
                        displayField: (CardDetailsModel item) {
                          return item.cardNumber.toString();
                        },
                        valueField: (CardDetailsModel item) {
                          return item;
                        },
                      );
                    } else if (!controller.walletManagementService.userCardIsLoading.value && controller.walletManagementService.userCardList.value.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryDropDownFieldExtended<CardDetailsModel>(
                              hint: 'Select Card',
                              items: const [],
                              onChanged: (value) {
                                controller.selectedCard.value = value;
                              },
                              selectedItem: null,
                              validationText: 'Please select a card',
                              displayField: (CardDetailsModel item) {
                                return item.cardNumber.toString();
                              },
                              valueField: (CardDetailsModel item) {
                                return item;
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Please add a card first to continue'.tr),
                            const SizedBox(
                              height: 5,
                            ),
                            PrimaryIconButton(
                              onPressed: () {
                                controller.goToAddCardPage();
                              },
                              text: 'Add Card'.tr,
                              iconWidget: const Icon(
                                Icons.arrow_circle_right_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SingleComponentShimmer();
                    }
                  },
                ),

                // $ ----------------------------------------------------------------------------------

                Obx(() {
                  if (controller.commissionAmount.value.isNotEmpty && controller.amountController.text.isNotEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Theme.of(context).primaryColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Commission Rate: ${controller.commissionPercent.value}'.tr),
                          const SizedBox(height: 8),
                          Text('Commission Amount: ${controller.commissionAmount.value}'.tr),
                          const SizedBox(height: 8),
                          Text('Final Amount: ${controller.receivableAmount.value}'.tr),
                          const SizedBox(height: 12),
                          Text('Commission is automatically deducted from your transaction.'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),

                // $ ----------------------------------------------------------------------------------

                const SizedBox(height: 10),
                PrimaryIconButton(
                  onPressed: () {
                    controller.validateFormAndSendPayment();
                  },
                  text: 'Add Balance'.tr,
                  iconWidget: const Icon(
                    Icons.attach_money,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
