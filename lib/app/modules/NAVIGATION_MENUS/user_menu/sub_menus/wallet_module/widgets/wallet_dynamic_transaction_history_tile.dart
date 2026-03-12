import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../routes/app_pages.dart';

import '../../../../../../extension/date_time_extension.dart';
import '../../../../../../models/withdraw_model.dart';

class WalletDynamicTransactionHistoryTile extends StatelessWidget {
  final dynamic dynamicModel;
  const WalletDynamicTransactionHistoryTile({
    super.key,
    required this.dynamicModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWithdraw = dynamicModel.type == 'withdraw';
    String withdrawMethod = '';
    if (dynamicModel is WithdrawMoneyModel) {
      debugPrint(dynamicModel.toString());
      WithdrawRequestDetails? data = dynamicModel.withdrawRequestDetails;
      if (data != null) {
        withdrawMethod = data.method ?? '';
        debugPrint(withdrawMethod);
      }
    }

    // ? Determine colors based on transaction type and theme
    final typeColor =
        !isWithdraw ? theme.colorScheme.primary : theme.colorScheme.error;

    final typeBackgroundColor = !isWithdraw
        ? theme.colorScheme.primary.withValues(alpha: 0.1)
        : theme.colorScheme.error.withValues(alpha: 0.1);

    // $ Format the amount with a + or - prefix
    final formattedAmount = !isWithdraw
        ? '+${dynamicModel.amount?.toStringAsFixed(2) ?? 'N/A'}'
        : '-${dynamicModel.amount?.toStringAsFixed(2) ?? 'N/A'}';

    return InkWell(
      onTap: () {
        Get.toNamed(Routes.QP_WALLET_TRANSACTION_VIEW, arguments: dynamicModel);
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Transaction type icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: typeBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isWithdraw ? Icons.arrow_upward : Icons.arrow_downward,
                  color: typeColor,
                ),
              ),
              const SizedBox(width: 16),

              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${withdrawMethod.capitalizeFirst} ${dynamicModel.type?.toString().capitalizeFirst} '
                          .trim(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      getDynamicFormatedTime(dynamicModel.createdAt ?? ''),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              Text(
                formattedAmount,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: typeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getDynamicFormatedTime(String time) {
    DateTime postDateTime;
    if (time.toString() == 'null' || time.isEmpty || time.toString() == '') {
      postDateTime = DateTime.now().toLocal();
    } else {
      postDateTime = DateTime.parse(time).toLocal();
    }
    return postDateTimeFormat.format(postDateTime);
  }
}
