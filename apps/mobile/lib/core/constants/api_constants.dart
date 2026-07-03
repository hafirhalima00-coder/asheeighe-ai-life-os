class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://api.asheeighe.app/v1';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String profile = '/auth/profile';
  static const String updateProfile = '/auth/profile';
  static const String deleteAccount = '/auth/account';
  static const String googleSignIn = '/auth/google';
  static const String appleSignIn = '/auth/apple';

  static const String tasks = '/tasks';
  static const String task = '/tasks/';
  static const String taskComplete = '/tasks/';
  static const String taskSubtasks = '/tasks/';
  static const String taskAttachments = '/tasks/';

  static const String notes = '/notes';
  static const String note = '/notes/';
  static const String noteShare = '/notes/';

  static const String reminders = '/reminders';
  static const String reminder = '/reminders/';
  static const String reminderDismiss = '/reminders/';

  static const String calendar = '/calendar';
  static const String calendarEvents = '/calendar/events';
  static const String calendarEvent = '/calendar/events/';

  static const String chat = '/chat';
  static const String chatConversations = '/chat/conversations';
  static const String chatConversation = '/chat/conversations/';
  static const String chatMessages = '/chat/conversations/';
  static const String chatSend = '/chat/conversations/';

  static const String composio = '/composio';
  static const String composioConnect = '/composio/connect';
  static const String composioDisconnect = '/composio/disconnect';
  static const String composioStatus = '/composio/status';

  static const String settings = '/settings';
  static const String notifications = '/settings/notifications';
  static const String privacy = '/settings/privacy';
  static const String theme = '/settings/theme';

  static const String upload = '/upload';

  static const String headers = 'headers';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer ';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String multipartForm = 'multipart/form-data';
  static const String acceptLanguage = 'Accept-Language';
  static const String xDeviceId = 'X-Device-Id';
  static const String xAppVersion = 'X-App-Version';
  static const String xPlatform = 'X-Platform';
}
