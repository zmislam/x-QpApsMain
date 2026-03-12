import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color.dart';
import 'component_theme/button_theme.dart';
import 'component_theme/form_decoration_theme.dart';
import 'component_theme/generic_widget_theme.dart';
import 'dark_componenet_theme/dark_button_theme.dart';
import 'dark_componenet_theme/dark_form_decoration_theme.dart';
import 'dark_componenet_theme/dark_generic_widget_theme.dart';
import 'dark_test_theme.dart';
import 'text_theme.dart';

// Theme Controller using GetX
class ThemeController extends GetxController {
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme({bool? isDarkMode}) {
    _isDarkMode.value = isDarkMode ?? !_isDarkMode.value;
    Get.changeThemeMode(themeMode);
    update();
    // Get.changeTheme(_isDarkMode.value ? darkTheme : lightTheme);
  }
}

// Define Light and Dark Themes
final ThemeData lightTheme = ThemeData(
  // ------------------------------------------ COLOR THEME -----------------------------------------
  primarySwatch: Colors.teal,
  primaryColor: PRIMARY_COLOR,
  colorScheme: ColorScheme.fromSeed(
    seedColor: PRIMARY_COLOR,
    surface: Colors.white,
    surfaceContainer: Colors.grey.shade100,
  ),
  scaffoldBackgroundColor: Colors.white,
  indicatorColor: PRIMARY_COLOR,
  focusColor: PRIMARY_COLOR,
  canvasColor: PRIMARY_COLOR_LIGHT,
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.white,
      titleTextStyle: AppText.APP_BAR_TITLE_TEXT_STYLE),

  // ------------------------------------------ FORM INPUT DECORATION -----------------------------------------
  inputDecorationTheme: InputTheme.inputDecorationTheme,

  // ------------------------------------------ TEXT THEME -----------------------------------------
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: PRIMARY_COLOR,
    selectionColor: PRIMARY_COLOR,
    selectionHandleColor: PRIMARY_COLOR,
  ),

  textTheme: const TextTheme(
    bodyLarge: AppText.BODY_TEXT_LARGE,
    bodyMedium: AppText.BODY_TEXT_MID,
    bodySmall: AppText.BODY_TEXT_SMALL,
    headlineLarge: AppText.HEAD_LINE_1,
    headlineMedium: AppText.HEAD_LINE_2,
    headlineSmall: AppText.HEAD_LINE_3,
    labelLarge: AppText.LABEL,
    labelMedium: AppText.CAPTION,
    labelSmall: AppText.OVER_LINE,
  ),

  // FIXED: Use TabBarThemeData instead of TabBarTheme
  tabBarTheme: const TabBarThemeData(
    indicatorColor: PRIMARY_COLOR,
  ),

  // ------------------------------------------ BUTTON TEXT THEME -----------------------------------------
  buttonTheme: CustomButtonTheme.buttonTheme,
  textButtonTheme: CustomButtonTheme.textButtonTheme,
  elevatedButtonTheme: CustomButtonTheme.elevatedButtonTheme,
  outlinedButtonTheme: CustomButtonTheme.outlinedButtonTheme,
  iconButtonTheme: CustomButtonTheme.iconButtonThemeData,

  // ------------------------------------------ GENERIC WIDGET THEME -----------------------------------------
  progressIndicatorTheme: GenericWidgetTheme.progressIndicatorThemeData,
  cardColor: Colors.grey.shade100,
  badgeTheme: GenericWidgetTheme.badgeThemeData,
  // FIXED: Ensure this returns CardThemeData, not CardTheme
  cardTheme: GenericWidgetTheme.cardTheme,
  dividerTheme: GenericWidgetTheme.dividerThemeData,
  datePickerTheme: GenericWidgetTheme.datePickerThemeData,
  iconTheme: GenericWidgetTheme.iconThemeData,
  switchTheme: GenericWidgetTheme.switchThemeData,
  radioTheme: GenericWidgetTheme.radioThemeData,
);

final ThemeData darkTheme = ThemeData(
  // ------------------------------------------ COLOR THEME -----------------------------------------
  primarySwatch: Colors.teal,
  primaryColor: DARK_PRIMARY_COLOR,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: DARK_PRIMARY_COLOR,
    primary: PRIMARY_COLOR,
    surface: DARK_BACKGROUND_COLOR,
    surfaceContainer: DARK_PRIMARY_COLOR_LIGHT,
  ),
  scaffoldBackgroundColor: DARK_SURFACE_COLOR,
  primaryColorDark: PRIMARY_COLOR,
  indicatorColor: DARK_PRIMARY_COLOR,
  focusColor: DARK_PRIMARY_COLOR,
  canvasColor: DARK_PRIMARY_COLOR_LIGHT,
  appBarTheme: const AppBarTheme(
    backgroundColor: DARK_SURFACE_COLOR,
    foregroundColor: Colors.white,
    titleTextStyle: DarkAppText.APP_BAR_TITLE_TEXT_STYLE,
  ),

// ------------------------------------------ FORM INPUT DECORATION -----------------------------------------
  inputDecorationTheme: DarkInputTheme.inputDecorationTheme,

  // ------------------------------------------ TEXT THEME -----------------------------------------
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: PRIMARY_COLOR,
    selectionColor: PRIMARY_COLOR,
    selectionHandleColor: PRIMARY_COLOR,
  ),

  textTheme: const TextTheme(
    bodyLarge: DarkAppText.BODY_TEXT_LARGE,
    bodyMedium: DarkAppText.BODY_TEXT_MID,
    bodySmall: DarkAppText.BODY_TEXT_SMALL,
    headlineLarge: DarkAppText.HEAD_LINE_1,
    headlineMedium: DarkAppText.HEAD_LINE_2,
    headlineSmall: DarkAppText.HEAD_LINE_3,
    labelLarge: DarkAppText.LABEL,
    labelMedium: DarkAppText.CAPTION,
    labelSmall: DarkAppText.OVER_LINE,
  ),

  // FIXED: Use TabBarThemeData instead of TabBarTheme
  tabBarTheme: const TabBarThemeData(
    indicatorColor: PRIMARY_COLOR,
  ),

  // ------------------------------------------ BUTTON TEXT THEME -----------------------------------------
  buttonTheme: DarkCustomButtonTheme.buttonTheme,
  textButtonTheme: DarkCustomButtonTheme.textButtonTheme,
  elevatedButtonTheme: DarkCustomButtonTheme.elevatedButtonTheme,
  outlinedButtonTheme: DarkCustomButtonTheme.outlinedButtonTheme,
  iconButtonTheme: DarkCustomButtonTheme.iconButtonThemeData,

  // ------------------------------------------ GENERIC WIDGET THEME -----------------------------------------
  progressIndicatorTheme: DarkGenericWidgetTheme.progressIndicatorThemeData,
  cardColor: Colors.grey.shade100,
  badgeTheme: DarkGenericWidgetTheme.badgeThemeData,
  // FIXED: Ensure this returns CardThemeData, not CardTheme
  cardTheme: DarkGenericWidgetTheme.cardTheme,
  dividerTheme: DarkGenericWidgetTheme.dividerThemeData,
  datePickerTheme: DarkGenericWidgetTheme.datePickerThemeData,
  iconTheme: DarkGenericWidgetTheme.iconThemeData,
  switchTheme: DarkGenericWidgetTheme.switchThemeData,
  radioTheme: DarkGenericWidgetTheme.radioThemeData,
);
