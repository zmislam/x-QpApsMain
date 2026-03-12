import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../components/button.dart';
import '../../../../../../components/dropdown.dart';
import '../../../../../../components/text_form_field.dart';
import '../../../../../../components/wallet/wallet_drawer_widget.dart';
import '../../../../../../config/constants/color.dart';
import '../../../../../../utils/snackbar.dart';
import '../controllers/wallet_controller.dart';

class PaymentSetting extends GetView<WalletController> {
  const PaymentSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text('Payment Setting'.tr,
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
      body: SizedBox(
        height: Get.height,
        child: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
             Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Add payment method'.tr,
                    style: TextStyle(
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
             Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Card holder name'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Container(
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey.withValues(alpha: 0.5))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    controller: controller.cardNameHolderController,
                    keyboardType: TextInputType.name,
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Card holder name'.tr,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
             Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Card number'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Container(
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey.withValues(alpha: 0.5))),
                child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: controller.cardNumberController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                      ],
                      decoration:  InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Card number'.tr,
                      ),
                      onChanged: (value) {},
                    )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Expiry'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: 180,
                      child:
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child:
                          //   CardExpiryTextFormField(
                          //     controller: controller.cardExpiryController,
                          //     hintText: 'MM/YY'.tr,
                          //   ),
                          // ),
                          Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ClickableTextFormField(
                          suffixIcon: Icons.calendar_month_outlined,
                          label: 'MM/YY'.tr,
                          controller: controller.cardExpiryController,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050, 1, 1),
                            ).then((value) {
                              if (value != null) {
                                controller.cardExpiryController.text =
                                    '${value.month}/${value.year.toString().substring(2, 4)}';
                                controller.cardExpDate.value =
                                    '${value.year}-${value.month}-${value.day}';
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('CVV'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      width: 180,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.5))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controller.cardCVVController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration:  InputDecoration(
                            border: InputBorder.none,
                            hintText: 'CVV'.tr,
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
             Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('Country'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                  height: 60,
                  child: Obx(
                    () => PrimaryDropDownSearchSelect(
                      hintText: 'Country'.tr,
                      items: controller.countryList.value,
                      onChanged: (changedValue) {
                        controller.countryName.value = changedValue!;
                        controller.countryName.refresh();
                      },
                      selectedItem: controller.countryName.value,
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
             Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Postal code'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Container(
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey.withValues(alpha: 0.5))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: controller.postCodeController,
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Postal code'.tr,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => Checkbox(
                    checkColor: Colors.white,
                    activeColor: PRIMARY_COLOR,
                    value: controller.is_default_payment.value,
                    onChanged: (bool? value) {
                      controller.is_default_payment.value = value!;
                    },
                  ),
                ),
                 SizedBox(
                  child: Text('Save card for Default payments'.tr,
                    style: TextStyle(fontSize: 15),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
              onPressed: () {
                if (controller.cardNameHolderController.text.isEmpty &&
                    controller.cardNumberController.text.isEmpty &&
                    controller.cardExpDate.value == '' &&
                    controller.cardCVVController.text.isEmpty &&
                    controller.countryName.value == '' &&
                    controller.postCodeController.text.isEmpty) {
                  showErrorSnackkbar(message: 'Please fill up all the field');
                } else if (controller.cardNameHolderController.text.isEmpty ||
                    controller.cardNumberController.text.isEmpty ||
                    controller.cardExpDate.value == '' ||
                    controller.cardCVVController.text.isEmpty ||
                    controller.countryName.value == '' ||
                    controller.postCodeController.text.isEmpty) {
                  showErrorSnackkbar(message: 'Please fill up all the field');
                } else {
                  controller.addCard();
                }
              },
              text: 'Add Card'.tr,
              horizontalPadding: 125,
              verticalPadding: 15,
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => ListView.builder(
                itemCount: controller.userCardList.value.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 95,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          border: controller.userCardList.value[index]
                                      .isForDefaultPayment ==
                                  true
                              ? Border.all(color: PRIMARY_COLOR, width: 2.0)
                              : Border.all(
                                  color: Colors.grey.withValues(alpha: 0.6),
                                )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Container(
                              height: 60,
                              width: 60,
                              color: PRIMARY_COLOR,
                              child: Center(
                                child: Text(
                                  controller.userCardList.value[index]
                                          .cardHolderName?[0].capitalizeFirst ??
                                      'N',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: Get.width / 2,
                                child: Text(
                                  controller.userCardList.value[index]
                                          .cardHolderName ??
                                      '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              SizedBox(
                                width: Get.width / 2,
                                child: Text(
                                  controller.userCardList.value[index]
                                          .cardNumber ??
                                      '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                              Row(
                                children: [
                                  controller.userCardList.value[index]
                                              .isForDefaultPayment ==
                                          true
                                      ? Text('Default'.tr,
                                          style: TextStyle(
                                              color: controller
                                                          .userCardList
                                                          .value[index]
                                                          .isForDefaultPayment ==
                                                      true
                                                  ? PRIMARY_COLOR
                                                  : Colors.black87,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            controller.setDefaultCard(
                                                controller.userCardList
                                                    .value[index].id
                                                    .toString(),
                                                !controller
                                                    .userCardList
                                                    .value[index]
                                                    .isForDefaultPayment!);
                                          },
                                          child: Text('Set as default'.tr,
                                            style: TextStyle(
                                                color: controller
                                                            .userCardList
                                                            .value[index]
                                                            .isForDefaultPayment ==
                                                        true
                                                    ? PRIMARY_COLOR
                                                    : Colors.black87,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15),
                                          ),
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      showDeleteAlertDialogs(
                                        context: context,
                                        deletingItemType: 'Card',
                                        onDelete: () {
                                          controller.deleteCard(controller
                                              .userCardList.value[index].id
                                              .toString());

                                          Get.back();
                                        },
                                        onCancel: () {
                                          Get.back();
                                        },
                                      );
                                    },
                                    child: Text('Delete'.tr,
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Spacer(),
                          Obx(
                            () => Checkbox(
                              checkColor: Colors.white,
                              activeColor: PRIMARY_COLOR,
                              value: controller.userCardList.value[index]
                                  .isForDefaultPayment,
                              onChanged: (bool? value) {
                                controller.setDefaultCard(
                                    controller.userCardList.value[index].id
                                        .toString(),
                                    !controller.userCardList.value[index]
                                        .isForDefaultPayment!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }))
          ],
        )),
      ),
    );
  }
}
