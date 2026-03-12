import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../models/withdraw_model.dart';

import '../../../../../../../components/button.dart';
import '../../../../../../../components/dropdown.dart';
import '../../../../../../../components/field_title.dart';
import '../../../../../../../components/shimmer_loaders/single_component_shimmer.dart';
import '../../../../../../../components/text_form_field.dart';
import '../../../../../../../models/card_detail_model.dart';
import '../../../../../../../utils/validator.dart';
import '../../widgets/wallet_dynamic_transaction_history_tile.dart';
import '../controllers/qp_wallet_withdraw_controller.dart';

class QpWalletWithdrawView extends GetView<QpWalletWithdrawController> {
  const QpWalletWithdrawView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Withdraw'.tr),
          centerTitle: true,
          bottom: const TabBar(
            padding: EdgeInsets.zero,
            tabs: [
              Tab(icon: Icon(Icons.credit_card, size: 25)),
              Tab(icon: Icon(Icons.apartment_rounded, size: 25)),
              Tab(icon: Icon(Icons.history, size: 25)),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TabBarView(
            children: [
              // Card Withdrawal Tab
              _buildCardWithdrawForm(context),
              // Bank Withdrawal Tab
              _buildBankWithdrawForm(context),
              // Money Transfer History Tab
              RefreshIndicator(
                  onRefresh: () async {
                    await controller.getWithDrawHistory();
                  },
                  child: _buildTransferHistoryTab(context)),
            ],
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
      ),
    );
  }

  Widget _buildCardWithdrawForm(BuildContext context) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Card Withdraw'.tr,
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Text('Withdraw your QP Flex to your card'.tr,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, fontSize: 13),
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
                  const SizedBox(height: 10),

                  // $ ----------------------------------------------------------------------------------

                   FieldTitle(title: 'Amount'.tr, isRequired: true),
                  PrimaryTextFormField(
                    keyboardInputType: TextInputType.number,
                    controller: controller.amountController,
                    hinText: 'Amount',
                    validator: ValidatorClass().validateMoney,
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

                  const SizedBox(
                    height: 10,
                  ),
                  PrimaryButton(
                    onPressed: () {
                      controller.withdrawMoney();
                    },
                    text: 'Withdraw'.tr,
                    fontSize: 14,
                    horizontalPadding: 105,
                    verticalPadding: 15,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBankWithdrawForm(BuildContext context) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Bank Withdraw'.tr,
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Text('Withdraw your QP Flex to your bank account'.tr,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, fontSize: 13),
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
              key: controller.bankFormKey, // You'll need to add this to your controller
              child: Column(
                children: [
                  // Amount Field
                   FieldTitle(title: 'Amount'.tr, isRequired: true),
                  PrimaryTextFormField(
                    keyboardInputType: TextInputType.number,
                    controller: controller.bankAmountController, // You'll need to add this to your controller
                    hinText: 'Amount',
                    validator: ValidatorClass().validateMoney,
                  ),
                  const SizedBox(height: 10),

                  // QP Account Password
                   FieldTitle(title: 'QP Account Password'.tr, isRequired: true),
                  Obx(
                    () => LoginTextFormField(
                      controller: controller.bankPasswordController, // You'll need to add this to your controller
                      label: 'QP Account Password'.tr,
                      obscureText: controller.obscureText.value, // You'll need to add this to your controller
                      suffixIconButton: IconButton(
                        onPressed: () {
                          controller.obscureText.value = !controller.obscureText.value;
                        },
                        icon: Icon(
                          controller.obscureText.value ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      validationText: 'QP Account Password is required',
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Account Holder Name
                   FieldTitle(title: 'Account Holder Name'.tr, isRequired: true),
                  PrimaryTextFormField(
                    keyboardInputType: TextInputType.text,
                    controller: controller.accountHolderNameController, // You'll need to add this to your controller
                    hinText: 'Enter Account Holder Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Account Holder Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Bank Name
                   FieldTitle(title: 'Bank Name'.tr, isRequired: true),
                  PrimaryTextFormField(
                    keyboardInputType: TextInputType.text,
                    controller: controller.bankNameController, // You'll need to add this to your controller
                    hinText: 'Enter Bank Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bank Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Account Number
                   FieldTitle(title: 'Account Number'.tr, isRequired: true),
                  PrimaryTextFormField(
                    keyboardInputType: TextInputType.number,
                    controller: controller.accountNumberController, // You'll need to add this to your controller
                    hinText: 'Enter Account Number',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Account Number is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Routing Number
                   FieldTitle(title: 'Routing Number'.tr, isRequired: true),
                  PrimaryTextFormField(
                    keyboardInputType: TextInputType.number,
                    controller: controller.routingNumberController, // You'll need to add this to your controller
                    hinText: 'Enter Routing Number',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Routing Number is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Remarks (Optional)
                   FieldTitle(title: 'Remarks'.tr, isRequired: false),
                  PrimaryTextFormField(
                    keyboardInputType: TextInputType.text,
                    controller: controller.bankRemarksController, // You'll need to add this to your controller
                    hinText: 'Remarks (Optional)',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),

                  const SizedBox(height: 10),
                  PrimaryButton(
                    onPressed: () {
                      controller.withdrawMoneyWithBank(); // You'll need to add this method to your controller
                    },
                    text: 'Withdraw'.tr,
                    fontSize: 14,
                    horizontalPadding: 105,
                    verticalPadding: 15,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTransferHistoryTab(BuildContext context) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Transfer History'.tr,
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Text('All available transfer history of your account'.tr,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Obx(
            () => controller.withdrawHistoryList.value.isEmpty
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
                    itemCount: controller.withdrawHistoryList.value.length,
                    itemBuilder: (context, index) {
                      WithdrawMoneyModel model = controller.withdrawHistoryList.value[index];
                      return WalletDynamicTransactionHistoryTile(
                        dynamicModel: model,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                  ),
          ),
        ],
      ),
    );
  }
}
