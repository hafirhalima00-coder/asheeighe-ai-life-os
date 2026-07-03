import 'package:intl/intl.dart';

extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeAll {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  String get toTitleCase {
    if (isEmpty) return this;
    return replaceAll(RegExp(r'[_-]'), ' ')
        .split(' ')
        .map((word) => word.capitalize)
        .join(' ');
  }

  String get camelToSentence {
    if (isEmpty) return this;
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => ' ${match.group(0)}',
    ).trimLeft().capitalize;
  }

  String get initials {
    if (isEmpty) return '';
    return split(' ')
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();
  }

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  String truncateWords(int wordCount) {
    final words = split(' ');
    if (words.length <= wordCount) return this;
    return '${words.take(wordCount).join(' ')}...';
  }

  bool get isValidEmail {
    if (isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isValidPhone {
    if (isEmpty) return false;
    final phoneRegex = RegExp(r'^\+?[\d\s\-()]{7,15}$');
    return phoneRegex.hasMatch(this);
  }

  bool get isValidUrl {
    if (isEmpty) return false;
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-\.~:/?#\[\]@!$&()*+,;=]*)?$',
    );
    return urlRegex.hasMatch(this);
  }

  bool get isNumeric => double.tryParse(this) != null;

  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  bool get hasUppercase => contains(RegExp(r'[A-Z]'));

  bool get hasLowercase => contains(RegExp(r'[a-z]'));

  bool get hasDigit => contains(RegExp(r'\d'));

  bool get hasSpecialCharacter => contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  int get wordCount {
    if (trim().isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }

  int get characterCount => length;

  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  String get digitsOnly => replaceAll(RegExp(r'\D'), '');

  String get masked {
    if (isEmpty) return '';
    if (length <= 4) return this;
    return '*' * (length - 4) + substring(length - 4);
  }

  String toSlug({String delimiter = '-'}) {
    return toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s_]+'), delimiter)
        .replaceAll(RegExp(r'-+'), delimiter);
  }

  String get orEmpty => this;

  String orElse(String fallback) => isEmpty ? fallback : this;

  String pluralize(int count) {
    if (count == 1) return this;
    return '${this}s';
  }

  String formatWithParams(Map<String, String> params) {
    String result = this;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}

extension StringNullableExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  String orEmpty() => this ?? '';

  String orFallback(String fallback) => this ?? fallback;

  String get safeValue => this ?? '';
}
