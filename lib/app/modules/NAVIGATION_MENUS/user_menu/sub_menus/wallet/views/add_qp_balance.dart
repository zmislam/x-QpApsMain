import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../components/button.dart';
import '../../../../../../components/dropdown.dart';
import '../../../../../../components/text_form_field.dart';
import '../../../../../../components/wallet/wallet_drawer_widget.dart';
import '../../../../../../models/card_detail_model.dart';
import '../../../../../../utils/snackbar.dart';
import '../../../../../../utils/validator.dart';
import '../controllers/wallet_controller.dart';

class AddQpBalance extends GetView<WalletController> {
  const AddQpBalance({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text('QP-Wallet'.tr,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
           Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text('How much would you like to Deposit? '.tr,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
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
                  label: 'Enter Amount'.tr,
                  controller: controller.sendAmountController,
                  inputType: TextInputType.number,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
           Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text('From '.tr,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
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
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: PrimaryButton(
              onPressed: () {
                if (controller.sendAmountController.text.isEmpty &&
                    controller.cardNumber.value == '') {
                  showErrorSnackkbar(message: 'Please fill up all the field');
                } else if (controller.sendAmountController.text.isEmpty &&
                    controller.cardNumber.value == '') {
                  showErrorSnackkbar(message: 'Please fill up all the field');
                } else if (!amountValidationRegex.hasMatch(
                    controller.sendAmountController.text.toString())) {
                  showErrorSnackkbar(message: 'Enter valid amount ');
                } else {
                  controller.makePayment();
                }
              },
              text: 'Add QP Balance'.tr,
              horizontalPadding: 120,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
