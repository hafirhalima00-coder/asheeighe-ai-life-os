import 'dart:convert';
import 'package:http/http.dart' as http;

class CodeTutorRemoteDataSource {
  final String baseUrl;
  final String? authToken;

  CodeTutorRemoteDataSource({
    required this.baseUrl,
    this.authToken,
  });

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  Future<Map<String, dynamic>> getLanguages() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tutor/languages'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load languages');
  }

  Future<Map<String, dynamic>> getLessons(String language) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tutor/languages/$language/lessons'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load lessons');
  }

  Future<Map<String, dynamic>> getProgress(String language) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tutor/progress/$language'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load progress');
  }

  Future<Map<String, dynamic>> getAllProgress() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tutor/progress'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load progress');
  }

  Future<Map<String, dynamic>> startSession(String language, String? lessonId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tutor/sessions'),
      headers: _headers,
      body: jsonEncode({
        'language': language,
        if (lessonId != null) 'lessonId': lessonId,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to start session');
  }

  Future<Map<String, dynamic>> sendMessage(String sessionId, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tutor/sessions/$sessionId/messages'),
      headers: _headers,
      body: jsonEncode({'message': message}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to send message');
  }

  Future<Map<String, dynamic>> submitCode(
    String sessionId,
    String lessonId,
    String code,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tutor/sessions/$sessionId/submit'),
      headers: _headers,
      body: jsonEncode({
        'lessonId': lessonId,
        'code': code,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to submit code');
  }

  Future<void> completeLesson(String lessonId, int score) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tutor/lessons/$lessonId/complete'),
      headers: _headers,
      body: jsonEncode({'score': score}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to complete lesson');
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tutor/stats'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load stats');
  }
}
