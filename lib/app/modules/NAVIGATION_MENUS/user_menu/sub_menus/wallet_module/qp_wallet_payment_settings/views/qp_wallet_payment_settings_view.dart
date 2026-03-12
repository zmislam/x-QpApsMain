import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../../../components/field_title.dart';
import '../../../../../../../components/text_form_field.dart';
import '../../widgets/credit_card_item_widget.dart';
import '../../../../../../../utils/validator.dart';

import '../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../../components/button.dart';
import '../../../../../../../components/dropdown.dart';
import '../../../../../../../components/shimmer_loaders/single_component_shimmer.dart';
import '../../../../../../../config/constants/color.dart';
import '../controllers/qp_wallet_payment_settings_controller.dart';

class QpWalletPaymentSettingsView extends GetView<QpWalletPaymentSettingsController> {
  const QpWalletPaymentSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Settings'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text('Add payment method'.tr,
                style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.bold, fontSize: 20),
              ),
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

                       FieldTitle(title: 'Card holder name'.tr, isRequired: true),
                      PrimaryTextFormField(
                        controller: controller.cardNameHolderController,
                        keyboardInputType: TextInputType.name,
                        hinText: 'Card Holder Name',
                        validator: ValidatorClass().validateName,
                      ),
                      const SizedBox(height: 10),

                      // $ ----------------------------------------------------------------------------------

                       FieldTitle(title: 'Card number'.tr, isRequired: true),
                      PrimaryTextFormField(
                        keyboardInputType: TextInputType.number,
                        controller: controller.cardNumberController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(16),
                        ],
                        hinText: 'Card number',
                        validator: ValidatorClass().validateNumberLength16,
                      ),
                      const SizedBox(height: 10),

                      // $ ----------------------------------------------------------------------------------

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // $ ----------------------------------------------------------------------------------

                                 FieldTitle(title: 'Expiry'.tr, isRequired: true),
                                PrimaryTextFormField(
                                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                                  label: 'MM/YY'.tr,
                                  controller: controller.cardExpiryController,
                                  readOnly: true,
                                  validationText: 'Invalid Input',
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2050, 1, 1),
                                    ).then((value) {
                                      if (value != null) {
                                        controller.cardExpiryController.text = '${value.month}/${value.year.toString().substring(2, 4)}';
                                        controller.cardExpDate.value = '${value.year}-${value.month}-${value.day}';
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          // $ ----------------------------------------------------------------------------------

                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 FieldTitle(title: 'CCV'.tr, isRequired: true),
                                PrimaryTextFormField(
                                  keyboardInputType: TextInputType.number,
                                  controller: controller.cardCVVController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  validator: ValidatorClass().validateNumberLength4,
                                  hinText: 'CVV',
                                  onChanged: (value) {
                                    return null;
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),

                      // $ ----------------------------------------------------------------------------------

                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 FieldTitle(title: 'Country'.tr, isRequired: true),
                                Obx(
                                  () {
                                    if (!controller.walletManagementService.countryIsLoading.value) {
                                      return PrimaryDropDownField(
                                        hint: 'Select Country',
                                        list: controller.walletManagementService.countryList.value,
                                        validationText: 'Please select a country',
                                        isExpanded: true,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                        onChanged: (value) {
                                          controller.selectedCountryController.text = value ?? '';
                                        },
                                        value: controller.selectedCountryController.text.isEmpty ? null : controller.selectedCountryController.text,
                                      );
                                    } else {
                                      return const SingleComponentShimmer();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),

                          // $ ----------------------------------------------------------------------------------

                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                 FieldTitle(title: 'Postal Code'.tr, isRequired: true),
                                PrimaryTextFormField(
                                  keyboardInputType: TextInputType.text,
                                  controller: controller.postCodeController,
                                  hinText: 'Postal code',
                                  validator: ValidatorClass().validateNumberLength4,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 10),

                      // $ ----------------------------------------------------------------------------------

                      Obx(
                        () => CheckboxListTile(
                          checkColor: Colors.white,
                          activeColor: PRIMARY_COLOR,
                          value: controller.is_default_payment.value,
                          onChanged: (bool? value) {
                            controller.is_default_payment.value = value!;
                          },
                          contentPadding: const EdgeInsets.only(left: 15, right: 5),
                          tileColor: Colors.grey.shade50,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          title: Text('Save card for Default payments'.tr,
                            style: TextStyle(fontSize: 15),
                            maxLines: 3,
                          ),
                        ),
                      ),

                      // $ ----------------------------------------------------------------------------------

                      const SizedBox(
                        height: 20,
                      ),
                      PrimaryButton(
                        onPressed: () {
                          controller.addCard();
                        },
                        text: 'Add Card'.tr,
                        fontSize: 14,
                        horizontalPadding: 115,
                        verticalPadding: 15,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('User Cards'.tr,
                style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Obx(() => controller.walletManagementService.userCardList.value.isEmpty
                  ?  SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('No Data for preview'.tr),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.walletManagementService.userCardList.value.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CreditCardItem(
                          index: index,
                          controller: controller,
                          PRIMARY_COLOR: PRIMARY_COLOR,
                          showDeleteAlertDialogs: showDeleteAlertDialogs,
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
