import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:flutter/foundation.dart';

class ActiveRoomController extends ChangeNotifier {
  ActiveRoomController(this._repository);

  final CoopRepository _repository;
  CoopRoom? room;
  bool loading = true;
  bool resuming = false;
  bool discarding = false;
  String? error;
  bool _refreshing = false;
  bool _disposed = false;

  Future<void> refresh() async {
    if (_refreshing || _disposed) return;
    _refreshing = true;
    try {
      room = await _repository.getMyActiveRoom();
      error = null;
    } catch (_) {
      error = 'Your active room could not be checked.';
    } finally {
      loading = false;
      _refreshing = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<CoopRoom?> prepareResume() async {
    if (resuming || _disposed) return null;
    resuming = true;
    notifyListeners();
    try {
      room = await _repository.getMyActiveRoom();
      error = room == null ? 'That room is no longer active.' : null;
      return room;
    } catch (_) {
      error = 'Could not reconnect to that room. Check your connection.';
      return null;
    } finally {
      resuming = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<bool> discard() async {
    final activeRoom = room;
    if (activeRoom == null || discarding || _disposed) return false;
    discarding = true;
    error = null;
    notifyListeners();
    try {
      await _repository.discardActiveRoom(activeRoom.id);
      room = null;
      return true;
    } catch (_) {
      error = 'Could not close that room. Check your connection and try again.';
      return false;
    } finally {
      discarding = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
