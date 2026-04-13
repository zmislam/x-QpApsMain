import 'dart:convert';
import 'package:get_storage/get_storage.dart';

/// Persists recently visited product IDs + basic info via GetStorage.
/// Keeps at most [_maxItems] products.
class RecentlyVisitedService {
  RecentlyVisitedService._();
  static final RecentlyVisitedService instance = RecentlyVisitedService._();

  static const String _key = 'recently_visited_products';
  static const int _maxItems = 30;

  final GetStorage _box = GetStorage();

  /// Record a product visit. Stores id, name, image, price.
  void recordVisit({
    required String productId,
    String? productName,
    String? image,
    num? sellPrice,
  }) {
    final List<Map<String, dynamic>> items = _getAll();

    // Remove duplicate if already visited
    items.removeWhere((item) => item['id'] == productId);

    // Insert at the beginning (most recent first)
    items.insert(0, {
      'id': productId,
      'name': productName,
      'image': image,
      'price': sellPrice,
      'visited_at': DateTime.now().toIso8601String(),
    });

    // Trim to max size
    if (items.length > _maxItems) {
      items.removeRange(_maxItems, items.length);
    }

    _box.write(_key, jsonEncode(items));
  }

  /// Get all recently visited products (most recent first).
  List<Map<String, dynamic>> getRecentProducts({int limit = 20}) {
    final items = _getAll();
    return items.take(limit).toList();
  }

  /// Clear all recently visited.
  void clear() {
    _box.remove(_key);
  }

  List<Map<String, dynamic>> _getAll() {
    final raw = _box.read<String>(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }
}
