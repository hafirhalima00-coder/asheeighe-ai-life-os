import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/features/calendar/data/models/calendar_event_model.dart';
import 'package:asheeighe/features/calendar/domain/entities/calendar_event.dart';

void main() {
  group('CalendarEventModel', () {
    final startTime = DateTime(2024, 6, 15, 10);
    final endTime = DateTime(2024, 6, 15, 11);
    final createdAt = DateTime(2024, 6, 14);
    final updatedAt = DateTime(2024, 6, 14);

    final testJson = <String, dynamic>{
      'id': 'evt1',
      'title': 'Team Meeting',
      'description': 'Sprint planning',
      'start_time': '2024-06-15T10:00:00.000',
      'end_time': '2024-06-15T11:00:00.000',
      'all_day': false,
      'recurrence': 'none',
      'color': '#FF6B9D',
      'location': 'Room 301',
      'url': 'https://meet.example.com',
      'notes': 'Bring laptop',
      'reminders': [
        {'id': 'r1', 'minutesBefore': 15, 'isEnabled': true},
      ],
      'calendar_type': 'work',
      'is_completed': false,
      'created_at': '2024-06-14T10:00:00.000',
      'updated_at': '2024-06-14T10:00:00.000',
    };

    group('fromJson', () {
      test('should parse full JSON correctly', () {
        final model = CalendarEventModel.fromJson(testJson);
        expect(model.id, 'evt1');
        expect(model.title, 'Team Meeting');
        expect(model.description, 'Sprint planning');
        expect(model.recurrence, 'none');
        expect(model.calendarType, 'work');
        expect(model.reminders.length, 1);
      });

      test('should handle minimal JSON', () {
        final json = <String, dynamic>{
          'id': '1',
          'title': 'Test',
          'start_time': '2024-06-15T10:00:00.000',
          'end_time': '2024-06-15T11:00:00.000',
          'created_at': '2024-06-14T10:00:00.000',
          'updated_at': '2024-06-14T10:00:00.000',
        };
        final model = CalendarEventModel.fromJson(json);
        expect(model.allDay, false);
        expect(model.recurrence, 'none');
        expect(model.calendarType, 'personal');
        expect(model.isCompleted, false);
        expect(model.reminders, isEmpty);
      });
    });

    group('toJson', () {
      test('should serialize to correct JSON', () {
        final model = CalendarEventModel.fromJson(testJson);
        final json = model.toJson();
        expect(json['id'], 'evt1');
        expect(json['title'], 'Team Meeting');
        expect(json['start_time'], '2024-06-15T10:00:00.000');
        expect(json['calendar_type'], 'work');
      });
    });

    group('toEntity / fromEntity', () {
      test('toEntity should map to CalendarEvent entity', () {
        final entity = CalendarEvent(
          id: 'evt1',
          title: 'Team Meeting',
          description: 'Sprint planning',
          startTime: startTime,
          endTime: endTime,
          allDay: false,
          recurrence: Recurrence.none,
          color: '#FF6B9D',
          location: 'Room 301',
          url: 'https://meet.example.com',
          notes: 'Bring laptop',
          reminders: [
            Reminder(id: 'r1', minutesBefore: 15, isEnabled: true),
          ],
          calendarType: CalendarType.work,
          isCompleted: false,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

        final model = CalendarEventModel.fromEntity(entity);
        expect(model.id, 'evt1');
        expect(model.title, 'Team Meeting');
        expect(model.recurrence, 'none');
        expect(model.calendarType, 'work');
      });

      test('toEntity -> fromEntity roundtrip', () {
        final entity = CalendarEvent(
          id: 'evt1',
          title: 'Test',
          startTime: startTime,
          endTime: endTime,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
        final model = CalendarEventModel.fromEntity(entity);
        final restored = model.toEntity();
        expect(restored.id, entity.id);
        expect(restored.title, entity.title);
        expect(restored.startTime, entity.startTime);
        expect(restored.endTime, entity.endTime);
      });

      test('toEntity should handle unknown enum values gracefully', () {
        final model = CalendarEventModel(
          id: '1',
          title: 'T',
          startTime: startTime,
          endTime: endTime,
          recurrence: 'unknown',
          calendarType: 'unknown',
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
        final entity = model.toEntity();
        expect(entity.recurrence, Recurrence.none);
        expect(entity.calendarType, CalendarType.personal);
      });
    });

    group('JSON roundtrip', () {
      test('should preserve values through fromJson/toJson', () {
        final model = CalendarEventModel.fromJson(testJson);
        final json = model.toJson();
        final restored = CalendarEventModel.fromJson(json);
        expect(restored.id, model.id);
        expect(restored.title, model.title);
        expect(restored.startTime, model.startTime);
        expect(restored.endTime, model.endTime);
      });
    });
  });
}
