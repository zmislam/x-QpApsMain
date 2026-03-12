import 'package:flutter/services.dart';
import 'snackbar.dart';

class CopyToClipboardUtils {
  static void copyToClipboard(String text, String? snackText) async {
    await Clipboard.setData(ClipboardData(text: text));
    showSuccessSnackkbar(message: '${snackText ?? 'Text'} copied successfully');
  }
}
