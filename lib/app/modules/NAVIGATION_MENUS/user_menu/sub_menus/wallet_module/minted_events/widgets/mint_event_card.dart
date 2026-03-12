import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/num.dart';
import '../../../../../../../models/wallet_crypto/mint_event_model.dart';
import '../../../../../../../routes/app_pages.dart';

import '../../../../../../../extension/date_time_extension.dart';

class MintEventActionCard extends StatelessWidget {
  final MintEventModel mintEventModel;
  final Function()? onMintPressed;

  const MintEventActionCard({
    super.key,
    required this.mintEventModel,
    this.onMintPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMinted = mintEventModel.isMinted ?? false;
    final hasRequestId = mintEventModel.requestId != null;
    final hasAmount = mintEventModel.amountInWei != null &&
        mintEventModel.amountInWei!.isNotEmpty;

    // Determine colors based on transaction type and theme
    final typeColor =
        isMinted ? theme.colorScheme.primary : theme.colorScheme.error;
    final typeBackgroundColor = isMinted
        ? theme.colorScheme.primary.withValues(alpha: 0.1)
        : theme.colorScheme.error.withValues(alpha: 0.1);

    // Format request ID if available
    final requestIdText = hasRequestId
        ? _formatRequestId(mintEventModel.requestId.toString())
        : 'No Request ID';

    // Format amount if available
    final formattedAmount = hasAmount
        ? (num.parse(mintEventModel.amountInWei!)).toQPFlakes.toString()
        : 'Amount not available';

    return InkWell(
      onTap: () {
        Get.toNamed(Routes.QP_WALLET_TRANSACTION_VIEW,
            arguments: mintEventModel);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isMinted
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.colorScheme.error.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: !isMinted && hasRequestId && hasAmount ? onMintPressed : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // Transaction type icon with improved styling
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: typeBackgroundColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: isMinted
                          ? Icon(
                              Icons.check_circle,
                              color: typeColor,
                              size: 28,
                            )
                          : Center(
                              child: Icon(
                                Icons.touch_app_rounded,
                                color: typeColor,
                                size: 28,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),

                    // Transaction details with improved layout
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Request ID with better styling
                          Row(
                            children: [
                              Text('Request ID: '.tr,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  requestIdText,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'monospace',
                                    letterSpacing: 0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // Timestamp with icon
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                getDynamicFormatedTime(mintEventModel.createdAt
                                        ?.toIso8601String() ??
                                    ''),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Divider for visual separation
                Divider(color: theme.dividerColor.withValues(alpha: 0.3)),

                const SizedBox(height: 8),

                // Amount section with improved styling
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Amount:'.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      formattedAmount,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Status indicator and action button
                if (!isMinted && hasRequestId && hasAmount)
                  ElevatedButton(
                    onPressed: onMintPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          theme.colorScheme.error.withValues(alpha: 0.9),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Mint Now'.tr),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isMinted
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isMinted ? Icons.check_circle : Icons.error_outline,
                          color: typeColor,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isMinted
                              ? 'Successfully Minted'
                              : !hasRequestId
                                  ? 'Missing Request ID'
                                  : !hasAmount
                                      ? 'Missing Amount'
                                      : 'Ready to Mint',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: typeColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to format request ID
  String _formatRequestId(String id) {
    if (id.length <= 12) return id;
    return '${id.substring(0, 6)}...${id.substring(id.length - 6)}';
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
