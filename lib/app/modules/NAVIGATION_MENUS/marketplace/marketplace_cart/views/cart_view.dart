import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../components/address_step.dart';
import '../components/cart_review_step.dart';
import '../components/checkout_step_indicator.dart';
import '../components/payment_step.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.wait([controller.getCartDetails(), controller.getAddressList()]);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
        leading: IconButton(
          onPressed: () {
            if (controller.currentStep.value != CheckoutStep.cartReview) {
              controller.previousStep();
            } else {
              Get.back();
            }
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        title: Obx(() => Text(
              _stepTitle(controller.currentStep.value),
              style: MarketplaceDesignTokens.heading(context),
            )),
        actions: [
          // Cart item count badge
          Obx(() {
            if (controller.currentStep.value != CheckoutStep.cartReview) {
              return const SizedBox.shrink();
            }
            final count = controller.storeDetailsList.fold<int>(
                0, (sum, s) => sum + (s.myProduct?.length ?? 0));
            if (count == 0) return const SizedBox.shrink();
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        MarketplaceDesignTokens.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusSm),
                  ),
                  child: Text(
                    '$count item${count != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: MarketplaceDesignTokens.primary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Obx(() => CheckoutStepIndicator(
                currentStep: controller.stepIndex,
              )),
        ),
      ),
      body: Obx(() {
        switch (controller.currentStep.value) {
          case CheckoutStep.cartReview:
            return const CartReviewStep();
          case CheckoutStep.address:
            return const AddressStep();
          case CheckoutStep.payment:
            return const PaymentStep();
        }
      }),
    );
  }

  String _stepTitle(CheckoutStep step) {
    switch (step) {
      case CheckoutStep.cartReview:
        return 'My Cart';
      case CheckoutStep.address:
        return 'Shipping Address';
      case CheckoutStep.payment:
        return 'Payment';
    }
  }
}
