import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/features/auth/data/models/login_request.dart';

void main() {
  group('LoginRequest', () {
    const email = 'test@example.com';
    const password = 'Password123';

    group('constructor', () {
      test('should create instance with required fields', () {
        final request = LoginRequest(email: email, password: password);
        expect(request.email, email);
        expect(request.password, password);
      });
    });

    group('toJson', () {
      test('should return valid JSON map', () {
        final request = LoginRequest(email: email, password: password);
        final json = request.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['email'], email);
        expect(json['password'], password);
      });
    });

    group('fromJson', () {
      test('should create from JSON map', () {
        final json = <String, dynamic>{
          'email': email,
          'password': password,
        };
        final request = LoginRequest.fromJson(json);
        expect(request.email, email);
        expect(request.password, password);
      });
    });

    group('JSON roundtrip', () {
      test('should preserve values', () {
        final original = LoginRequest(email: email, password: password);
        final json = original.toJson();
        final restored = LoginRequest.fromJson(json);
        expect(restored.email, original.email);
        expect(restored.password, original.password);
      });
    });
  });
}
