import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/features/composio/domain/entities/composio_integration.dart';
import 'package:asheeighe/features/composio/domain/entities/connected_account.dart';

void main() {
  group('ComposioIntegration', () {
    test('should create with required fields', () {
      const integration = ComposioIntegration(
        id: 'int1',
        name: 'Google Calendar',
        description: 'Sync your Google Calendar events',
        category: 'calendar',
      );
      expect(integration.id, 'int1');
      expect(integration.name, 'Google Calendar');
      expect(integration.description, 'Sync your Google Calendar events');
      expect(integration.category, 'calendar');
      expect(integration.isConnected, false);
      expect(integration.logo, isNull);
      expect(integration.connectedAt, isNull);
      expect(integration.authType, 'oauth2');
    });

    group('copyWith', () {
      test('should update name', () {
        const integration = ComposioIntegration(
          id: '1',
          name: 'Old Name',
          description: 'Desc',
          category: 'cat',
        );
        final updated = integration.copyWith(name: 'New Name');
        expect(updated.name, 'New Name');
        expect(updated.id, '1');
      });

      test('should update isConnected and connectedAt', () {
        const integration = ComposioIntegration(
          id: '1',
          name: 'Test',
          description: 'Desc',
          category: 'cat',
        );
        final now = DateTime(2024, 6, 15);
        final updated = integration.copyWith(
          isConnected: true,
          connectedAt: now,
        );
        expect(updated.isConnected, true);
        expect(updated.connectedAt, now);
      });

      test('should update authType', () {
        const integration = ComposioIntegration(
          id: '1',
          name: 'Test',
          description: 'Desc',
          category: 'cat',
        );
        final updated = integration.copyWith(authType: 'api_key');
        expect(updated.authType, 'api_key');
      });

      test('should update logo', () {
        const integration = ComposioIntegration(
          id: '1',
          name: 'Test',
          description: 'Desc',
          category: 'cat',
        );
        final updated = integration.copyWith(logo: 'https://logo.url');
        expect(updated.logo, 'https://logo.url');
      });

      test('should preserve unset fields', () {
        const integration = ComposioIntegration(
          id: '1',
          name: 'Test',
          description: 'Desc',
          category: 'cat',
        );
        final updated = integration.copyWith(name: 'Updated');
        expect(updated.description, 'Desc');
        expect(updated.category, 'cat');
      });
    });

    test('equals should use referential identity', () {
      const i1 = ComposioIntegration(id: '1', name: 'A', description: 'D', category: 'C');
      const i2 = ComposioIntegration(id: '1', name: 'A', description: 'D', category: 'C');
      // This is not Equatable, so equality is identity-based
      expect(i1 == i2, false);
    });
  });

  group('ConnectedAccount', () {
    test('should create with required fields', () {
      final account = ConnectedAccount(
        id: 'acct1',
        integrationId: 'int1',
        integrationName: 'Google Calendar',
      );
      expect(account.id, 'acct1');
      expect(account.integrationId, 'int1');
      expect(account.integrationName, 'Google Calendar');
      expect(account.status, 'active');
    });

    group('isActive', () {
      test('should return true when status is active', () {
        final account = ConnectedAccount(
          id: '1',
          integrationId: 'i1',
          integrationName: 'Test',
          status: 'active',
        );
        expect(account.isActive, true);
      });

      test('should return false when status is not active', () {
        final account = ConnectedAccount(
          id: '1',
          integrationId: 'i1',
          integrationName: 'Test',
          status: 'expired',
        );
        expect(account.isActive, false);
      });
    });

    group('isExpired', () {
      test('should return true when expiresAt is past', () {
        final account = ConnectedAccount(
          id: '1',
          integrationId: 'i1',
          integrationName: 'Test',
          expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(account.isExpired, true);
      });

      test('should return false when expiresAt is null', () {
        final account = ConnectedAccount(
          id: '1',
          integrationId: 'i1',
          integrationName: 'Test',
        );
        expect(account.isExpired, false);
      });

      test('should return false when expiresAt is future', () {
        final account = ConnectedAccount(
          id: '1',
          integrationId: 'i1',
          integrationName: 'Test',
          expiresAt: DateTime.now().add(const Duration(days: 1)),
        );
        expect(account.isExpired, false);
      });
    });

    group('copyWith', () {
      test('should update fields', () {
        final account = ConnectedAccount(
          id: '1',
          integrationId: 'i1',
          integrationName: 'Test',
        );
        final updated = account.copyWith(status: 'disconnected');
        expect(updated.status, 'disconnected');
      });
    });
  });
}
