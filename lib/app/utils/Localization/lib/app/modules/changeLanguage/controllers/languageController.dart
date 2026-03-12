import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LanguageController extends GetxController {
  late SharedPreferences _prefs;
  static const String LANGUAGE_KEY = 'selected_language';

  // Available languages
  final List<LanguageModel> languages = [
    LanguageModel(name: 'English', code: 'en', flag: '🇺🇸'),
    LanguageModel(name: 'Español', code: 'es', flag: '🇪🇸'), // Spanish
    LanguageModel(name: 'Français', code: 'fr', flag: '🇫🇷'), // French
    LanguageModel(name: 'Deutsch', code: 'de', flag: '🇩🇪'),  // German
    LanguageModel(name: 'Italiano', code: 'it', flag: '🇮🇹'), // Italian
    LanguageModel(name: 'العربية', code: 'ar', flag: '🇸🇦'),   // Arabic
    LanguageModel(name: 'हिन्दी', code: 'hi', flag: '🇮🇳'),   // Hindi
    LanguageModel(name: 'বাংলা', code: 'bn', flag: '🇧🇩'),    // Bangla
  ];


  // Observable current language
  Rx<LanguageModel> currentLanguage = LanguageModel(
    name: 'English',
    code: 'en',
    flag: '🇺🇸',
  ).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initSharedPreferences();
    await loadSavedLanguage();
  }

  // Initialize SharedPreferences
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint('✅ SharedPreferences initialized');
  }

  // Load saved language from SharedPreferences
  Future<void> loadSavedLanguage() async {
    try {
      String? savedCode = _prefs.getString(LANGUAGE_KEY);
      debugPrint('🔍 Loading saved language from SharedPreferences: $savedCode');

      if (savedCode != null && savedCode.isNotEmpty) {
        final lang = languages.firstWhere(
              (l) => l.code == savedCode,
          orElse: () => languages.first,
        );
        currentLanguage.value = lang;
        await Get.updateLocale(Locale(lang.code));
        debugPrint('✅ Loaded saved language: ${lang.name} (${lang.code})');
      } else {
        debugPrint('📝 No saved language found, using default: English');
        currentLanguage.value = languages.first;
      }
    } catch (e) {
      debugPrint('❌ Error loading language: $e');
      currentLanguage.value = languages.first;
    }
  }

  Future<void> changeLanguage(LanguageModel language) async {
    try {
      debugPrint('🔄 Changing language to: ${language.name} (${language.code})');
      currentLanguage.value = language;
      await _prefs.setString(LANGUAGE_KEY, language.code);
      String? verify = _prefs.getString(LANGUAGE_KEY);
      debugPrint('💾 Saved language to SharedPreferences: $verify');

      await Get.updateLocale(Locale(language.code));
      debugPrint('✅ Language changed successfully to: ${language.name}');
      Get.back();

      // Show success message
      Get.snackbar(
        'Language Changed'.tr,
        '${'App language changed to'.tr} ${language.name}'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      debugPrint('❌ Error changing language: $e');
      Get.snackbar(
        'Error'.tr,
        'Failed to change language'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Get current language code
  String getCurrentLanguageCode() {
    return currentLanguage.value.code;
  }

  bool hasSavedLanguage() {
    return _prefs.getString(LANGUAGE_KEY) != null;
  }

  String? getSavedLanguageCode() {
    return _prefs.getString(LANGUAGE_KEY);
  }
}


class LanguageModel {
  final String name;
  final String code;
  final String flag;

  LanguageModel({
    required this.name,
    required this.code,
    required this.flag,
  });
}