import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DynamicTranslations extends Translations {
  static final DynamicTranslations instance = DynamicTranslations._internal();
  factory DynamicTranslations() => instance;
  DynamicTranslations._internal();

  final Map<String, Map<String, String>> _translations = {};

  @override
  Map<String, Map<String, String>> get keys => _translations;

  Future<void> loadLanguages() async {
    final supportedLanguages = ['en', 'bn', 'es', 'it', 'fr', 'de', 'ar', 'hi'];

    for (var lang in supportedLanguages) {
      final jsonString = await rootBundle.loadString('assets/json/$lang.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      _translations[lang] = jsonMap.map((k, v) => MapEntry(k, v.toString()));
    }
  }
}
