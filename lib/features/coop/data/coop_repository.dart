import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/coop/domain/player_social_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoopRepository {
  CoopRepository(this._client);
  final SupabaseClient _client;

  Future<CoopRoom> createRoom(CoopSide side) =>
      _roomRpc('create_coop_room', {'p_side': side.value});

  Future<CoopRoom> createRaceRoom({int maxPlayers = 2}) =>
      _roomRpc('create_race_room', {'p_max_players': maxPlayers});

  Future<CoopRoom> joinRoom(String code) =>
      _roomRpc('join_coop_room', {'p_code': code.trim().toUpperCase()});

  Future<CoopRoom> joinRaceRoom(String code) =>
      _roomRpc('join_race_room', {'p_code': code.trim().toUpperCase()});

  Future<CoopRoom> getRoom(String roomId) =>
      _roomRpc('get_coop_room_state', {'p_room_id': roomId});

  Future<CoopRoom?> getMyActiveRoom() async {
    final result = await _client.rpc('get_my_active_game_room');
    if (result == null) return null;
    return CoopRoom.fromJson(Map<String, dynamic>.from(result as Map));
  }

  Future<CoopRoom> setReady(String roomId, bool ready) =>
      _roomRpc('set_coop_ready', {'p_room_id': roomId, 'p_ready': ready});

  Future<CoopRoom> swapSides(String roomId) =>
      _roomRpc('swap_coop_sides', {'p_room_id': roomId});

  Future<CoopRoom> startRoom(String roomId) =>
      _roomRpc('start_coop_room', {'p_room_id': roomId});

  Future<CoopRoom> setPaused(String roomId, bool paused) =>
      _roomRpc('set_coop_pause', {'p_room_id': roomId, 'p_paused': paused});

  Future<CoopRoom> voteLeave(String roomId, bool approve) =>
      _roomRpc('vote_coop_leave', {'p_room_id': roomId, 'p_approve': approve});

  Future<CoopRoom> votePostgameExit(String roomId, bool approve) => _roomRpc(
    'vote_coop_postgame_exit',
    {'p_room_id': roomId, 'p_approve': approve},
  );

  Future<CoopRoom> completeRun(
    String roomId, {
    required int score,
    required int coins,
  }) => _roomRpc('complete_coop_run', {
    'p_room_id': roomId,
    'p_score': score,
    'p_coins': coins,
  });

  Future<CoopRoom> retryRoom(String roomId) =>
      _roomRpc('retry_coop_room', {'p_room_id': roomId});

  Future<CoopRoom> finishRace(
    String roomId, {
    required double progress,
    required int hearts,
    required int stars,
  }) => _roomRpc('finish_race', {
    'p_room_id': roomId,
    'p_progress': progress,
    'p_hearts': hearts,
    'p_stars': stars,
  });

  Future<CoopRoom> surrenderRace(String roomId) =>
      _roomRpc('surrender_race', {'p_room_id': roomId});

  Future<void> leaveRaceRoom(String roomId) async {
    await _client.rpc('leave_race_room', params: {'p_room_id': roomId});
  }

  Future<CoopRoom> maintainRacePresence(String roomId) =>
      _roomRpc('maintain_race_presence', {'p_room_id': roomId});

  Future<CoopRoom> voteRaceRestart(String roomId, String kind) =>
      _roomRpc('vote_race_restart', {'p_room_id': roomId, 'p_kind': kind});

  Future<CoopRoom> inviteFriend({
    required String playerCode,
    required CoopSide side,
  }) => invitePlayerToGame(
    playerCode: playerCode,
    mode: 'coop',
    maxPlayers: 2,
    side: side,
  );

  Future<CoopRoom> invitePlayerToGame({
    required String playerCode,
    required String mode,
    required int maxPlayers,
    String? roomId,
    CoopSide side = CoopSide.left,
  }) => _roomRpc('invite_friend_to_game', {
    'p_friend_code': playerCode.trim().toUpperCase(),
    'p_mode': mode,
    'p_max_players': maxPlayers,
    'p_room_id': roomId,
    'p_side': side.value,
  });

  Future<CoopRoom?> respondCoopInvite(String inviteId, bool accept) async {
    final result = await _client.rpc(
      'respond_coop_invite',
      params: {'p_invite_id': inviteId, 'p_accept': accept},
    );
    if (result == null) return null;
    return CoopRoom.fromJson(Map<String, dynamic>.from(result as Map));
  }

  Future<PlayerCodeResult?> findPlayer(String code) async {
    final result = await _client.rpc(
      'find_player_by_code',
      params: {'p_code': code.trim().toUpperCase()},
    );
    if (result == null) return null;
    return PlayerCodeResult.fromJson(Map<String, dynamic>.from(result as Map));
  }

  Future<void> sendFriendRequest(String code) => _client.rpc(
    'send_friend_request',
    params: {'p_player_code': code.trim().toUpperCase()},
  );

  Future<Map<String, dynamic>> listFriends() async =>
      Map<String, dynamic>.from(await _client.rpc('list_my_friends') as Map);

  Future<void> respondFriendRequest(String requestId, bool accept) =>
      _client.rpc(
        'respond_friend_request',
        params: {'p_request_id': requestId, 'p_accept': accept},
      );

  Future<PlayerSocialProfile> getPlayerSocialProfile(String userId) async {
    final result = await _client.rpc(
      'get_player_social_profile',
      params: {'p_user_id': userId},
    );
    final profile = PlayerSocialProfile.fromJson(
      Map<String, dynamic>.from(result as Map),
    );
    if (!profile.isSelf) return profile;

    try {
      final wallet = await _client
          .from('player_wallets')
          .select()
          .eq('user_id', userId)
          .single();
      final unlocks = await _client
          .from('player_unlocks')
          .select('user_id')
          .eq('user_id', userId);
      return profile.withPrivateStats(
        coins: (wallet['coins'] as num?)?.toInt() ?? 0,
        moneyCents: (wallet['money_cents'] as num?)?.toInt() ?? 0,
        sparks: (wallet['sparks'] as num?)?.toInt() ?? 0,
        maxSparks: (wallet['max_sparks'] as num?)?.toInt() ?? 5,
        unlockedItems: unlocks.length,
      );
    } on PostgrestException {
      return profile;
    }
  }

  Future<CoopRoom> _roomRpc(
    String function,
    Map<String, dynamic> params,
  ) async {
    final result = await _client.rpc(function, params: params);
    return CoopRoom.fromJson(Map<String, dynamic>.from(result as Map));
  }
}
