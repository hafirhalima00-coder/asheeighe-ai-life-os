import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../app/app_config.dart';
import '../models/calendar_event_model.dart';

class CalendarLocalDataSource {
  late Box<String> _box;

  Future<void> init() async {
    _box = await Hive.openBox<String>(AppConfig.hiveBoxName);
  }

  String _eventsKey(DateTime start, DateTime end) =>
      'calendar_events_${start.toIso8601String()}_${end.toIso8601String()}';

  String _eventKey(String id) => 'calendar_event_$id';

  Future<void> cacheEvents({
    required DateTime startDate,
    required DateTime endDate,
    required List<CalendarEventModel> events,
  }) async {
    final json = jsonEncode(events.map((e) => e.toJson()).toList());
    await _box.put(_eventsKey(startDate, endDate), json);
    for (final event in events) {
      await _box.put(_eventKey(event.id), jsonEncode(event.toJson()));
    }
  }

  List<CalendarEventModel>? getCachedEvents({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final json = _box.get(_eventsKey(startDate, endDate));
    if (json == null) return null;
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => CalendarEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> cacheEvent(CalendarEventModel event) async {
    await _box.put(_eventKey(event.id), jsonEncode(event.toJson()));
  }

  CalendarEventModel? getCachedEvent(String id) {
    final json = _box.get(_eventKey(id));
    if (json == null) return null;
    return CalendarEventModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> deleteCachedEvent(String id) async {
    await _box.delete(_eventKey(id));
  }

  Future<void> clearCache() async {
    final keys = _box.keys.where((k) => k.startsWith('calendar_'));
    for (final key in keys) {
      await _box.delete(key);
    }
  }
}
