
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../../config/constants/video_ad_config.dart';

class VideoPlayerStateController with ChangeNotifier {
  bool _playAddVideo = false;
  bool _showSkipAddButton = false;
  bool _addPlayed = false;
  bool _addAlreadyInitComplete = false;
  bool _videoInitComplete = false;
  bool _showVideoPlayProgress = false;

  String? adVideoLink;
  String videoLink = '';

  late VideoPlayerController _videoPlayerController;
  late VideoPlayerController _addVideoPlayerController;

  bool get playAddVideo => _playAddVideo;
  bool get showSkipAddButton => _showSkipAddButton;
  bool get addPlayed => _addPlayed;
  bool get showVideoPlayProgress => _showVideoPlayProgress;
  bool get addAlreadyInitComplete => _addAlreadyInitComplete;
  VideoPlayerController get videoPlayerController => _videoPlayerController;
  VideoPlayerController get addVideoPlayerController =>
      _addVideoPlayerController;

  Future<void> init({required String videoLink, String? adVideoLink}) async {
    if (_videoInitComplete) return;

    this.videoLink = videoLink;
    this.adVideoLink = adVideoLink;

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoLink));
    await _videoPlayerController.initialize().then((value){
      if(_videoPlayerController.value.duration != Duration.zero
          && _videoPlayerController.value.duration.inSeconds != 0
          && !_videoPlayerController.value.duration.inSeconds.isNaN) {
        _showVideoPlayProgress = true;
      }
      _videoPlayerController.play();
    }).catchError((error) {
      debugPrint('video player error: $error');
      debugPrint('video player error: $error');
      debugPrint('video player error: $error');
      debugPrint('video player error: $error');
    });

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isPlaying &&
          _videoPlayerController.value.position.inSeconds == videoAddPlayGap &&
          !_addPlayed &&
          adVideoLink != null &&
          _addAlreadyInitComplete) {
        playAd();
      }
    });
    _videoInitComplete = true;

    notifyListeners();
  }

  void playAd() {
    if (_addAlreadyInitComplete && adVideoLink != null) {
      _playAddVideo = true;
      _showSkipAddButton = false;
      _addVideoPlayerController.play();
      notifyListeners();
    }
  }

  void skipAd() {
    _playAddVideo = false;
    _showSkipAddButton = false;
    _addPlayed = true;
    _addVideoPlayerController.pause();
    _videoPlayerController.play();
    notifyListeners();
  }

  void enableSkipButton() {
    _showSkipAddButton = true;
    notifyListeners();
  }

  void addPreviewComplete() {
    _playAddVideo = false;
    _addPlayed = true;
    notifyListeners();
  }

  void videoAdControllerInit() {
    if (adVideoLink == null || _addAlreadyInitComplete) {
      return; // Early return if ad video link is null or already initialized
    }

    _addAlreadyInitComplete = true;

    // Initialize the ad video player controller
    _addVideoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(adVideoLink!))
          ..initialize().then((_) {
            // Notify listeners once the initialization is complete
            notifyListeners();
          }).catchError((e) {
            // if init failed
            _addAlreadyInitComplete = false;
          });

    // Add listener to the ad video player controller
    _addVideoPlayerController.addListener(() {
      final controllerValue = _addVideoPlayerController.value;

      // Ensure video is playing and check position for skip button visibility
      if (controllerValue.isPlaying &&
          controllerValue.position.inSeconds >=
              videoAdSkipButtonVisibilityTimer) {
        enableSkipButton();
        notifyListeners();
      }

      // Handle the completion of the ad video
      if (controllerValue.isCompleted) {
        addPreviewComplete();
        _addVideoPlayerController.pause();
        _videoPlayerController.play();
      }
    });
  }

  void disposeController() {
    if (_videoPlayerController.value.isInitialized) {
      _videoPlayerController.dispose();
    }
    if (_addAlreadyInitComplete &&
        _addVideoPlayerController.value.isInitialized) {
      _addVideoPlayerController.dispose();
    }
    _addAlreadyInitComplete = false;
  }
}
