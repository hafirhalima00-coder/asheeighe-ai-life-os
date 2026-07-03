import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:asheeighe/features/dashboard/domain/entities/weather_info.dart';

void main() {
  group('WeatherInfo', () {
    test('should create with required fields', () {
      const info = WeatherInfo(
        condition: 'Sunny',
        temperature: 25.0,
        icon: 'sun',
        location: 'NYC',
      );
      expect(info.condition, 'Sunny');
      expect(info.temperature, 25.0);
      expect(info.icon, 'sun');
      expect(info.location, 'NYC');
    });

    test('should support value equality', () {
      const info1 = WeatherInfo(condition: 'a', temperature: 1, icon: 'b', location: 'c');
      const info2 = WeatherInfo(condition: 'a', temperature: 1, icon: 'b', location: 'c');
      expect(info1, equals(info2));
    });

    test('props should contain all fields', () {
      const info = WeatherInfo(condition: 'a', temperature: 1, icon: 'b', location: 'c');
      expect(info.props, ['a', 1.0, 'b', 'c']);
    });
  });

  group('CalendarEvent', () {
    final start = DateTime(2024, 6, 15, 10);
    final end = DateTime(2024, 6, 15, 11);

    test('should create with required fields', () {
      final event = CalendarEvent(
        id: '1',
        title: 'Meeting',
        startTime: start,
        endTime: end,
      );
      expect(event.id, '1');
      expect(event.title, 'Meeting');
      expect(event.startTime, start);
      expect(event.endTime, end);
    });

    test('should support value equality', () {
      final e1 = CalendarEvent(id: '1', title: 'M', startTime: start, endTime: end);
      final e2 = CalendarEvent(id: '1', title: 'M', startTime: start, endTime: end);
      expect(e1, equals(e2));
    });

    test('props should contain all fields', () {
      final event = CalendarEvent(id: '1', title: 'M', startTime: start, endTime: end);
      expect(event.props, ['1', 'M', start, end, null, null]);
    });
  });

  group('Task', () {
    test('should create with required fields', () {
      final task = Task(id: '1', title: 'Buy groceries');
      expect(task.id, '1');
      expect(task.title, 'Buy groceries');
      expect(task.isCompleted, false);
      expect(task.priority, 'medium');
    });

    test('copyWith should update isCompleted', () {
      final task = Task(id: '1', title: 'Test');
      final updated = task.copyWith(isCompleted: true);
      expect(updated.isCompleted, true);
      expect(updated.id, task.id);
    });

    test('should support equality', () {
      final t1 = Task(id: '1', title: 'A');
      final t2 = Task(id: '1', title: 'A');
      expect(t1, equals(t2));
    });
  });

  group('Reminder', () {
    final scheduled = DateTime(2024, 6, 15, 9);

    test('should create with required fields', () {
      final reminder = Reminder(
        id: '1',
        title: 'Meeting',
        scheduledAt: scheduled,
      );
      expect(reminder.id, '1');
      expect(reminder.title, 'Meeting');
      expect(reminder.isActive, true);
    });

    test('should support equality', () {
      final r1 = Reminder(id: '1', title: 'A', scheduledAt: scheduled);
      final r2 = Reminder(id: '1', title: 'A', scheduledAt: scheduled);
      expect(r1, equals(r2));
    });
  });

  group('Note', () {
    final createdAt = DateTime(2024, 6, 15);

    test('should create with required fields', () {
      final note = Note(
        id: '1',
        title: 'My Note',
        content: 'Content',
        createdAt: createdAt,
      );
      expect(note.id, '1');
      expect(note.title, 'My Note');
      expect(note.content, 'Content');
      expect(note.tags, isEmpty);
    });

    test('should support equality', () {
      final n1 = Note(id: '1', title: 'A', content: 'B', createdAt: createdAt);
      final n2 = Note(id: '1', title: 'A', content: 'B', createdAt: createdAt);
      expect(n1, equals(n2));
    });
  });

  group('DashboardData', () {
    final date = DateTime(2024, 6, 15);

    test('should create with required fields', () {
      final data = DashboardData(greeting: 'Good morning', date: date);
      expect(data.greeting, 'Good morning');
      expect(data.date, date);
      expect(data.focusScore, 75);
      expect(data.upcomingEvents, isEmpty);
      expect(data.pendingTasks, isEmpty);
      expect(data.activeReminders, isEmpty);
      expect(data.recentNotes, isEmpty);
      expect(data.weather, isNull);
    });

    test('copyWith should update fields', () {
      final data = DashboardData(greeting: 'Hi', date: date);
      final updated = data.copyWith(focusScore: 90, wellnessTip: 'Stay hydrated');
      expect(updated.focusScore, 90);
      expect(updated.wellnessTip, 'Stay hydrated');
      expect(updated.greeting, 'Hi');
    });

    test('should support equality', () {
      final d1 = DashboardData(greeting: 'Hi', date: date);
      final d2 = DashboardData(greeting: 'Hi', date: date);
      expect(d1, equals(d2));
    });
  });
}
