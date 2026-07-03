import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/calendar_event_model.dart';

class CalendarRemoteDataSource {
  final ApiClient _apiClient;

  CalendarRemoteDataSource(this._apiClient);

  Future<List<CalendarEventModel>> getEvents({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.calendarEvents,
      queryParameters: {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      },
    );
    final data = response.data as List<dynamic>;
    return data
        .map((e) => CalendarEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CalendarEventModel> getEvent(String id) async {
    final response = await _apiClient.get('${ApiConstants.calendarEvent}$id');
    return CalendarEventModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<CalendarEventModel> createEvent(CalendarEventModel event) async {
    final response = await _apiClient.post(
      ApiConstants.calendarEvents,
      data: event.toJson(),
    );
    return CalendarEventModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<CalendarEventModel> updateEvent(CalendarEventModel event) async {
    final response = await _apiClient.put(
      '${ApiConstants.calendarEvent}${event.id}',
      data: event.toJson(),
    );
    return CalendarEventModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteEvent(String id) async {
    await _apiClient.delete('${ApiConstants.calendarEvent}$id');
  }
}
