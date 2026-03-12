import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditCardItem extends StatelessWidget {
  final int index;
  final dynamic controller;
  final Color PRIMARY_COLOR;
  final Function showDeleteAlertDialogs;

  const CreditCardItem({
    Key? key,
    required this.index,
    required this.controller,
    required this.PRIMARY_COLOR,
    required this.showDeleteAlertDialogs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 130,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha:0.05),
          //     blurRadius: 10,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: controller.walletManagementService.userCardList.value[index].isForDefaultPayment == true
          //       ? [
          //           PRIMARY_COLOR.withValues(alpha:0.1),
          //           Colors.white,
          //         ]
          //       : [
          //           Colors.grey.withValues(alpha:0.05),
          //           Colors.white,
          //         ],
          // ),
          border: controller.walletManagementService.userCardList.value[index]
                      .isForDefaultPayment ==
                  true
              ? Border.all(color: PRIMARY_COLOR, width: 2.0)
              : Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Stack(
          children: [
            // Default indicator
            if (controller.walletManagementService.userCardList.value[index]
                    .isForDefaultPayment ==
                true)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('DEFAULT'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            Row(
              children: [
                // Card avatar
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: PRIMARY_COLOR.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        controller.walletManagementService.userCardList
                                .value[index].cardHolderName?[0]
                                .toString()
                                .capitalizeFirst ??
                            'N',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Card details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.walletManagementService.userCardList
                                  .value[index].cardHolderName ??
                              '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.walletManagementService.userCardList
                                  .value[index].cardNumber ??
                              '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Action buttons
                        Row(
                          children: [
                            if (controller.walletManagementService.userCardList
                                    .value[index].isForDefaultPayment !=
                                true)
                              InkWell(
                                onTap: () {
                                  controller.setDefaultCard(
                                    cardId: controller.walletManagementService
                                        .userCardList.value[index].id
                                        .toString(),
                                    isForDefaultPayment: !controller
                                        .walletManagementService
                                        .userCardList
                                        .value[index]
                                        .isForDefaultPayment!,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: PRIMARY_COLOR),
                                  ),
                                  child: Text('Set as default'.tr,
                                    style: TextStyle(
                                      color: PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                showDeleteAlertDialogs(
                                  context: context,
                                  deletingItemType: 'Card',
                                  onDelete: () {
                                    controller.deleteCard(
                                        cardId: controller
                                            .walletManagementService
                                            .userCardList
                                            .value[index]
                                            .id
                                            .toString());
                                    Get.back();
                                  },
                                  onCancel: () {
                                    Get.back();
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: Colors.red.shade300),
                                ),
                                child: Text('Delete'.tr,
                                  style: TextStyle(
                                    color: Colors.red.shade400,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Checkbox
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        checkColor: Colors.white,
                        activeColor: PRIMARY_COLOR,
                        value: controller.walletManagementService.userCardList
                            .value[index].isForDefaultPayment,
                        onChanged: (bool? value) {
                          controller.setDefaultCard(
                            cardId: controller.walletManagementService
                                .userCardList.value[index].id
                                .toString(),
                            isForDefaultPayment: !controller
                                .walletManagementService
                                .userCardList
                                .value[index]
                                .isForDefaultPayment!,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
