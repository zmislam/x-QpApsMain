import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../components/button.dart';
import '../../../../../../components/text_form_field.dart';
import '../../../../../../components/wallet/transaction_header.dart';
import '../../../../../../components/wallet/transaction_history_tile.dart';
import '../../../../../../components/wallet/wallet_drawer_widget.dart';
import '../../../../../../models/send_money_model.dart';
import '../../../../../../utils/snackbar.dart';
import '../../../../../../utils/validator.dart';
import '../controllers/wallet_controller.dart';

class SendMoneyView extends GetView<WalletController> {
  @override
  WalletController controller = Get.find();

  SendMoneyView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getSendMoneyList();

    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text('Send Money'.tr,
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
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: BorderlessTextFormField(
                  label: 'Recipient email'.tr,
                  controller: controller.sendRecipientController,
                  inputType: TextInputType.emailAddress,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: BorderlessTextFormField(
                  label: 'Amount'.tr,
                  controller: controller.sendAmountController,
                  inputType: TextInputType.number,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: BorderlessTextFormField(
                    label: 'Enter QP password'.tr,
                    controller: controller.passwordController,
                    obscureText: controller.obscureText.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.obscureText.value =
                            !controller.obscureText.value;
                      },
                      icon: Icon(
                        controller.obscureText.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: BorderlessTextFormField(
                  label: 'Remarks (optional)'.tr,
                  controller: controller.remarkController,
                  maxLines: 3,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          PrimaryButton(
            onPressed: () {
              if (controller.sendAmountController.text.isEmpty &&
                  controller.sendRecipientController.text.isEmpty &&
                  controller.passwordController.text.isEmpty) {
                showErrorSnackkbar(message: 'Please fill up all the field');
              } else if (controller.sendAmountController.text.isEmpty ||
                  controller.sendRecipientController.text.isEmpty ||
                  controller.passwordController.text.isEmpty) {
                showErrorSnackkbar(message: 'Please fill up all the field');
              } else if (!controller.sendAmountController.text.isEmail &&
                  !amountValidationRegex.hasMatch(
                      controller.sendAmountController.text.toString())) {
                showErrorSnackkbar(message: 'Please enter valid input ');
              } else if (!controller.sendAmountController.text.isEmail ||
                  !amountValidationRegex.hasMatch(
                      controller.sendAmountController.text.toString())) {
                showErrorSnackkbar(message: 'Please enter valid input ');
              } else {
                controller.sendMoney();
              }
            },
            text: 'Send Money'.tr,
            horizontalPadding: 125,
            verticalPadding: 15,
          ),
          const SizedBox(
            height: 15,
          ),
           Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Recent Send Money History'.tr,
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
            thirdTitle: 'Bill Type',
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(() => Expanded(
                  child: ListView.separated(
                itemCount: controller.sendHistoryList.value.length,
                itemBuilder: (context, index) {
                  SendMoneyHistoryModel model =
                      controller.sendHistoryList.value[index];

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
    );
  }
}
