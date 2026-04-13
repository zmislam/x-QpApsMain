import 'package:get/get.dart';
import '../services/currency_service.dart';

/// Centralized currency formatting for the marketplace.
/// Delegates to [CurrencyService] when available; falls back to EUR.
class CurrencyHelper {
  static CurrencyService? get _service {
    try {
      return Get.find<CurrencyService>();
    } catch (_) {
      return null;
    }
  }

  static String get currencySymbol => _service?.symbol ?? '€';
  static String get currencyCode => _service?.selectedCurrency.value ?? 'EUR';

  /// Format a numeric value as a currency string.
  /// Automatically converts from EUR to the user's selected currency.
  static String formatPrice(dynamic value, {int decimals = 2}) {
    final svc = _service;
    if (svc != null) return svc.format(value, decimals: decimals);
    // Fallback when service not yet initialised
    if (value == null) return '€ 0.00';
    final num numValue = value is num ? value : num.tryParse(value.toString()) ?? 0;
    return '€${numValue.toStringAsFixed(decimals)}';
  }

  /// Format with a sign prefix for discounts/additions.
  /// Example: formatWithSign(-20.0) → "-€20.00"
  static String formatWithSign(dynamic value, {String prefix = '', int decimals = 2}) {
    if (value == null) return '$prefix${currencySymbol} 0.00';
    final num numValue = value is num ? value : num.tryParse(value.toString()) ?? 0;
    final svc = _service;
    if (svc != null) {
      final converted = svc.convert(numValue.abs());
      final dec = currencyCode == 'JPY' ? 0 : decimals;
      return '$prefix${currencySymbol}${converted.toStringAsFixed(dec)}';
    }
    return '$prefix€${numValue.abs().toStringAsFixed(decimals)}';
  }
}
