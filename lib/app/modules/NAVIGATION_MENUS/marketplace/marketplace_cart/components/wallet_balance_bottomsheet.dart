import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../../user_menu/sub_menus/wallet/controllers/wallet_controller.dart';
import '../../../user_menu/sub_menus/wallet/views/add_qp_balance.dart';

class CheckoutWalletBottomSheet extends StatelessWidget {
  final CartController controller = Get.put(CartController());
  final WalletController walletController = Get.put(WalletController());
  final double totalPayable;

  CheckoutWalletBottomSheet({
    super.key,
    required this.totalPayable,
  });

  @override
  Widget build(BuildContext context) {
    controller.getWalletSummery();

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Product Purchase'.tr,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  'assets/icon/navbar/cross_rec.png',
                  width: 35,
                  height: 35,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
           Row(
            children: [
              Text('Payment Amount'.tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            readOnly: true,
            controller:
                TextEditingController(text: totalPayable.toStringAsFixed(2)),
            decoration: InputDecoration(
              suffixText: '\$ QP',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
          const SizedBox(height: 20),
           Row(
            children: [
              Text('Current QP Balance'.tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        readOnly: true,
                        controller: TextEditingController(
                            text:
                                (controller.wallerSummery.value.walletBalance ??
                                        0.0)
                                    .toStringAsFixed(2)),
                        decoration: InputDecoration(
                          suffixText: '\$ QP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(const AddQpBalance());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF317773),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Add Balance'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 20),
          Obx(() {
            double walletBalance =
                controller.wallerSummery.value.walletBalance ?? 0.0;
            bool hasSufficientBalance = walletBalance >= totalPayable;

            return ElevatedButton(
              onPressed: hasSufficientBalance
                  ? () {
                      controller.placeOrder();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    hasSufficientBalance ? const Color(0xFF317773) : Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                hasSufficientBalance ? 'Checkout' : 'Insufficient Balance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: hasSufficientBalance ? Colors.white : Colors.red,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
