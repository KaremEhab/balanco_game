import 'dart:async';
import 'dart:io';

import 'package:balanco_game/features/coop/application/coop_realtime_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

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
  final ValueNotifier<String?> error = ValueNotifier(null);
  RTCPeerConnection? _peer;
  MediaStream? _localStream;
  StreamSubscription<Map<String, dynamic>>? _subscription;
  Timer? _signalRetryTimer;
  Timer? _gameplayAudioRecoveryTimer;
  final List<RTCIceCandidate> _pendingCandidates = [];
  bool _remoteDescriptionReady = false;
  bool _negotiating = false;
  bool _initializing = false;
  bool _disposed = false;
  String? _lastOfferSdp;

  static const _turnUrl = String.fromEnvironment('BALANCO_TURN_URL');
  static const _turnUsername = String.fromEnvironment('BALANCO_TURN_USERNAME');
  static const _turnCredential = String.fromEnvironment(
    'BALANCO_TURN_CREDENTIAL',
  );

  Future<void> initialize() async {
    if (_disposed || _initializing) return;
    if (_peer != null && _localStream != null) {
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
      _peer = await createPeerConnection({
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
      for (final track in _localStream!.getAudioTracks()) {
        await _peer!.addTrack(track, _localStream!);
      }
      _peer!.onIceCandidate = (candidate) {
        if (candidate.candidate == null) return;
        unawaited(
          realtime.send('voice_ice', {
            'candidate': candidate.candidate,
            'sdp_mid': candidate.sdpMid,
            'sdp_mline_index': candidate.sdpMLineIndex,
          }),
        );
      };
      _peer!.onTrack = (event) {
        if (event.track.kind == 'audio') {
          connected.value = true;
          unawaited(_configureCallAudio());
        }
      };
      _peer!.onConnectionState = (state) {
        connected.value =
            state == RTCPeerConnectionState.RTCPeerConnectionStateConnected;
        if (connected.value) {
          error.value = null;
          unawaited(_configureCallAudio());
        } else if (state ==
            RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
          error.value = _turnUrl.isEmpty
              ? 'Voice network path failed. Configure a TURN server for '
                    'reliable calls across mobile networks.'
              : 'Voice network path failed. Reconnecting…';
        }
      };
      _peer!.onIceConnectionState = (state) {
        if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
          _lastOfferSdp = null;
          unawaited(_peer?.restartIce());
          if (isHost) unawaited(_createOffer());
        }
      };
      _subscription = realtime.events.listen(
        (message) => unawaited(_handleSignalSafely(message)),
      );
      await realtime.send('voice_ready', const {});
      _signalRetryTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!connected.value) {
          unawaited(realtime.send('voice_ready', const {}));
        }
      });
    } catch (exception) {
      error.value = 'Microphone unavailable: $exception';
      await _releaseMedia();
    } finally {
      _initializing = false;
    }
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
            // HFP Bluetooth supports both the microphone and call audio.
            // A2DP is output-only and can make iOS drop the mic input route.
            AppleAudioCategoryOption.allowBluetooth,
            AppleAudioCategoryOption.defaultToSpeaker,
          },
          appleAudioMode: AppleAudioMode.voiceChat,
        ),
      );
      await Helper.setSpeakerphoneOnButPreferBluetooth();
    }
  }

  /// Flame/audio-player setup can replace AVAudioSession while the two Race
  /// boards mount. Restore WebRTC's call category after gameplay is visible,
  /// and retry once after asynchronous asset loading has settled.
  Future<void> recoverForGameplay() async {
    if (_disposed) return;
    if (_peer == null || _localStream == null) {
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
      if (isHost && !connected.value) await _createOffer();
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
      error.value = null;
    } catch (exception) {
      error.value = 'Voice connection failed: $exception';
    }
  }

  Future<void> _handleSignal(Map<String, dynamic> message) async {
    if (message['from'] == userId) return;
    final type = message['action'] as String?;
    if (type == 'voice_ready' && isHost) {
      await _createOffer();
    } else if (type == 'voice_offer' && !isHost) {
      await _peer?.setRemoteDescription(
        RTCSessionDescription(message['sdp'] as String, 'offer'),
      );
      _remoteDescriptionReady = true;
      await _flushCandidates();
      final answer = await _peer!.createAnswer();
      await _peer!.setLocalDescription(answer);
      await realtime.send('voice_answer', {'sdp': answer.sdp});
    } else if (type == 'voice_answer' && isHost) {
      await _peer?.setRemoteDescription(
        RTCSessionDescription(message['sdp'] as String, 'answer'),
      );
      _remoteDescriptionReady = true;
      await _flushCandidates();
    } else if (type == 'voice_ice') {
      final candidate = RTCIceCandidate(
        message['candidate'] as String?,
        message['sdp_mid'] as String?,
        message['sdp_mline_index'] as int?,
      );
      if (_remoteDescriptionReady) {
        await _peer?.addCandidate(candidate);
      } else {
        _pendingCandidates.add(candidate);
      }
    }
  }

  Future<void> _createOffer() async {
    if (_peer == null || _negotiating || connected.value) return;
    if (_lastOfferSdp != null) {
      await realtime.send('voice_offer', {'sdp': _lastOfferSdp});
      return;
    }
    _negotiating = true;
    try {
      final offer = await _peer!.createOffer({'offerToReceiveAudio': true});
      await _peer!.setLocalDescription(offer);
      _lastOfferSdp = offer.sdp;
      await realtime.send('voice_offer', {'sdp': offer.sdp});
    } finally {
      _negotiating = false;
    }
  }

  Future<void> _flushCandidates() async {
    for (final candidate in _pendingCandidates) {
      await _peer?.addCandidate(candidate);
    }
    _pendingCandidates.clear();
  }

  void toggleMute() {
    muted.value = !muted.value;
    for (final track
        in _localStream?.getAudioTracks() ?? const <MediaStreamTrack>[]) {
      track.enabled = !muted.value;
    }
    unawaited(realtime.send('mic_state', {'muted': muted.value}));
  }

  Future<void> _releaseMedia() async {
    _signalRetryTimer?.cancel();
    _signalRetryTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    for (final track
        in _localStream?.getTracks() ?? const <MediaStreamTrack>[]) {
      track.stop();
    }
    await _localStream?.dispose();
    _localStream = null;
    await _peer?.close();
    _peer = null;
    _pendingCandidates.clear();
    _remoteDescriptionReady = false;
    _negotiating = false;
    _lastOfferSdp = null;
    connected.value = false;
  }

  Future<void> dispose() async {
    _disposed = true;
    _gameplayAudioRecoveryTimer?.cancel();
    await _releaseMedia();
    muted.dispose();
    connected.dispose();
    error.dispose();
  }
}
