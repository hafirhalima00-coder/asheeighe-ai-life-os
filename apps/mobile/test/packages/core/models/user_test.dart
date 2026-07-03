import 'package:flutter_test/flutter_test.dart';
import 'package:pinkz/features/auth/domain/entities/auth_user.dart';

void main() {
  group('User', () {
    test('should create user with all fields', () {
      const user = AuthUser(
        id: 'u1',
        email: 'user@example.com',
        name: 'John Doe',
        avatarUrl: 'https://example.com/avatar.jpg',
        isEmailVerified: true,
        authProvider: 'google',
      );
      expect(user.id, 'u1');
      expect(user.email, 'user@example.com');
      expect(user.name, 'John Doe');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.isEmailVerified, true);
      expect(user.authProvider, 'google');
    });

    test('should create user with only required fields', () {
      const user = AuthUser(id: 'u1', email: 'a@b.com');
      expect(user.name, isNull);
      expect(user.avatarUrl, isNull);
      expect(user.isEmailVerified, false);
    });

    group('copyWith', () {
      test('should update single field', () {
        const user = AuthUser(id: '1', email: 'a@b.com');
        final updated = user.copyWith(name: 'New Name');
        expect(updated.name, 'New Name');
        expect(updated.email, 'a@b.com');
      });

      test('should update multiple fields', () {
        const user = AuthUser(id: '1', email: 'a@b.com');
        final updated = user.copyWith(
          email: 'new@b.com',
          isEmailVerified: true,
        );
        expect(updated.email, 'new@b.com');
        expect(updated.isEmailVerified, true);
      });
    });

    group('equality', () {
      test('same values should be equal', () {
        const user1 = AuthUser(id: '1', email: 'a@b.com');
        const user2 = AuthUser(id: '1', email: 'a@b.com');
        expect(user1, equals(user2));
      });

      test('different ids should not be equal', () {
        const user1 = AuthUser(id: '1', email: 'a@b.com');
        const user2 = AuthUser(id: '2', email: 'a@b.com');
        expect(user1, isNot(equals(user2)));
      });
    });

    test('hashCode should be based on id and email', () {
      const user1 = AuthUser(id: '1', email: 'a@b.com');
      const user2 = AuthUser(id: '1', email: 'a@b.com');
      expect(user1.hashCode, user2.hashCode);
    });
  });
}
