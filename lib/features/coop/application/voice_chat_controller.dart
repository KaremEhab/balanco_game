import 'dart:async';
import 'dart:io';

import 'package:balanco_game/features/coop/application/coop_realtime_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// A small WebRTC mesh suitable for Balanco's two-player CO-OP rooms and
/// two-to-four-player Race rooms. Every signal is explicitly targeted so a
/// third answer can never overwrite another player's peer connection.
class VoiceChatController {
  VoiceChatController({
    required this.realtime,
    required this.isHost,
    required this.userId,
  });

  final CoopRealtimeSession realtime;
  final bool isHost;
  final String userId;
  final ValueNotifier<bool> muted = ValueNotifier(false);
  final ValueNotifier<bool> connected = ValueNotifier(false);
  final ValueNotifier<int> connectedPeers = ValueNotifier(0);
  final ValueNotifier<String?> activeSpeakerId = ValueNotifier(null);
  final ValueNotifier<String?> error = ValueNotifier(null);

  final Map<String, RTCPeerConnection> _peers = {};
  final Map<String, List<RTCIceCandidate>> _pendingCandidates = {};
  final Set<String> _remoteDescriptionReady = {};
  final Set<String> _negotiating = {};
  final Set<String> _connectedPeerIds = {};
  final Map<String, String> _lastOfferSdp = {};
  MediaStream? _localStream;
  StreamSubscription<Map<String, dynamic>>? _subscription;
  Timer? _signalRetryTimer;
  Timer? _gameplayAudioRecoveryTimer;
  Timer? _audioLevelTimer;
  bool _initializing = false;
  bool _samplingLevels = false;
  bool _disposed = false;

  static const _turnUrl = String.fromEnvironment('BALANCO_TURN_URL');
  static const _turnUsername = String.fromEnvironment('BALANCO_TURN_USERNAME');
  static const _turnCredential = String.fromEnvironment(
    'BALANCO_TURN_CREDENTIAL',
  );

  Future<void> initialize() async {
    if (_disposed || _initializing) return;
    if (_localStream != null) {
      await recoverForGameplay();
      return;
    }
    _initializing = true;
    try {
      await _configureCallAudio();
      _localStream = await navigator.mediaDevices.getUserMedia({
        'audio': {
          'echoCancellation': true,
          'noiseSuppression': true,
          'autoGainControl': true,
        },
        'video': false,
      });
      await _configureCallAudio();
      _subscription = realtime.events.listen(
        (message) => unawaited(_handleSignalSafely(message)),
      );
      await realtime.send('voice_ready', const {});
      _signalRetryTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        if (connectedPeers.value < 1) {
          unawaited(realtime.send('voice_ready', const {}));
        }
      });
      _audioLevelTimer = Timer.periodic(
        const Duration(milliseconds: 250),
        (_) => unawaited(_sampleAudioLevels()),
      );
    } catch (exception) {
      error.value = 'Microphone unavailable: $exception';
      await _releaseMedia();
    } finally {
      _initializing = false;
    }
  }

  Future<RTCPeerConnection> _ensurePeer(String remoteId) async {
    final existing = _peers[remoteId];
    if (existing != null) return existing;
    final peer = await createPeerConnection({
      'sdpSemantics': 'unified-plan',
      'iceServers': <Map<String, dynamic>>[
        {
          'urls': <String>[
            'stun:stun.l.google.com:19302',
            'stun:stun1.l.google.com:19302',
          ],
        },
        if (_turnUrl.isNotEmpty)
          {
            'urls': _turnUrl,
            'username': _turnUsername,
            'credential': _turnCredential,
          },
      ],
    });
    _peers[remoteId] = peer;
    _pendingCandidates.putIfAbsent(remoteId, () => []);
    for (final track
        in _localStream?.getAudioTracks() ?? <MediaStreamTrack>[]) {
      await peer.addTrack(track, _localStream!);
    }
    peer.onIceCandidate = (candidate) {
      if (candidate.candidate == null) return;
      unawaited(
        realtime.send('voice_ice', {
          'target': remoteId,
          'candidate': candidate.candidate,
          'sdp_mid': candidate.sdpMid,
          'sdp_mline_index': candidate.sdpMLineIndex,
        }),
      );
    };
    peer.onTrack = (event) {
      if (event.track.kind == 'audio') {
        _markPeerConnected(remoteId, true);
        unawaited(_configureCallAudio());
      }
    };
    peer.onConnectionState = (state) {
      final isConnected =
          state == RTCPeerConnectionState.RTCPeerConnectionStateConnected;
      _markPeerConnected(remoteId, isConnected);
      if (isConnected) {
        error.value = null;
        unawaited(_configureCallAudio());
      } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        error.value = _turnUrl.isEmpty
            ? 'Voice network path failed. Configure a TURN server for '
                  'reliable calls across mobile networks.'
            : 'Voice network path failed. Reconnecting…';
      }
    };
    peer.onIceConnectionState = (state) {
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        _lastOfferSdp.remove(remoteId);
        unawaited(peer.restartIce());
        if (_shouldOffer(remoteId)) unawaited(_createOffer(remoteId));
      }
    };
    return peer;
  }

  bool _shouldOffer(String remoteId) => userId.compareTo(remoteId) < 0;

  void _markPeerConnected(String remoteId, bool value) {
    if (value) {
      _connectedPeerIds.add(remoteId);
    } else {
      _connectedPeerIds.remove(remoteId);
    }
    connectedPeers.value = _connectedPeerIds.length;
    connected.value = _connectedPeerIds.isNotEmpty;
  }

  Future<void> _configureCallAudio() async {
    if (Platform.isAndroid) {
      await Helper.setAndroidAudioConfiguration(
        AndroidAudioConfiguration.communication,
      );
      await Helper.setSpeakerphoneOnButPreferBluetooth();
    } else if (Platform.isIOS) {
      await Helper.setAppleAudioConfiguration(
        AppleAudioConfiguration(
          appleAudioCategory: AppleAudioCategory.playAndRecord,
          appleAudioCategoryOptions: {
            AppleAudioCategoryOption.allowBluetooth,
            AppleAudioCategoryOption.defaultToSpeaker,
          },
          appleAudioMode: AppleAudioMode.voiceChat,
        ),
      );
      await Helper.setSpeakerphoneOnButPreferBluetooth();
    }
  }

  Future<void> recoverForGameplay() async {
    if (_disposed) return;
    if (_localStream == null) {
      await initialize();
      return;
    }
    try {
      await _configureCallAudio();
      for (final track in _localStream!.getAudioTracks()) {
        track.enabled = !muted.value;
      }
      error.value = null;
      await realtime.send('voice_ready', const {});
      for (final remoteId in _peers.keys) {
        if (_shouldOffer(remoteId) && !_connectedPeerIds.contains(remoteId)) {
          await _createOffer(remoteId);
        }
      }
    } catch (exception) {
      error.value = 'Voice audio recovery failed: $exception';
    }
  }

  void scheduleGameplayRecovery() {
    if (_disposed) return;
    unawaited(recoverForGameplay());
    _gameplayAudioRecoveryTimer?.cancel();
    _gameplayAudioRecoveryTimer = Timer(
      const Duration(milliseconds: 800),
      () => unawaited(recoverForGameplay()),
    );
  }

  Future<void> _handleSignalSafely(Map<String, dynamic> message) async {
    try {
      await _handleSignal(message);
    } catch (exception) {
      error.value = 'Voice connection failed: $exception';
    }
  }

  Future<void> _handleSignal(Map<String, dynamic> message) async {
    final remoteId = message['from'] as String?;
    if (remoteId == null || remoteId == userId) return;
    final target = message['target'] as String?;
    if (target != null && target != userId) return;
    final type = message['action'] as String?;
    if (!const {
      'voice_ready',
      'voice_offer',
      'voice_answer',
      'voice_ice',
    }.contains(type)) {
      return;
    }
    final peer = await _ensurePeer(remoteId);
    if (type == 'voice_ready') {
      if (_shouldOffer(remoteId)) await _createOffer(remoteId);
    } else if (type == 'voice_offer') {
      await peer.setRemoteDescription(
        RTCSessionDescription(message['sdp'] as String, 'offer'),
      );
      _remoteDescriptionReady.add(remoteId);
      await _flushCandidates(remoteId);
      final answer = await peer.createAnswer();
      await peer.setLocalDescription(answer);
      await realtime.send('voice_answer', {
        'target': remoteId,
        'sdp': answer.sdp,
      });
    } else if (type == 'voice_answer') {
      await peer.setRemoteDescription(
        RTCSessionDescription(message['sdp'] as String, 'answer'),
      );
      _remoteDescriptionReady.add(remoteId);
      await _flushCandidates(remoteId);
    } else if (type == 'voice_ice') {
      final candidate = RTCIceCandidate(
        message['candidate'] as String?,
        message['sdp_mid'] as String?,
        message['sdp_mline_index'] as int?,
      );
      if (_remoteDescriptionReady.contains(remoteId)) {
        await peer.addCandidate(candidate);
      } else {
        _pendingCandidates[remoteId]!.add(candidate);
      }
    }
  }

  Future<void> _createOffer(String remoteId) async {
    final peer = _peers[remoteId];
    if (peer == null ||
        _negotiating.contains(remoteId) ||
        _connectedPeerIds.contains(remoteId)) {
      return;
    }
    final cached = _lastOfferSdp[remoteId];
    if (cached != null) {
      await realtime.send('voice_offer', {'target': remoteId, 'sdp': cached});
      return;
    }
    _negotiating.add(remoteId);
    try {
      final offer = await peer.createOffer({'offerToReceiveAudio': true});
      await peer.setLocalDescription(offer);
      if (offer.sdp != null) _lastOfferSdp[remoteId] = offer.sdp!;
      await realtime.send('voice_offer', {
        'target': remoteId,
        'sdp': offer.sdp,
      });
    } finally {
      _negotiating.remove(remoteId);
    }
  }

  Future<void> _flushCandidates(String remoteId) async {
    final peer = _peers[remoteId];
    for (final candidate in _pendingCandidates[remoteId] ?? const []) {
      await peer?.addCandidate(candidate);
    }
    _pendingCandidates[remoteId]?.clear();
  }

  Future<void> _sampleAudioLevels() async {
    if (_samplingLevels || _disposed) return;
    _samplingLevels = true;
    try {
      String? loudestId;
      var loudestLevel = 0.025;
      for (final entry in _peers.entries) {
        final reports = await entry.value.getStats();
        for (final dynamic report in reports) {
          final values = Map<String, dynamic>.from(report.values as Map);
          final type = report.type?.toString() ?? '';
          final kind = values['kind'] ?? values['mediaType'];
          if (kind != 'audio' ||
              (type != 'inbound-rtp' &&
                  type != 'outbound-rtp' &&
                  type != 'media-source')) {
            continue;
          }
          final level = (values['audioLevel'] as num?)?.toDouble() ?? 0;
          if (level > loudestLevel) {
            loudestLevel = level;
            loudestId = type == 'inbound-rtp' ? entry.key : userId;
          }
        }
      }
      activeSpeakerId.value = loudestId;
    } catch (_) {
      // Audio-level fields vary by WebRTC engine. Voice remains connected even
      // when the optional speaking indicator is unavailable.
    } finally {
      _samplingLevels = false;
    }
  }

  void toggleMute() {
    muted.value = !muted.value;
    for (final track
        in _localStream?.getAudioTracks() ?? const <MediaStreamTrack>[]) {
      track.enabled = !muted.value;
    }
    if (muted.value) activeSpeakerId.value = null;
    unawaited(realtime.send('mic_state', {'muted': muted.value}));
  }

  Future<void> _releaseMedia() async {
    _signalRetryTimer?.cancel();
    _audioLevelTimer?.cancel();
    _signalRetryTimer = null;
    _audioLevelTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    for (final track
        in _localStream?.getTracks() ?? const <MediaStreamTrack>[]) {
      track.stop();
    }
    await _localStream?.dispose();
    _localStream = null;
    for (final peer in _peers.values) {
      await peer.close();
    }
    _peers.clear();
    _pendingCandidates.clear();
    _remoteDescriptionReady.clear();
    _negotiating.clear();
    _connectedPeerIds.clear();
    _lastOfferSdp.clear();
    connectedPeers.value = 0;
    connected.value = false;
    activeSpeakerId.value = null;
  }

  Future<void> dispose() async {
    _disposed = true;
    _gameplayAudioRecoveryTimer?.cancel();
    await _releaseMedia();
    muted.dispose();
    connected.dispose();
    connectedPeers.dispose();
    activeSpeakerId.dispose();
    error.dispose();
  }
}
