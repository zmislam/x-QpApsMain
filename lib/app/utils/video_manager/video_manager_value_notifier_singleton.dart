import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoManager extends ChangeNotifier {
  static final VideoManager _instance = VideoManager._internal();
  factory VideoManager() => _instance;
  VideoManager._internal();

  VideoPlayerController? _currentController;

  VideoPlayerController? get currentController => _currentController;

  void setActiveController(VideoPlayerController controller) {
    if (_currentController != null && _currentController != controller) {
      _currentController!.pause();
    }
    _currentController = controller;
    notifyListeners();
  }

  void clearController() {
    _currentController = null;
    notifyListeners();
  }
}
