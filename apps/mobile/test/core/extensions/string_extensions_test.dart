import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/core/extensions/string_extensions.dart';

void main() {
  group('StringExtensions', () {
    group('capitalize', () {
      test('should capitalize first letter', () {
        expect('hello'.capitalize, 'Hello');
      });

      test('should handle empty string', () {
        expect(''.capitalize, '');
      });

      test('should not change already capitalized', () {
        expect('Hello'.capitalize, 'Hello');
      });
    });

    group('capitalizeAll', () {
      test('should capitalize each word', () {
        expect('hello world'.capitalizeAll, 'Hello World');
      });

      test('should handle empty string', () {
        expect(''.capitalizeAll, '');
      });

      test('should handle single word', () {
        expect('hello'.capitalizeAll, 'Hello');
      });
    });

    group('toTitleCase', () {
      test('should replace underscores and hyphens', () {
        expect('hello_world'.toTitleCase, 'Hello World');
        expect('hello-world'.toTitleCase, 'Hello World');
      });

      test('should handle empty string', () {
        expect(''.toTitleCase, '');
      });
    });

    group('camelToSentence', () {
      test('should convert camelCase to sentence', () {
        expect('helloWorld'.camelToSentence, 'Hello world');
      });

      test('should handle empty string', () {
        expect(''.camelToSentence, '');
      });
    });

    group('initials', () {
      test('should return up to 2 initials', () {
        expect('John Doe'.initials, 'JD');
      });

      test('should handle single word', () {
        expect('John'.initials, 'J');
      });

      test('should handle empty string', () {
        expect(''.initials, '');
      });
    });

    group('truncate', () {
      test('should truncate with ellipsis', () {
        expect('Hello World'.truncate(5), 'Hello...');
      });

      test('should not truncate short strings', () {
        expect('Hi'.truncate(5), 'Hi');
      });
    });

    group('truncateWords', () {
      test('should truncate words with ellipsis', () {
        expect('one two three four'.truncateWords(2), 'one two...');
      });

      test('should not truncate if within word count', () {
        expect('one two'.truncateWords(5), 'one two');
      });
    });

    group('isValidEmail', () {
      test('should return true for valid email', () {
        expect('test@example.com'.isValidEmail, true);
      });

      test('should return false for invalid email', () {
        expect('not-email'.isValidEmail, false);
      });

      test('should return false for empty string', () {
        expect(''.isValidEmail, false);
      });
    });

    group('isValidPhone', () {
      test('should return true for valid phone', () {
        expect('+1234567890'.isValidPhone, true);
      });

      test('should return false for invalid phone', () {
        expect('abc'.isValidPhone, false);
      });

      test('should return false for empty string', () {
        expect(''.isValidPhone, false);
      });
    });

    group('isValidUrl', () {
      test('should return true for valid URL', () {
        expect('https://example.com'.isValidUrl, true);
      });

      test('should return false for invalid URL', () {
        expect('not-a-url'.isValidUrl, false);
      });
    });

    group('isNumeric', () {
      test('should return true for numeric strings', () {
        expect('123'.isNumeric, true);
        expect('3.14'.isNumeric, true);
      });

      test('should return false for non-numeric', () {
        expect('abc'.isNumeric, false);
      });
    });

    group('isAlphanumeric', () {
      test('should return true for alphanumeric', () {
        expect('abc123'.isAlphanumeric, true);
      });

      test('should return false for non-alphanumeric', () {
        expect('abc 123'.isAlphanumeric, false);
      });
    });

    group('hasUppercase / hasLowercase / hasDigit / hasSpecialCharacter', () {
      test('hasUppercase should detect uppercase', () {
        expect('Hello'.hasUppercase, true);
        expect('hello'.hasUppercase, false);
      });

      test('hasLowercase should detect lowercase', () {
        expect('Hello'.hasLowercase, true);
        expect('HELLO'.hasLowercase, false);
      });

      test('hasDigit should detect digits', () {
        expect('Hello1'.hasDigit, true);
        expect('Hello'.hasDigit, false);
      });

      test('hasSpecialCharacter should detect special chars', () {
        expect('Hello!'.hasSpecialCharacter, true);
        expect('Hello'.hasSpecialCharacter, false);
      });
    });

    group('wordCount', () {
      test('should count words', () {
        expect('hello world'.wordCount, 2);
      });

      test('should return 0 for empty', () {
        expect(''.wordCount, 0);
      });
    });

    group('characterCount', () {
      test('should return length', () {
        expect('hello'.characterCount, 5);
      });
    });

    group('removeWhitespace', () {
      test('should remove all whitespace', () {
        expect('h e l l o'.removeWhitespace, 'hello');
      });
    });

    group('digitsOnly', () {
      test('should extract only digits', () {
        expect('abc123def456'.digitsOnly, '123456');
      });
    });

    group('masked', () {
      test('should mask all but last 4 chars', () {
        expect('1234567890'.masked, '******7890');
      });

      test('should not mask short strings', () {
        expect('abcd'.masked, 'abcd');
      });

      test('should handle empty string', () => expect(''.masked, ''));
    });

    group('toSlug', () {
      test('should convert to slug', () {
        expect('Hello World'.toSlug(), 'hello-world');
      });

      test('should use custom delimiter', () {
        expect('Hello World'.toSlug(delimiter: '_'), 'hello_world');
      });
    });

    group('orEmpty / orElse', () {
      test('orEmpty should return itself', () {
        expect('hello'.orEmpty, 'hello');
      });

      test('orElse should return fallback for empty', () {
        expect(''.orElse('fallback'), 'fallback');
      });

      test('orElse should return itself for non-empty', () {
        expect('hello'.orElse('fallback'), 'hello');
      });
    });

    group('pluralize', () {
      test('should return singular for count 1', () {
        expect('item'.pluralize(1), 'item');
      });

      test('should return plural for count != 1', () {
        expect('item'.pluralize(2), 'items');
        expect('item'.pluralize(0), 'items');
      });
    });

    group('formatWithParams', () {
      test('should replace params in string', () {
        final result = 'Hello {name}'.formatWithParams({'name': 'John'});
        expect(result, 'Hello John');
      });
    });
  });

  group('StringNullableExtensions', () {
    test('isNullOrEmpty should return true for null', () {
      const String? s = null;
      expect(s.isNullOrEmpty, true);
    });

    test('isNullOrEmpty should return true for empty', () {
      const String? s = '';
      expect(s.isNullOrEmpty, true);
    });

    test('isNotNullOrEmpty should return true for non-null non-empty', () {
      const String? s = 'hello';
      expect(s.isNotNullOrEmpty, true);
    });

    test('orEmpty should return empty for null', () {
      const String? s = null;
      expect(s.orEmpty(), '');
    });

    test('orFallback should return fallback for null', () {
      const String? s = null;
      expect(s.orFallback('fb'), 'fb');
    });

    test('safeValue should return empty for null', () {
      const String? s = null;
      expect(s.safeValue, '');
    });

    test('safeValue should return value for non-null', () {
      const String? s = 'hello';
      expect(s.safeValue, 'hello');
    });
  });
}
