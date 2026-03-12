import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'model/app_metadata.dart';
import 'model/connection_status.dart';
import 'model/paring_model.dart';
import 'model/proposal_namespace.dart';
import 'model/request.dart';
import 'model/session.dart';
import 'model/session_approval.dart';
import 'model/session_delete.dart';
import 'model/session_proposal.dart';
import 'model/session_rejection.dart';
import 'model/session_request.dart';
import 'model/session_response.dart';
import 'model/session_update.dart';
import 'wallet_connect_v2_platform_interface.dart';

/// An implementation of [WalletConnectV2Platform] that uses method channels.
class MethodChannelWalletConnectV2 extends WalletConnectV2Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('wallet_connect_v2');

  final eventChannel = const EventChannel('wallet_connect_v2/event');

  Stream<dynamic>? _onEvent;

  @override
  Future<void> init({required String projectId, required AppMetadata appMetadata}) {
    return methodChannel.invokeMethod('init', {'projectId': projectId, 'appMetadata': appMetadata.toJson()});
  }

  @override
  Future<void> connect() {
    return methodChannel.invokeMethod('connect');
  }

  @override
  Future<void> disconnect() {
    return methodChannel.invokeMethod('disconnect');
  }

  @override
  Future<void> pair({required String uri}) {
    return methodChannel.invokeMethod('pair', {'uri': uri});
  }

  @override
  Future<void> approve({required SessionApproval approval}) {
    return methodChannel.invokeMethod('approve', approval.toJson());
  }

  @override
  Future<void> reject({required String proposalId}) {
    return methodChannel.invokeMethod('reject', {'id': proposalId});
  }

  @override
  Future<List<Session>> getActivatedSessions() async {
    final rawSessions = await methodChannel.invokeMethod('getActivatedSessions');
    final List<dynamic> result = jsonDecode(jsonEncode(rawSessions));
    return result.map((e) => Session.fromJson(e)).toList();
  }

  @override
  Future<List<PairingModel>> getAllPairings() async {
    final rawSessions = await methodChannel.invokeMethod('getAllParing');
    final List<dynamic> result = jsonDecode(jsonEncode(rawSessions));
    return result.map((e) => PairingModel.fromMap(e)).toList();
  }

  @override
  Future<void> disconnectSession({required String topic}) {
    return methodChannel.invokeMethod('disconnectSession', {'topic': topic});
  }

  @override
  Future<void> disconnectPairing({required String topic}) {
    return methodChannel.invokeMethod('disconnectPairing', {'topic': topic});
  }

  @override
  Future<void> updateSession({required SessionApproval updateApproval}) {
    return methodChannel.invokeMethod('updateSession', updateApproval.toJson());
  }

  @override
  Future<void> approveRequest({required String topic, required String requestId, required String result}) {
    return methodChannel.invokeMethod('approveRequest', {'requestId': requestId, 'topic': topic, 'result': result});
  }

  @override
  Future<void> rejectRequest({required String topic, required String requestId}) {
    return methodChannel.invokeMethod('rejectRequest', {'requestId': requestId, 'topic': topic});
  }

  @override
  Future<String?> createPair({required Map<String, ProposalNamespace> namespaces}) {
    return methodChannel.invokeMethod<String>('createPair', namespaces.map((key, value) => MapEntry(key, value.toJson())));
  }

  @override
  Future<void> sendRequest({required Request request}) {
    return methodChannel.invokeMethod('sendRequest', request.toJson());
  }

  @override
  Stream<dynamic> get onEvent {
    _onEvent ??= eventChannel.receiveBroadcastStream().distinct().map((dynamic event) {
      final Map<String, dynamic> result = jsonDecode(jsonEncode(event));
      debugPrint('onEvent data = ${result.toString()}');
      final eventName = result['name'] as String;
      final eventData = result['data'] as Map<String, dynamic>;
      switch (eventName) {
        case 'connection_status':
          return ConnectionStatus(eventData['isConnected']);
        case 'proposal':
          return SessionProposal.fromJson(eventData);
        case 'session_settle':
          return Session.fromJson(eventData);
        case 'session_request':
          return SessionRequest.fromJson(eventData);
        case 'session_update':
          return SessionUpdate.fromJson(eventData);
        case 'session_delete':
          return SessionDelete.fromJson(eventData);
        case 'session_rejection':
          return SessionRejection.fromJson(eventData);
        case 'session_response':
          return SessionResponse.fromJson(eventData);
        default:
          break;
      }
    });
    return _onEvent!;
  }
}
