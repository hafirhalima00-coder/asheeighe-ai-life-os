import 'package:flutter_test/flutter_test.dart';
import 'package:pinkz/features/dashboard/data/models/dashboard_data_model.dart';
import 'package:pinkz/features/dashboard/domain/entities/dashboard_data.dart';

void main() {
  group('DashboardDataModel', () {
    final startTime = DateTime(2024, 6, 15, 10);
    final endTime = DateTime(2024, 6, 15, 11);
    final createdAt = DateTime(2024, 6, 15);
    final scheduledAt = DateTime(2024, 6, 15, 9);

    final testJson = <String, dynamic>{
      'greeting': 'Good morning',
      'date': '2024-06-15T00:00:00.000',
      'weather': {
        'condition': 'Sunny',
        'temperature': 25.0,
        'icon': 'sun',
        'location': 'NYC',
      },
      'upcoming_events': [
        {
          'id': 'evt1',
          'title': 'Meeting',
          'start_time': '2024-06-15T10:00:00.000',
          'end_time': '2024-06-15T11:00:00.000',
          'location': 'Room A',
          'description': 'Team sync',
        },
      ],
      'pending_tasks': [
        {
          'id': 'task1',
          'title': 'Buy milk',
          'is_completed': false,
          'priority': 'high',
          'due_date': '2024-06-15T12:00:00.000',
          'category': 'shopping',
        },
      ],
      'active_reminders': [
        {
          'id': 'rem1',
          'title': 'Stand up',
          'scheduled_at': '2024-06-15T09:00:00.000',
          'is_active': true,
          'note': 'Stretch',
        },
      ],
      'recent_notes': [
        {
          'id': 'note1',
          'title': 'Ideas',
          'content': 'Some ideas',
          'created_at': '2024-06-15T08:00:00.000',
          'tags': ['creative'],
        },
      ],
      'focus_score': 85,
      'wellness_tip': 'Take a break',
    };

    group('fromJson', () {
      test('should parse full JSON correctly', () {
        final model = DashboardDataModel.fromJson(testJson);
        expect(model.greeting, 'Good morning');
        expect(model.focusScore, 85);
        expect(model.wellnessTip, 'Take a break');
        expect(model.weather, isNotNull);
        expect(model.upcomingEvents.length, 1);
        expect(model.pendingTasks.length, 1);
        expect(model.activeReminders.length, 1);
        expect(model.recentNotes.length, 1);
      });

      test('should handle empty lists', () {
        final json = <String, dynamic>{
          'greeting': 'Hi',
          'date': '2024-06-15T00:00:00.000',
        };
        final model = DashboardDataModel.fromJson(json);
        expect(model.upcomingEvents, isEmpty);
        expect(model.pendingTasks, isEmpty);
        expect(model.activeReminders, isEmpty);
        expect(model.recentNotes, isEmpty);
        expect(model.weather, isNull);
        expect(model.focusScore, 75);
      });
    });

    group('toJson', () {
      test('should serialize to correct JSON', () {
        final model = DashboardDataModel.fromJson(testJson);
        final json = model.toJson();
        expect(json['greeting'], 'Good morning');
        expect(json['focus_score'], 85);
        expect(json['upcoming_events'].length, 1);
        expect(json['pending_tasks'].length, 1);
      });
    });

    group('JSON roundtrip', () {
      test('should preserve values through fromJson/toJson', () {
        final model = DashboardDataModel.fromJson(testJson);
        final json = model.toJson();
        final restored = DashboardDataModel.fromJson(json);
        expect(restored.greeting, model.greeting);
        expect(restored.focusScore, model.focusScore);
        expect(restored.upcomingEvents.length, model.upcomingEvents.length);
        expect(restored.pendingTasks.length, model.pendingTasks.length);
      });
    });
  });

  group('CalendarEventModel', () {
    final json = <String, dynamic>{
      'id': 'evt1',
      'title': 'Meeting',
      'start_time': '2024-06-15T10:00:00.000',
      'end_time': '2024-06-15T11:00:00.000',
      'location': 'Room A',
      'description': 'Team sync',
    };

    test('fromJson should parse correctly', () {
      final model = CalendarEventModel.fromJson(json);
      expect(model.id, 'evt1');
      expect(model.title, 'Meeting');
      expect(model.location, 'Room A');
    });

    test('toJson should serialize correctly', () {
      final model = CalendarEventModel.fromJson(json);
      expect(model.toJson()['id'], 'evt1');
    });

    test('should handle null optional fields in fromJson', () {
      final minimal = <String, dynamic>{
        'id': '1',
        'title': 'T',
        'start_time': '2024-06-15T10:00:00.000',
        'end_time': '2024-06-15T11:00:00.000',
      };
      final model = CalendarEventModel.fromJson(minimal);
      expect(model.location, isNull);
      expect(model.description, isNull);
    });
  });

  group('TaskModel', () {
    final json = <String, dynamic>{
      'id': 'task1',
      'title': 'Buy milk',
      'is_completed': false,
      'priority': 'high',
      'due_date': '2024-06-15T12:00:00.000',
      'category': 'shopping',
    };

    test('fromJson should parse correctly', () {
      final model = TaskModel.fromJson(json);
      expect(model.id, 'task1');
      expect(model.title, 'Buy milk');
      expect(model.isCompleted, false);
      expect(model.priority, 'high');
    });

    test('toJson should serialize correctly', () {
      final model = TaskModel.fromJson(json);
      expect(model.toJson()['is_completed'], false);
    });
  });

  group('ReminderModel', () {
    final json = <String, dynamic>{
      'id': 'rem1',
      'title': 'Stand up',
      'scheduled_at': '2024-06-15T09:00:00.000',
      'is_active': true,
      'note': 'Stretch',
    };

    test('fromJson should parse correctly', () {
      final model = ReminderModel.fromJson(json);
      expect(model.id, 'rem1');
      expect(model.title, 'Stand up');
      expect(model.isActive, true);
    });

    test('toJson should serialize correctly', () {
      final model = ReminderModel.fromJson(json);
      expect(model.toJson()['is_active'], true);
    });
  });

  group('NoteModel', () {
    final json = <String, dynamic>{
      'id': 'note1',
      'title': 'Ideas',
      'content': 'Some ideas',
      'created_at': '2024-06-15T08:00:00.000',
      'tags': ['creative'],
    };

    test('fromJson should parse correctly', () {
      final model = NoteModel.fromJson(json);
      expect(model.id, 'note1');
      expect(model.title, 'Ideas');
      expect(model.content, 'Some ideas');
      expect(model.tags, ['creative']);
    });

    test('toJson should serialize correctly', () {
      final model = NoteModel.fromJson(json);
      expect(model.toJson()['tags'], ['creative']);
    });
  });
}
