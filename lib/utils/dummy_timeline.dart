import 'package:matrix/matrix.dart';

class DummyTimeline extends Timeline {
  @override
  bool get allowNewEvent => throw UnimplementedError();

  @override
  bool get canRequestFuture => throw UnimplementedError();

  @override
  bool get canRequestHistory => throw UnimplementedError();

  @override
  void cancelSubscriptions() {}

  @override
  List<Event> get events => throw UnimplementedError();

  @override
  Future<void> fetchAggregatedEvents(
    String eventId,
    String relType, {
    String? eventType,
  }) async {}

  @override
  Future<Event?> getEventById(String id) async {
    return null;
  }

  @override
  bool get isFragmentedTimeline => true;

  @override
  bool get isRequestingFuture => false;

  @override
  bool get isRequestingHistory => false;

  @override
  Future<void> requestFuture({
    int historyCount = Room.defaultHistoryCount,
    StateFilter? filter,
  }) async {}

  @override
  Future<void> requestHistory({
    int historyCount = Room.defaultHistoryCount,
    StateFilter? filter,
  }) async {}

  @override
  void requestKeys({
    bool tryOnlineBackup = true,
    bool onlineKeyBackupOnly = true,
  }) {}

  @override
  Future<void> setReadMarker({String? eventId, bool? public}) async {}

  @override
  Stream<(List<Event>, String?)> startSearch({
    String? searchTerm,
    int requestHistoryCount = 100,
    int maxHistoryRequests = 10,
    String? prevBatch,
    String? sinceEventId,
    int? limit,
    bool Function(Event)? searchFunc,
  }) {
    return Stream.empty();
  }
}
