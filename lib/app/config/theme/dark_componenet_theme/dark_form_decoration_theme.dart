import 'package:flutter/material.dart';
import '../dark_test_theme.dart';
import '../../constants/color.dart';
import 'dark_input_decoration_theme.dart';

class DarkInputTheme {

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: PRIMARY_COLOR),

    // -------------------------- TEXT STYLE --------------------------
    hintStyle: DarkAppText.LABEL,
    labelStyle: DarkAppText.LABEL,
    errorStyle: DarkAppText.ERROR_STYLE,
    prefixStyle: DarkAppText.LABEL,
    suffixStyle: DarkAppText.LABEL,
    counterStyle: DarkAppText.FORM_COUNTER_STYLE,

    // -------------------------- COLOR --------------------------
    focusColor: PRIMARY_COLOR,
    prefixIconColor: WidgetStateColor.resolveWith((states) {
      if(states.contains(WidgetState.focused)) return Colors.white;
      // if(states.contains(WidgetState.error)) return ERROR_BORDER_COLOR;  // Activate Error Color If you need
      return Colors.grey.shade200;
    },),
    suffixIconColor: WidgetStateColor.resolveWith((states) {
      if(states.contains(WidgetState.focused)) return Colors.white;
      // if(states.contains(WidgetState.error)) return ERROR_BORDER_COLOR;  // Activate Error Color If you need
      return Colors.grey.shade200;
    },),
    iconColor: WidgetStateColor.resolveWith((states) {
      if(states.contains(WidgetState.focused)) return Colors.white;
      // if(states.contains(WidgetState.error)) return ERROR_BORDER_COLOR;  // Activate Error Color If you need
      return Colors.grey.shade200;
    },),

    filled: true,
    fillColor: DARK_SURFACE_COLOR,


    // -------------------------- BORDER --------------------------
    enabledBorder: DarkCustomInputDecorationTheme.ENABLED_BORDER,
    focusedBorder: DarkCustomInputDecorationTheme.FOCUSED_BORDER,
    errorBorder: DarkCustomInputDecorationTheme.ERROR_BORDER,
    focusedErrorBorder: DarkCustomInputDecorationTheme.FOCUSED_ERROR_BORDER,
  );
}
