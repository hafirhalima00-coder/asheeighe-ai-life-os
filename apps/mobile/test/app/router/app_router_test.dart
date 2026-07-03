import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/core/constants/api_constants.dart';
import 'package:asheeighe/core/router/route_names.dart';

void main() {
  group('RouteNames', () {
    test('should have all route name constants', () {
      expect(RouteNames.splash, 'splash');
      expect(RouteNames.login, 'login');
      expect(RouteNames.register, 'register');
      expect(RouteNames.forgotPassword, 'forgotPassword');
      expect(RouteNames.dashboard, 'dashboard');
      expect(RouteNames.calendar, 'calendar');
      expect(RouteNames.chat, 'chat');
      expect(RouteNames.tasks, 'tasks');
      expect(RouteNames.notes, 'notes');
      expect(RouteNames.notebooks, 'notebooks');
      expect(RouteNames.categories, 'categories');
      expect(RouteNames.reminders, 'reminders');
      expect(RouteNames.settings, 'settings');
      expect(RouteNames.profile, 'profile');
      expect(RouteNames.taskDetail, 'taskDetail');
      expect(RouteNames.noteDetail, 'noteDetail');
      expect(RouteNames.reminderDetail, 'reminderDetail');
      expect(RouteNames.eventDetail, 'eventDetail');
      expect(RouteNames.chatDetail, 'chatDetail');
      expect(RouteNames.composio, 'composio');
      expect(RouteNames.aiSettings, 'aiSettings');
      expect(RouteNames.integrationDetail, 'integrationDetail');
    });

    test('should have no empty route names', () {
      expect(RouteNames.splash, isNotEmpty);
      expect(RouteNames.login, isNotEmpty);
      expect(RouteNames.dashboard, isNotEmpty);
    });
  });

  group('ApiConstants', () {
    test('should have API endpoint constants', () {
      expect(ApiConstants.login, '/auth/login');
      expect(ApiConstants.register, '/auth/register');
      expect(ApiConstants.logout, '/auth/logout');
      expect(ApiConstants.tasks, '/tasks');
      expect(ApiConstants.notes, '/notes');
      expect(ApiConstants.reminders, '/reminders');
      expect(ApiConstants.calendar, '/calendar');
      expect(ApiConstants.chat, '/chat');
      expect(ApiConstants.composio, '/composio');
      expect(ApiConstants.settings, '/settings');
    });

    test('should have auth header constants', () {
      expect(ApiConstants.authorization, 'Authorization');
      expect(ApiConstants.bearer, 'Bearer ');
      expect(ApiConstants.contentType, 'Content-Type');
      expect(ApiConstants.applicationJson, 'application/json');
      expect(ApiConstants.multipartForm, 'multipart/form-data');
    });
  });
}
