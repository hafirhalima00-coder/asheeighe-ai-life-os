import 'package:flutter_test/flutter_test.dart';
import 'package:pinkz/core/utils/validators.dart';

void main() {
  group('FormValidators', () {
    group('validateEmail', () {
      test('should return Valid for valid email', () {
        final result = FormValidators.validateEmail('test@example.com');
        expect(result, isA<Valid>());
      });

      test('should return Invalid for null', () {
        final result = FormValidators.validateEmail(null);
        expect(result, isA<Invalid>());
        expect((result as Invalid).message, 'Email is required');
      });

      test('should return Invalid for empty string', () {
        final result = FormValidators.validateEmail('');
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for invalid email', () {
        final result = FormValidators.validateEmail('not-email');
        expect(result, isA<Invalid>());
      });

      test('should trim whitespace', () {
        final result = FormValidators.validateEmail(' test@example.com ');
        expect(result, isA<Valid>());
      });
    });

    group('validatePassword', () {
      test('should return Valid for strong password', () {
        final result = FormValidators.validatePassword('Abcdef1!');
        expect(result, isA<Valid>());
      });

      test('should return Invalid for null', () {
        final result = FormValidators.validatePassword(null);
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for short password', () {
        final result = FormValidators.validatePassword('Ab1!');
        expect(result, isA<Invalid>());
        expect((result as Invalid).message, 'Password must be at least 8 characters');
      });

      test('should return Invalid for missing uppercase', () {
        final result = FormValidators.validatePassword('abcdef1!');
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for missing lowercase', () {
        final result = FormValidators.validatePassword('ABCDEF1!');
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for missing digit', () => () {
        final result = FormValidators.validatePassword('Abcdefgh!');
        expect(result, isA<Invalid>());
      }());
    });

    group('validateConfirmPassword', () {
      test('should return Valid for matching passwords', () {
        final result = FormValidators.validateConfirmPassword('pass123', 'pass123');
        expect(result, isA<Valid>());
      });

      test('should return Invalid for null', () {
        final result = FormValidators.validateConfirmPassword(null, 'pass');
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for mismatch', () {
        final result = FormValidators.validateConfirmPassword('abc', 'def');
        expect(result, isA<Invalid>());
        expect((result as Invalid).message, 'Passwords do not match');
      });
    });

    group('validateRequired', () {
      test('should return Valid for non-empty value', () {
        final result = FormValidators.validateRequired('hello');
        expect(result, isA<Valid>());
      });

      test('should return Invalid for null', () {
        final result = FormValidators.validateRequired(null);
        expect(result, isA<Invalid>());
        expect((result as Invalid).message, 'This field is required');
      });

      test('should return Invalid for empty trimmed', () {
        final result = FormValidators.validateRequired('   ');
        expect(result, isA<Invalid>());
      });

      test('should use custom field name', () {
        final result = FormValidators.validateRequired(null, 'Email');
        expect((result as Invalid).message, 'Email is required');
      });
    });

    group('validateName', () {
      test('should return Valid for valid name', () {
        final result = FormValidators.validateName('John Doe');
        expect(result, isA<Valid>());
      });

      test('should return Invalid for null', () {
        final result = FormValidators.validateName(null);
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for too short', () {
        final result = FormValidators.validateName('A');
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for too long', () {
        final result = FormValidators.validateName('A' * 51);
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for special characters', () {
        final result = FormValidators.validateName('John123');
        expect(result, isA<Invalid>());
      });
    });

    group('validatePhone', () {
      test('should return Valid for valid phone', () {
        final result = FormValidators.validatePhone('+1234567890');
        expect(result, isA<Valid>());
      });

      test('should return Invalid for null', () {
        final result = FormValidators.validatePhone(null);
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for too short', () {
        final result = FormValidators.validatePhone('123');
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for non-digit chars', () {
        final result = FormValidators.validatePhone('abc123');
        expect(result, isA<Invalid>());
      });
    });

    group('validateUrl', () {
      test('should return Valid for valid URL', () {
        final result = FormValidators.validateUrl('https://example.com');
        expect(result, isA<Valid>());
      });

      test('should return Invalid for null', () {
        final result = FormValidators.validateUrl(null);
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for invalid URL', () {
        final result = FormValidators.validateUrl('not-a-url');
        expect(result, isA<Invalid>());
      });
    });

    group('validateMinLength', () {
      test('should return Valid for sufficient length', () {
        final result = FormValidators.validateMinLength('hello', 3);
        expect(result, isA<Valid>());
      });

      test('should return Invalid for insufficient length', () {
        final result = FormValidators.validateMinLength('ab', 3);
        expect(result, isA<Invalid>());
      });
    });

    group('validateMaxLength', () {
      test('should return Valid for within limit', () {
        final result = FormValidators.validateMaxLength('hello', 10);
        expect(result, isA<Valid>());
      });

      test('should return Invalid for exceeded limit', () {
        final result = FormValidators.validateMaxLength('hello world', 5);
        expect(result, isA<Invalid>());
      });
    });

    group('validateNumber', () {
      test('should return Valid for valid number', () {
        final result = FormValidators.validateNumber('42');
        expect(result, isA<Valid>());
      });

      test('should return Invalid for null', () {
        final result = FormValidators.validateNumber(null);
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for non-numeric', () {
        final result = FormValidators.validateNumber('abc');
        expect(result, isA<Invalid>());
      });
    });

    group('validatePositiveNumber', () {
      test('should return Valid for positive', () {
        final result = FormValidators.validatePositiveNumber('10');
        expect(result, isA<Valid>());
      });

      test('should return Invalid for zero', () {
        final result = FormValidators.validatePositiveNumber('0');
        expect(result, isA<Invalid>());
      });

      test('should return Invalid for negative', () {
        final result = FormValidators.validatePositiveNumber('-5');
        expect(result, isA<Invalid>());
      });
    });

    group('form-style validators', () {
      test('email() should return null for valid', () {
        final validator = FormValidators.email();
        expect(validator, isNotNull);
        expect(validator!('test@example.com'), isNull);
      });

      test('email() should return message for invalid', () {
        final validator = FormValidators.email();
        expect(validator!('bad'), isNotNull);
      });

      test('password() should return null for valid', () {
        final validator = FormValidators.password();
        expect(validator!('Password1'), isNull);
      });

      test('required() should return null for non-empty', () {
        final validator = FormValidators.required();
        expect(validator!('hello'), isNull);
      });

      test('required() should return message for empty', () {
        final validator = FormValidators.required();
        expect(validator!(''), isNotNull);
      });

      test('name() should return null for valid', () {
        final validator = FormValidators.name();
        expect(validator!('John'), isNull);
      });

      test('phone() should return null for valid', () {
        final validator = FormValidators.phone();
        expect(validator!('+1234567890'), isNull);
      });
    });
  });

  group('InputFormatters', () {
    test('phoneFormatter should allow digits', () {
      expect(InputFormatters.phoneFormatter, isNotNull);
    });

    test('digitsOnly should allow only digits', () {
      expect(InputFormatters.digitsOnly, isNotNull);
    });

    test('alphanumeric should allow letters and digits', () {
      expect(InputFormatters.alphanumeric, isNotNull);
    });

    test('noSpaces should deny spaces', () {
      expect(InputFormatters.noSpaces, isNotNull);
    });

    test('maxLength should return formatter with given max', () {
      final formatter = InputFormatters.maxLength(10);
      expect(formatter, isNotNull);
    });
  });
}
