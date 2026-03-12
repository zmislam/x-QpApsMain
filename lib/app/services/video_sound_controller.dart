import 'package:flutter/material.dart';

class VideoSoundController {
  static final ValueNotifier<bool> isMuted = ValueNotifier<bool>(true);

  static void toggleMute() {
    isMuted.value = !isMuted.value;
  }
}
