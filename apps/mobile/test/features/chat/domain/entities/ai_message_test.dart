import 'package:flutter_test/flutter_test.dart';
import 'package:pinkz/features/chat/domain/entities/ai_message.dart';
import 'package:pinkz/features/chat/domain/entities/skill_result.dart';

void main() {
  group('MessageRole', () {
    test('should have correct enum values', () {
      expect(MessageRole.values, hasLength(3));
      expect(MessageRole.user.index, 0);
      expect(MessageRole.assistant.index, 1);
      expect(MessageRole.system.index, 2);
    });
  });

  group('SkillResult', () {
    test('should create with required fields', () {
      const skill = SkillResult(
        skillName: 'weather',
        action: 'get_forecast',
        success: true,
      );
      expect(skill.skillName, 'weather');
      expect(skill.action, 'get_forecast');
      expect(skill.success, true);
      expect(skill.data, isEmpty);
      expect(skill.error, isNull);
    });

    test('should support value equality', () {
      const s1 = SkillResult(skillName: 'a', action: 'b', success: true);
      const s2 = SkillResult(skillName: 'a', action: 'b', success: true);
      expect(s1, equals(s2));
    });

    test('props should contain all fields', () {
      const skill = SkillResult(skillName: 'a', action: 'b', success: true);
      expect(skill.props, ['a', 'b', true, {}, null]);
    });
  });

  group('AIMessage', () {
    final timestamp = DateTime(2024, 6, 15, 10, 0);
    final skill = SkillResult(skillName: 'weather', action: 'get', success: true);

    const baseMessage = AIMessage(
      id: 'msg1',
      role: MessageRole.assistant,
      content: 'Hello! How can I help?',
      timestamp: null,
    );

    test('should create with required fields', () {
      final message = AIMessage(
        id: 'msg1',
        role: MessageRole.user,
        content: 'Hi',
        timestamp: timestamp,
      );
      expect(message.id, 'msg1');
      expect(message.role, MessageRole.user);
      expect(message.content, 'Hi');
      expect(message.skills, isEmpty);
      expect(message.isLoading, false);
    });

    group('copyWith', () {
      test('should update content', () {
        final updated = baseMessage.copyWith(content: 'Updated');
        expect(updated.content, 'Updated');
      });

      test('should update role', () {
        final updated = baseMessage.copyWith(role: MessageRole.system);
        expect(updated.role, MessageRole.system);
      });

      test('should update skills', () {
        final updated = baseMessage.copyWith(skills: [skill]);
        expect(updated.skills.length, 1);
      });

      test('should update isLoading', () {
        final updated = baseMessage.copyWith(isLoading: true);
        expect(updated.isLoading, true);
      });
    });

    group('value equality', () {
      test('identical messages should be equal', () {
        final m1 = AIMessage(id: '1', role: MessageRole.user, content: 'Hi', timestamp: timestamp);
        final m2 = AIMessage(id: '1', role: MessageRole.user, content: 'Hi', timestamp: timestamp);
        expect(m1, equals(m2));
      });

      test('different ids should not be equal', () {
        final m1 = AIMessage(id: '1', role: MessageRole.user, content: 'Hi', timestamp: timestamp);
        final m2 = AIMessage(id: '2', role: MessageRole.user, content: 'Hi', timestamp: timestamp);
        expect(m1, isNot(equals(m2)));
      });
    });

    test('props should contain all fields', () {
      final message = AIMessage(
        id: '1',
        role: MessageRole.assistant,
        content: 'Hello',
        timestamp: timestamp,
        skills: [skill],
        isLoading: false,
      );
      expect(message.props, ['1', MessageRole.assistant, 'Hello', timestamp, [skill], false]);
    });
  });
}
