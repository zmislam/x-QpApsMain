import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playDeviceFileSource(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));

    debugPrint('Audio playing successful');
  }

  Future<void> playUrlSource(String path) async {
    try {
      await _audioPlayer.play(UrlSource(path));
    } catch (error) {
      debugPrint('Error playing audio: $error');
    }

    debugPrint('Audio playing successful');
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }
}
