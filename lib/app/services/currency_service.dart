import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../config/constants/api_constant.dart';
import '../models/api_response.dart';
import 'api_communication.dart';

/// Singleton service that manages currency selection and exchange rates.
/// Persists user preference via GetStorage; fetches live rates from the backend.
class CurrencyService extends GetxService {
  static CurrencyService get instance => Get.find<CurrencyService>();

  final _box = GetStorage();
  final _api = ApiCommunication();

  static const _kSelectedCurrency = 'selected_currency';
  static const _kExchangeRates = 'exchange_rates';
  static const _kRatesUpdatedAt = 'exchange_rates_updated';

  /// Currently selected currency code.
  final selectedCurrency = 'EUR'.obs;

  /// Exchange rates (EUR-based).  key = currency code, value = rate.
  final rates = <String, double>{}.obs;

  /// Human-readable metadata per currency.
  static const supportedCurrencies = <String, _CurrencyMeta>{
    'EUR': _CurrencyMeta('€', 'Euro', '🇪🇺'),
    'USD': _CurrencyMeta('\$', 'US Dollar', '🇺🇸'),
    'GBP': _CurrencyMeta('£', 'British Pound', '🇬🇧'),
    'CHF': _CurrencyMeta('CHF', 'Swiss Franc', '🇨🇭'),
    'JPY': _CurrencyMeta('¥', 'Japanese Yen', '🇯🇵'),
    'BDT': _CurrencyMeta('৳', 'Bangladeshi Taka', '🇧🇩'),
  };

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
    fetchRates();
  }

  // ─── Persistence ─────────────────────────────────────────

  void _loadFromStorage() {
    selectedCurrency.value = _box.read<String>(_kSelectedCurrency) ?? 'EUR';

    final cached = _box.read<String>(_kExchangeRates);
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        rates.value = decoded.map((k, v) => MapEntry(k, (v as num).toDouble()));
      } catch (_) {}
    }
  }

  void setCurrency(String code) {
    if (!supportedCurrencies.containsKey(code)) return;
    selectedCurrency.value = code;
    _box.write(_kSelectedCurrency, code);
  }

  // ─── Network ─────────────────────────────────────────────

  Future<void> fetchRates() async {
    try {
      final ApiResponse res = await _api.doGetRequest(
        apiEndPoint: 'market-place/exchange-rates',
        responseDataKey: ApiConstant.FULL_RESPONSE,
      );
      if (res.isSuccessful && res.data != null) {
        final data = res.data as Map<String, dynamic>;
        final ratesMap = data['rates'] as Map<String, dynamic>?;
        if (ratesMap != null) {
          rates.value = ratesMap.map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          );
          _box.write(_kExchangeRates, jsonEncode(rates));
          _box.write(_kRatesUpdatedAt, DateTime.now().toIso8601String());
        }
      }
    } catch (_) {
      // Fallback: keep cached / empty rates – EUR will still work (rate = 1).
    }
  }

  // ─── Conversion helpers ──────────────────────────────────

  /// Symbol for the currently selected currency.
  String get symbol =>
      supportedCurrencies[selectedCurrency.value]?.symbol ?? selectedCurrency.value;

  /// Convert an amount expressed in EUR to the selected currency.
  double convert(num eurAmount) {
    if (selectedCurrency.value == 'EUR') return eurAmount.toDouble();
    final rate = rates[selectedCurrency.value];
    if (rate == null) return eurAmount.toDouble();
    return eurAmount * rate;
  }

  /// Format an EUR amount in the currently selected currency.
  String format(dynamic value, {int decimals = 2}) {
    if (value == null) return '$symbol 0.00';
    final num numValue =
        value is num ? value : num.tryParse(value.toString()) ?? 0;
    final converted = convert(numValue);
    // JPY doesn't use decimal places
    final dec = selectedCurrency.value == 'JPY' ? 0 : decimals;
    return '$symbol${converted.toStringAsFixed(dec)}';
  }
}

class _CurrencyMeta {
  final String symbol;
  final String name;
  final String flag;
  const _CurrencyMeta(this.symbol, this.name, this.flag);
}
