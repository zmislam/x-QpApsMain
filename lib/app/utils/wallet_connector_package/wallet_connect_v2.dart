import 'dart:async';

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

class WalletConnectV2 {
  StreamSubscription? _eventSubscription;

  OnConnectionStatus? onConnectionStatus;
  OnSessionProposal? onSessionProposal;
  OnSessionSettle? onSessionSettle;
  OnSessionUpdate? onSessionUpdate;
  OnSessionDelete? onSessionDelete;
  OnSessionRequest? onSessionRequest;
  OnEventError? onEventError;

  /// DAPP only, listen to action of reject proposal from wallet
  OnSessionRejection? onSessionRejection;

  /// DAPP only, listen to action of approve/reject request from wallet
  OnSessionResponse? onSessionResponse;

  /// Initiate SDKs
  Future<void> init(
      {required String projectId, required AppMetadata appMetadata}) {
    _eventSubscription =
        WalletConnectV2Platform.instance.onEvent.listen((event) {
      if (event is ConnectionStatus) {
        onConnectionStatus?.call(event.isConnected);
      } else if (event is SessionProposal) {
        onSessionProposal?.call(event);
      } else if (event is Session) {
        onSessionSettle?.call(event);
      } else if (event is SessionRequest) {
        onSessionRequest?.call(event);
      } else if (event is SessionUpdate) {
        onSessionUpdate?.call(event.topic);
      } else if (event is SessionDelete) {
        onSessionDelete?.call(event.topic);
      } else if (event is SessionRejection) {
        onSessionRejection?.call(event.topic);
      } else if (event is SessionResponse) {
        onSessionResponse?.call(event);
      }
    }, onError: (error) {
      if (error is PlatformException) {
        onEventError?.call(error.code, error.message ?? 'Internal error');
      } else {
        onEventError?.call('general_error', 'Internal error');
      }
    });
    return WalletConnectV2Platform.instance
        .init(projectId: projectId, appMetadata: appMetadata);
  }

  /// Connect to listen event, for Wallet & DApp to connect to Relay service
  Future<void> connect() {
    return WalletConnectV2Platform.instance.connect();
  }

  /// Disconnect, for Wallet & DApp to disconnect with Relay service
  Future<void> disconnect() {
    return WalletConnectV2Platform.instance.disconnect();
  }

  /// Pair with DApps for Wallet only
  Future<void> pair({required String uri}) {
    return WalletConnectV2Platform.instance.pair(uri: uri);
  }

  /// Approve session for Wallet only
  Future<void> approveSession({required SessionApproval approval}) {
    return WalletConnectV2Platform.instance.approve(approval: approval);
  }

  /// Reject session for Wallet only
  Future<void> rejectSession({required String proposalId}) {
    return WalletConnectV2Platform.instance.reject(proposalId: proposalId);
  }

  /// Get current activated sessions
  Future<List<Session>> getActivatedSessions() {
    return WalletConnectV2Platform.instance.getActivatedSessions();
  }

  /// Get current activated sessions
  Future<List<PairingModel>> getAllPairings() {
    return WalletConnectV2Platform.instance.getAllPairings();
  }

  /// Disconnect session for Wallet & DApp
  Future<void> disconnectSession({required String topic}) {
    return WalletConnectV2Platform.instance.disconnectSession(topic: topic);
  }

  /// Disconnect pairing for Wallet & DApp
  Future<void> disconnectPairing({required String topic}) {
    return WalletConnectV2Platform.instance.disconnectPairing(topic: topic);
  }

  /// Update session for Wallet & DApp
  Future<void> updateSession({required SessionApproval updateApproval}) {
    return WalletConnectV2Platform.instance
        .updateSession(updateApproval: updateApproval);
  }

  /// Approve request for Wallet only
  Future<void> approveRequest(
      {required String topic,
      required String requestId,
      required String result}) {
    return WalletConnectV2Platform.instance
        .approveRequest(topic: topic, requestId: requestId, result: result);
  }

  /// Reject request for Wallet only
  Future<void> rejectRequest(
      {required String topic, required String requestId}) {
    return WalletConnectV2Platform.instance
        .rejectRequest(topic: topic, requestId: requestId);
  }

  /// DAPP only, to create PAIR URI to pair with wallet
  Future<String?> createPair(
      {required Map<String, ProposalNamespace> namespaces}) {
    return WalletConnectV2Platform.instance.createPair(namespaces: namespaces);
  }

  /// DAPP only, to send request to wallet
  Future<void> sendRequest({required Request request}) {
    return WalletConnectV2Platform.instance.sendRequest(request: request);
  }

  /// Dispose the event subscription
  Future dispose() async {
    _eventSubscription?.cancel();
    _eventSubscription = null;
  }
}

typedef OnConnectionStatus = Function(bool isConnected);
typedef OnSessionProposal = Function(SessionProposal proposal);
typedef OnSessionSettle = Function(Session session);
typedef OnSessionUpdate = Function(String topic);
typedef OnSessionDelete = Function(String topic);
typedef OnSessionRejection = Function(String topic);
typedef OnSessionResponse = Function(SessionResponse response);
typedef OnSessionRequest = Function(SessionRequest request);
typedef OnEventError = Function(String code, String message);
