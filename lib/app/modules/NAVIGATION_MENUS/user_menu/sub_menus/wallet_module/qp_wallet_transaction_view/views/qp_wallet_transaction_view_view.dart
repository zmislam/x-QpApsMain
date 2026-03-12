import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/qp_wallet_transaction_view_controller.dart';

class QpWalletTransactionViewView
    extends GetView<QpWalletTransactionViewController> {
  const QpWalletTransactionViewView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Check if model exists
    if (controller.model == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Transaction Receipt'.tr),
          centerTitle: true,
        ),
        body: Center(
          child: Text('No transaction data available'.tr),
        ),
      );
    }

    final modelMap = _convertObjectToMap(controller.model!);
    final receiptData = _processReceiptData(modelMap);
    print((modelMap));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(controller.title ?? 'Transaction Receipt'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Receipt Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Receipt Header
                  _buildReceiptHeader(context, receiptData),

                  // Dotted Line Separator
                  _buildDottedLine(),

                  // Receipt Body
                  _buildReceiptBody(context, receiptData),

                  // Dotted Line Separator
                  _buildDottedLine(),

                  // Receipt Footer
                  _buildReceiptFooter(context, receiptData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _convertObjectToMap(Object obj) {
    if (obj is Map<String, dynamic>) {
      return obj;
    }

    // Try to convert using toJson if available
    try {
      final dynamic objDynamic = obj;
      if (objDynamic.toJson != null) {
        return objDynamic.toJson() as Map<String, dynamic>;
      }
    } catch (e) {
      // Fallback to reflection-like approach
    }

    // Fallback: convert using toString and manual parsing
    final objString = obj.toString();
    final Map<String, dynamic> result = {};

    // Basic parsing for model toString format
    final lines = objString.split('\n');
    for (final line in lines) {
      if (line.contains(':')) {
        final parts = line.split(':');
        if (parts.length >= 2) {
          final key = parts[0].trim().replaceAll(RegExp(r'[{}]'), '');
          final value = parts.sublist(1).join(':').trim().replaceAll(',', '');
          if (key.isNotEmpty && key != obj.runtimeType.toString()) {
            result[key] = value == 'null' ? null : value;
          }
        }
      }
    }

    return result;
  }

  ReceiptData _processReceiptData(Map<String, dynamic> modelMap) {
    final data = ReceiptData();

    modelMap.forEach((key, value) {
      if (value == null || _shouldSkipField(key)) return;

      final lowerKey = key.toLowerCase();
      final valueStr = value.toString();

      // Process transaction status
      if (_isStatusField(lowerKey)) {
        data.status = _determineTransactionStatus(key, valueStr);
        data.transactionType = _determineTransactionType(key, valueStr);
      }
      // Process amounts
      else if (_isAmountField(lowerKey)) {
        data.amounts[_formatFieldName(key)] = _formatAmount(valueStr);
      }
      // Process highlighted fields (addresses, request IDs)
      else if (_isHighlightField(lowerKey)) {
        data.highlightedFields[_formatFieldName(key)] = valueStr;
      }
      // Process dates
      else if (_isDateField(lowerKey)) {
        data.dates[_formatFieldName(key)] = _formatReceiptDate(valueStr);
      }
      // Process transaction type
      else if (_isTypeField(lowerKey)) {
        if (data.transactionType.isEmpty) {
          data.transactionType = _capitalizeFirst(valueStr);
        }
      }
      // Other important fields
      else if (!_shouldSkipField(key)) {
        data.otherFields[_formatFieldName(key)] = valueStr;
      }
    });

    // Set default transaction type if not determined
    if (data.transactionType.isEmpty) {
      data.transactionType = 'Transaction';
    }

    return data;
  }

  bool _shouldSkipField(String key) {
    final lowerKey = key.toLowerCase();
    return lowerKey.contains('userid') ||
        lowerKey.contains('user_id') ||
        lowerKey.contains('walletbill') ||
        lowerKey.contains('wallet_bill') ||
        lowerKey.contains('queue') ||
        lowerKey.contains('createdb') ||
        lowerKey.contains('updatedb') ||
        lowerKey == 'v' ||
        lowerKey == 'r' ||
        lowerKey == 's' ||
        lowerKey == '__v';
  }

  bool _isAmountField(String key) {
    return key.contains('amount') ||
        key.contains('balance') ||
        key.contains('paid') ||
        key.contains('wei');
  }

  bool _isHighlightField(String key) {
    final lowerKey = key.toLowerCase();
    return lowerKey.contains('address') ||
        lowerKey == 'to' ||
        lowerKey == 'from' ||
        lowerKey.contains('requestid') ||
        lowerKey.contains('request_id') ||
        lowerKey.contains('signature');
  }

  bool _isDateField(String key) {
    return key.contains('date') ||
        key.contains('time') ||
        key.contains('created') ||
        key.contains('updated');
  }

  bool _isStatusField(String key) {
    return key.contains('minted') ||
        key.contains('sent') ||
        key.contains('withdrawn') ||
        key.contains('status');
  }

  bool _isTypeField(String key) {
    return key == 'type' || key.contains('bill_type');
  }

  String _determineTransactionStatus(String key, String value) {
    final lowerKey = key.toLowerCase();
    final lowerValue = value.toLowerCase();

    if (lowerKey.contains('minted')) {
      return lowerValue == 'true' ? 'Completed' : 'Pending';
    } else if (lowerKey.contains('sent')) {
      return lowerValue == 'true' ? 'Sent' : 'Pending';
    } else if (lowerKey.contains('withdrawn')) {
      return lowerValue == 'true' ? 'Withdrawn' : 'Pending';
    } else if (lowerKey.contains('status')) {
      return _capitalizeFirst(value);
    }

    return 'Unknown';
  }

  String _determineTransactionType(String key, String value) {
    final lowerKey = key.toLowerCase();

    if (lowerKey.contains('mint')) {
      return 'Mint Token';
    } else if (lowerKey.contains('sent') || lowerKey.contains('send')) {
      return 'Send Money';
    } else if (lowerKey.contains('withdraw')) {
      return 'Withdraw';
    } else if (lowerKey.contains('deposit')) {
      return 'Deposit';
    }

    return '';
  }

  String _formatFieldName(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatAmount(String amount) {
    try {
      final num = double.parse(amount);

      if (amount.length > 10) {
        return 'QPG ${num.toString().split('.').first}';
      }

      return '\$${num.toStringAsFixed(2)}';
    } catch (e) {
      return amount;
    }
  }

  String _formatReceiptDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      final day = _getOrdinalNumber(dateTime.day);
      final month = months[dateTime.month - 1];
      final year = dateTime.year;

      final hour = dateTime.hour == 0
          ? 12
          : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';

      return '$day $month $year, at $hour:$minute $period';
    } catch (e) {
      return date;
    }
  }

  String _getOrdinalNumber(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildReceiptHeader(BuildContext context, ReceiptData data) {
    final theme = Theme.of(context);
    final isSuccess = data.status.toLowerCase().contains('completed') ||
        data.status.toLowerCase().contains('sent') ||
        data.status.toLowerCase().contains('success') ||
        data.status.toLowerCase().contains('withdrawn') ||
        data.status.toLowerCase().contains('unknown');

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Transaction Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isSuccess
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? Icons.check_circle : Icons.schedule,
              size: 40,
              color: isSuccess ? Colors.green : Colors.orange,
            ),
          ),

          const SizedBox(height: 16),

          // Transaction Type
          Text(
            data.transactionType,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data.status.toLowerCase().contains('unknown')
                  ? 'Completed'
                  : data.status,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptBody(BuildContext context, ReceiptData data) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Amounts Section
          if (data.amounts.isNotEmpty) ...[
            ...data.amounts.entries.map((entry) => _buildReceiptRow(
                context, entry.key, entry.value,
                isAmount: true)),
            const SizedBox(height: 16),
            Container(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 16),
          ],

          // Highlighted Fields Section
          if (data.highlightedFields.isNotEmpty) ...[
            ...data.highlightedFields.entries.map((entry) =>
                _buildHighlightedRow(context, entry.key, entry.value)),
            const SizedBox(height: 16),
          ],

          // Other Fields Section
          if (data.otherFields.isNotEmpty) ...[
            ...data.otherFields.entries.map(
                (entry) => _buildReceiptRow(context, entry.key, entry.value)),
          ],
        ],
      ),
    );
  }

  Widget _buildReceiptFooter(BuildContext context, ReceiptData data) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Dates Section
          if (data.dates.isNotEmpty) ...[
            ...data.dates.entries.map((entry) => _buildReceiptRow(
                context, entry.key, entry.value,
                isDate: true)),
          ],

          const SizedBox(height: 16),

          // Receipt ID or Transaction ID
          Text('Receipt Generated'.tr,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(BuildContext context, String label, String value,
      {bool isAmount = false, bool isDate = false}) {
    if (label.compareTo('SendMoneyDetails') == 0 ||
        label.compareTo('Send Money Details Id') == 0) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: label.compareTo('AmountInWei') != 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isAmount ? Colors.green.shade700 : Colors.black87,
                      fontSize: isAmount ? 16 : 14,
                      fontWeight: isAmount ? FontWeight.bold : FontWeight.w500,
                      fontFamily: isDate ? null : 'monospace',
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    color: isAmount ? Colors.green.shade700 : Colors.black87,
                    fontSize: isAmount ? 16 : 14,
                    fontWeight: isAmount ? FontWeight.bold : FontWeight.w500,
                    fontFamily: isDate ? null : 'monospace',
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
    );
  }

  Widget _buildHighlightedRow(
      BuildContext context, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  _truncateValue(value),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy, size: 18, color: Colors.blue.shade600),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  Get.snackbar(
                    'Copied',
                    '$label copied to clipboard',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDottedLine() {
    return SizedBox(
      height: 1,
      child: Row(
        children: List.generate(
          50,
          (index) => Expanded(
            child: Container(
              color: index % 2 == 0 ? Colors.grey.shade300 : Colors.transparent,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  String _truncateValue(String value) {
    if (value.length <= 20) return value;
    return '${value.substring(0, 9)}...${value.substring(value.length - 10)}';
  }
}

class ReceiptData {
  String transactionType = '';
  String status = 'Unknown';
  Map<String, String> amounts = {};
  Map<String, String> highlightedFields = {};
  Map<String, String> dates = {};
  Map<String, String> otherFields = {};
}
