import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/features/auth/data/models/auth_user_model.dart';
import 'package:asheeighe/features/auth/domain/entities/auth_user.dart';

void main() {
  group('AuthUserModel', () {
    const testJson = {
      'id': '123',
      'email': 'test@example.com',
      'name': 'Test User',
      'avatarUrl': 'https://example.com/avatar.png',
      'isEmailVerified': true,
      'authProvider': 'google',
    };

    const testEntity = AuthUser(
      id: '123',
      email: 'test@example.com',
      name: 'Test User',
      avatarUrl: 'https://example.com/avatar.png',
      isEmailVerified: true,
      authProvider: 'google',
    );

    group('fromJson', () {
      test('should return correct model from JSON', () {
        final model = AuthUserModel.fromJson(testJson);
        expect(model.id, '123');
        expect(model.email, 'test@example.com');
        expect(model.name, 'Test User');
        expect(model.avatarUrl, 'https://example.com/avatar.png');
        expect(model.isEmailVerified, true);
        expect(model.authProvider, 'google');
      });

      test('should handle null optional fields', () {
        final json = <String, dynamic>{
          'id': '1',
          'email': 'a@b.com',
        };
        final model = AuthUserModel.fromJson(json);
        expect(model.name, isNull);
        expect(model.avatarUrl, isNull);
        expect(model.isEmailVerified, false);
        expect(model.authProvider, isNull);
      });
    });

    group('toJson', () {
      test('should return correct JSON', () {
        final model = AuthUserModel(
          id: '123',
          email: 'test@example.com',
          name: 'Test User',
          avatarUrl: 'https://example.com/avatar.png',
          isEmailVerified: true,
          authProvider: 'google',
        );
        expect(model.toJson(), testJson);
      });

      test('should handle null fields in JSON', () {
        final model = AuthUserModel(id: '1', email: 'a@b.com');
        final json = model.toJson();
        expect(json['name'], isNull);
        expect(json['avatarUrl'], isNull);
        expect(json['isEmailVerified'], false);
      });
    });

    group('toEntity', () {
      test('should convert to AuthUser entity', () {
        final model = AuthUserModel(
          id: '123',
          email: 'test@example.com',
          name: 'Test User',
          avatarUrl: 'https://example.com/avatar.png',
          isEmailVerified: true,
          authProvider: 'google',
        );
        final entity = model.toEntity();
        expect(entity.id, '123');
        expect(entity.email, 'test@example.com');
        expect(entity.name, 'Test User');
        expect(entity.avatarUrl, 'https://example.com/avatar.png');
        expect(entity.isEmailVerified, true);
        expect(entity.authProvider, 'google');
      });
    });

    group('fromEntity', () {
      test('should create model from entity', () {
        final model = AuthUserModel.fromEntity(testEntity);
        expect(model.id, '123');
        expect(model.email, 'test@example.com');
        expect(model.name, 'Test User');
        expect(model.isEmailVerified, true);
      });
    });

    group('JSON roundtrip', () {
      test('should preserve values through fromJson/toJson', () {
        final model = AuthUserModel.fromJson(testJson);
        final json = model.toJson();
        expect(json, testJson);
      });

      test('should preserve entity through fromEntity/toEntity', () {
        final model = AuthUserModel.fromEntity(testEntity);
        final entity = model.toEntity();
        expect(entity, equals(testEntity));
      });
    });
  });
}
