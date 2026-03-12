import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../models/send_money_model.dart';
import '../../widgets/wallet_dynamic_transaction_history_tile.dart';

import '../../../../../../../components/button.dart';
import '../../../../../../../components/field_title.dart';
import '../../../../../../../components/text_form_field.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../utils/validator.dart';
import '../controllers/qp_wallet_send_money_controller.dart';

class QpWalletSendMoneyView extends GetView<QpWalletSendMoneyController> {
  const QpWalletSendMoneyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money'.tr),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getMoneyTransferHistory();
        },
        child: SingleChildScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // const SizedBox(height: 15),
                // Text(
                //   'Send Money',
                //   style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.bold, fontSize: 20),
                // ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 0.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        // $ ----------------------------------------------------------------------------------

                         FieldTitle(title: 'Recipient Wallet Address'.tr, isRequired: true),
                        PrimaryTextFormField(
                          controller: controller.walletAddressController,
                          keyboardInputType: TextInputType.name,
                          hinText: 'Ex: 4578xDf.....89D6S7csS',
                          validator: ValidatorClass().validateEmpty,
                        ),
                        const SizedBox(height: 10),

                        // $ ----------------------------------------------------------------------------------

                         FieldTitle(title: 'Amount'.tr, isRequired: true),
                        PrimaryTextFormField(
                          keyboardInputType: TextInputType.number,
                          controller: controller.amountController,
                          hinText: 'Amount',
                          validator: ValidatorClass().validateMoney,
                          onChanged: (p0) {
                            controller.calculate();
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        // $ ----------------------------------------------------------------------------------
                         FieldTitle(title: 'Password'.tr, isRequired: true),
                        Obx(
                          () => LoginTextFormField(
                            controller: controller.passwordController,
                            label: 'Password'.tr,
                            obscureText: controller.obscureText.value,
                            suffixIconButton: IconButton(
                              onPressed: () {
                                controller.obscureText.value = !controller.obscureText.value;
                              },
                              icon: Icon(
                                controller.obscureText.value ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                            validationText: 'Password is required',
                          ),
                        ),
                        const SizedBox(height: 10),
                        // $ ----------------------------------------------------------------------------------

                         FieldTitle(title: 'Remarks'.tr, isRequired: false),
                        PrimaryTextFormField(
                          keyboardInputType: TextInputType.text,
                          controller: controller.remarksController,
                          hinText: 'Remarks',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 10),

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

                        const SizedBox(
                          height: 10,
                        ),
                        PrimaryButton(
                          onPressed: () {
                            controller.sendMoney();
                          },
                          text: 'Send Money'.tr,
                          fontSize: 14,
                          horizontalPadding: 106,
                          verticalPadding: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('Money Transfer History'.tr,
                  style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => controller.sendHistoryList.value.isEmpty
                      ?  SizedBox(
                          height: 200,
                          child: Center(
                            child: Text('No Data for preview'.tr),
                          ),
                        )
                      : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: controller.sendHistoryList.value.length,
                          itemBuilder: (context, index) {
                            SendMoneyHistoryModel model = controller.sendHistoryList.value[index];
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
