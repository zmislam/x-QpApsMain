import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/live/live_stream_view_model.dart';
import '../models/comment_model.dart';
import '../models/live/live_stream_reaction_model.dart';
import '../config/constants/api_constant.dart';
import '../data/login_creadential.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../modules/NAVIGATION_MENUS/reels/model/reels_comment_model.dart';
import 'package:http/http.dart' as http;

class SocketService extends GetxService {
  //* ======================================================================== CONNECTIVITY ========================================================================
  late io.Socket socket;
  late String? socketId;

  //* ======================================================================= LIVE STREAM =======================================================================
  late final StreamController<CommentModel> commentListenStreamController;
  late final StreamController<ReelsCommentModel> reelsCommentListenStreamController;
  late final StreamController<LiveStreamViewModel> viewerListenStreamController;
  late final StreamController<LiveStreamViewModel> viewerListenReelsStreamController;
  late final StreamController<bool> stopListenStreamController;
  late final StreamController<LiveStreamReactionModel> streamReactionStreamController;

  late final StreamController<double> liveStreamTimerStreamController;

  @override
  void onInit() {
    super.onInit();
    // CONNECTIVITY
    _initSocket();

    // LIVE STREAM
    commentListenStreamController = StreamController<CommentModel>.broadcast();
    reelsCommentListenStreamController = StreamController<ReelsCommentModel>.broadcast();
    viewerListenStreamController = StreamController<LiveStreamViewModel>.broadcast();
    viewerListenReelsStreamController = StreamController<LiveStreamViewModel>.broadcast();
    stopListenStreamController = StreamController<bool>.broadcast();
    streamReactionStreamController = StreamController<LiveStreamReactionModel>.broadcast();
    liveStreamTimerStreamController = StreamController<double>.broadcast();

    // ADD LISTENERS
    _addSocketListeners();
  }

  @override
  void onClose() {
    // Properly disconnect socket
    socket.disconnect();
    super.onClose();
  }

  //* ======================================================================== CONNECTIVITY ========================================================================
  void _initSocket() {
    LoginCredential loginCredential = LoginCredential();
    socket = io.io(ApiConstant.SERVER_IP_PORT, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'secure': true,
      'extraHeaders': {
        'cookie': 'auth=yes; accessToken=${loginCredential.getAccessToken()}; type=app',
      }
    });

    debugPrint('Initializing socket connection...');
    debugPrint('Token: ${loginCredential.getAccessToken()}');

    socket.connect();

    // Handle socket events
    socket.onConnect((data) {
      debugPrint('Socket connected: $data');
      socketId = socket.id;
      debugPrint('Socket Id: $socketId');
    });

    socket.onConnectError((data) => debugPrint('Socket connection error: $data'));
    socket.onDisconnect((data) => debugPrint('Socket disconnected: $data'));
  }

  //* ============================================================================== EMITTER ==============================================================================

  void emitOnCallStart(Map<String, dynamic> data) {
    socket.emit('call:start', data);
  }

  //* -------------------------------------------------- LIVE STREAM
  void emitStartLiveStreamView(String postId, String userId) {
    socket.emit('start-viewing', {'post_id': postId, 'user_id': userId});
  }

  void emitStopLiveStreamViewing(String postId, String userId) {
    socket.emit('stop-viewing', {'post_id': postId, 'user_id': userId});
  }

  void emitStartLiveReelStreamView(String reelsId, String userId) {
    socket.emit('start-viewing', {'reels_id': reelsId, 'user_id': userId});
  }

  void emitStopLiveStreamReelViewing(String reelsId, String userId) {
    socket.emit('stop-viewing', {'reels_id': reelsId, 'user_id': userId});
  }

  //* ============================================================================== LISTENERS ==============================================================================

  void _addSocketListeners() {
    // Listen to "reels_viewer" event
    socket.on('reels_viewer', (data) {
      debugPrint('Reels Live Stream Viewer Count: $data');
      try {
        viewerListenReelsStreamController.add(LiveStreamViewModel.fromMap(data));
      } catch (e) {
        debugPrint('Error parsing reels viewer data: $e');
      }
    });

    // Listen to "stream_reaction" event
    socket.on('stream_reaction', (data) {
      debugPrint('Live Stream Reaction: $data');
      try {
        LiveStreamReactionModel model = LiveStreamReactionModel.fromMap(data as Map<String, dynamic>);
        streamReactionStreamController.add(model);
        // Send reaction data to backend
        _sendToBackend(model.toMap());
      } catch (e) {
        debugPrint('Error parsing stream reaction: $e');
      }
    });

    // Listen to "stop" event (end of live stream)
    socket.on('stop', (data) {
      debugPrint('Live Stream Ended: $data');
      stopListenStreamController.add(true);
      // Send stop event data to backend
      _sendToBackend({'event': 'stop', 'data': data});
    });

    // Listen to "new_comment" event for live stream
    socket.on('new_comment', (data) {
      debugPrint('New comment received: $data');
      try {
        CommentModel commentModel = CommentModel.fromMap(data as Map<String, dynamic>);
        commentListenStreamController.add(commentModel);
        // Send comment data to backend
        _sendToBackend(commentModel.toMap());
      } catch (e) {
        debugPrint('Error parsing live comment: $e');
      }
    });

    // Listen to "new_comment" event for reels
    socket.on('new_reels_comment', (data) {
      debugPrint('New reels comment received: $data');
      try {
        ReelsCommentModel reelsCommentModel = ReelsCommentModel.fromMap(data as Map<String, dynamic>);
        reelsCommentListenStreamController.add(reelsCommentModel);
        // Send reels comment data to backend
        _sendToBackend(reelsCommentModel.toMap());
      } catch (e) {
        debugPrint('Error parsing reels comment: $e');
      }
    });

    // Listen to "viewer" event for live stream viewers count
    socket.on('viewer', (data) {
      debugPrint('Live Stream Viewer Count: $data');
      try {
        viewerListenStreamController.add(LiveStreamViewModel.fromMap(data));
      } catch (e) {
        debugPrint('Error parsing viewer count: $e');
      }
    });
  }

  //* ============================================================================== SEND TO BACKEND ==============================================================================

  Future<void> _sendToBackend(Map<String, dynamic> data) async {
    try {
      // Replace with your API call logic to send data to backend
      debugPrint('Sending data to backend: $data');
      // Example of sending data via HTTP (you can replace this with your actual API)
      final response = await http.post(
        Uri.parse('https://your-backend-endpoint.com/api/endpoint'),
        headers: {
          'Authorization': 'Bearer ${LoginCredential().getAccessToken()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        debugPrint('Data sent successfully: $data');
      } else {
        debugPrint('Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending data to backend: $e');
    }
  }
}
