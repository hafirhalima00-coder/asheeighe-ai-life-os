import 'package:flutter_test/flutter_test.dart';
import 'package:pinkz/features/auth/domain/entities/auth_user.dart';

void main() {
  group('AuthUser', () {
    const authUser = AuthUser(
      id: '123',
      email: 'test@example.com',
      name: 'Test User',
      avatarUrl: 'https://example.com/avatar.png',
      isEmailVerified: true,
      authProvider: 'google',
    );

    test('should create AuthUser with required fields', () {
      const user = AuthUser(id: '1', email: 'a@b.com');
      expect(user.id, '1');
      expect(user.email, 'a@b.com');
      expect(user.name, isNull);
      expect(user.avatarUrl, isNull);
      expect(user.isEmailVerified, false);
      expect(user.authProvider, isNull);
    });

    test('should support value equality', () {
      const user1 = AuthUser(id: '1', email: 'a@b.com');
      const user2 = AuthUser(id: '1', email: 'a@b.com');
      const user3 = AuthUser(id: '2', email: 'a@b.com');

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });

    test('hashCode should match equality', () {
      const user1 = AuthUser(id: '1', email: 'a@b.com');
      const user2 = AuthUser(id: '1', email: 'a@b.com');
      expect(user1.hashCode, equals(user2.hashCode));
    });

    group('copyWith', () {
      test('should return same instance when no args', () {
        final copied = authUser.copyWith();
        expect(copied, equals(authUser));
      });

      test('should update name', () {
        final copied = authUser.copyWith(name: 'New Name');
        expect(copied.name, 'New Name');
        expect(copied.email, authUser.email);
      });

      test('should update email', () {
        final copied = authUser.copyWith(email: 'new@example.com');
        expect(copied.email, 'new@example.com');
        expect(copied.id, authUser.id);
      });

      test('should update isEmailVerified', () {
        final copied = authUser.copyWith(isEmailVerified: false);
        expect(copied.isEmailVerified, false);
      });

      test('should update avatarUrl', () {
        final copied = authUser.copyWith(avatarUrl: null);
        expect(copied.avatarUrl, null);
      });

      test('should update authProvider', () {
        final copied = authUser.copyWith(authProvider: 'apple');
        expect(copied.authProvider, 'apple');
      });
    });

    test('should set default values', () {
      const user = AuthUser(id: '1', email: 'a@b.com');
      expect(user.isEmailVerified, false);
      expect(user.name, isNull);
      expect(user.avatarUrl, isNull);
      expect(user.authProvider, isNull);
    });

    test('should accept all named parameters', () {
      expect(authUser.id, '123');
      expect(authUser.email, 'test@example.com');
      expect(authUser.name, 'Test User');
      expect(authUser.avatarUrl, 'https://example.com/avatar.png');
      expect(authUser.isEmailVerified, true);
      expect(authUser.authProvider, 'google');
    });
  });
}
