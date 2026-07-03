import 'package:flutter_test/flutter_test.dart';
import 'package:pinkz/features/auth/data/models/register_request.dart';

void main() {
  group('RegisterRequest', () {
    const name = 'Test User';
    const email = 'test@example.com';
    const password = 'Password123';

    group('constructor', () {
      test('should create instance with required fields', () {
        final request = RegisterRequest(
          name: name,
          email: email,
          password: password,
        );
        expect(request.name, name);
        expect(request.email, email);
        expect(request.password, password);
      });
    });

    group('toJson', () {
      test('should return valid JSON map', () {
        final request = RegisterRequest(
          name: name,
          email: email,
          password: password,
        );
        final json = request.toJson();
        expect(json['name'], name);
        expect(json['email'], email);
        expect(json['password'], password);
      });
    });

    group('fromJson', () {
      test('should create from JSON map', () {
        final json = <String, dynamic>{
          'name': name,
          'email': email,
          'password': password,
        };
        final request = RegisterRequest.fromJson(json);
        expect(request.name, name);
        expect(request.email, email);
        expect(request.password, password);
      });
    });

    group('JSON roundtrip', () {
      test('should preserve values', () {
        final original = RegisterRequest(
          name: name,
          email: email,
          password: password,
        );
        final json = original.toJson();
        final restored = RegisterRequest.fromJson(json);
        expect(restored.name, original.name);
        expect(restored.email, original.email);
        expect(restored.password, original.password);
      });
    });
  });
}
