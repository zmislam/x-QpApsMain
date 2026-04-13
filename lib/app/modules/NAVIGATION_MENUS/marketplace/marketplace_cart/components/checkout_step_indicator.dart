import 'package:flutter/material.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';

class CheckoutStepIndicator extends StatelessWidget {
  final int currentStep;
  final VoidCallback? onStepTap;

  const CheckoutStepIndicator({
    super.key,
    required this.currentStep,
    this.onStepTap,
  });

  static const _steps = ['Cart Review', 'Address', 'Payment'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: MarketplaceDesignTokens.cardBg(context),
        boxShadow: [MarketplaceDesignTokens.cardShadow],
      ),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepBefore = index ~/ 2;
            final isCompleted = stepBefore < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: isCompleted
                    ? MarketplaceDesignTokens.primary
                    : Colors.grey.shade300,
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final isActive = stepIndex == currentStep;
          final isCompleted = stepIndex < currentStep;

          return GestureDetector(
            onTap: stepIndex < currentStep ? () {} : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? MarketplaceDesignTokens.primary
                        : isActive
                            ? MarketplaceDesignTokens.primary
                            : Colors.grey.shade300,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text(
                            '${stepIndex + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.grey.shade600,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _steps[stepIndex],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive || isCompleted
                        ? MarketplaceDesignTokens.primary
                        : MarketplaceDesignTokens.textSecondary(context),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
