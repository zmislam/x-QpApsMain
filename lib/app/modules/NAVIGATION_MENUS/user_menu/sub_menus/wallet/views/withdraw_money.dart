import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/wallet/wallet_drawer_widget.dart';
import '../../../../../../components/button.dart';
import '../../../../../../components/dropdown.dart';
import '../../../../../../components/text_form_field.dart';
import '../../../../../../components/wallet/transaction_header.dart';
import '../../../../../../components/wallet/transaction_history_tile.dart';
import '../../../../../../models/card_detail_model.dart';
import '../../../../../../models/withdraw_model.dart';
import '../../../../../../utils/snackbar.dart';
import '../../../../../../utils/validator.dart';
import '../controllers/wallet_controller.dart';

class WithdrawMoney extends GetView<WalletController> {
  @override
  final WalletController controller = Get.find();

  WithdrawMoney({super.key});

  @override
  Widget build(BuildContext context) {
    controller.geWithdrawMoneyList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text('Withdraw'.tr,
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
                  label: 'Withdraw Amount'.tr,
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
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: BorderlessDropDownField(
                hint: 'Card Number',
                list: controller.userCardList.value,
                onChanged: (cardNumber) {
                  controller.cardNumber.value =
                      (cardNumber as CardDetailsModel).id ?? '';
                  controller.dropdownValue.value = cardNumber;
                  controller.dropdownValue.refresh();
                },
                selectedItem: controller.dropdownValue.value,
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
                  controller.cardNumber.value == '' &&
                  controller.passwordController.text.isEmpty) {
                showErrorSnackkbar(message: 'Please fill up all the field');
              } else if (controller.sendAmountController.text.isEmpty ||
                  controller.cardNumber.value == '' ||
                  controller.passwordController.text.isEmpty) {
                showErrorSnackkbar(message: 'Please fill up all the field');
              } else if (!amountValidationRegex
                  .hasMatch(controller.sendAmountController.text.toString())) {
                showErrorSnackkbar(message: 'Enter valid amount ');
              } else {
                controller.withdrawMoney();
              }
            },
            text: 'Withdraw'.tr,
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
                child: Text('Withdraw History'.tr,
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
                itemCount: controller.withdrawHistoryList.value.length,
                itemBuilder: (context, index) {
                  WithdrawMoneyModel model =
                      controller.withdrawHistoryList.value[index];

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
