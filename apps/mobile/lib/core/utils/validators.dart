import 'package:flutter/services.dart';

sealed class ValidationResult {
  const ValidationResult();
}

class Valid extends ValidationResult {
  const Valid();
}

class Invalid extends ValidationResult {
  final String message;
  const Invalid(this.message);
}

class FormValidators {
  const FormValidators._();

  static ValidationResult validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const Invalid('Email is required');
    }
    final email = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      return const Invalid('Please enter a valid email address');
    }
    return const Valid();
  }

  static ValidationResult validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return const Invalid('Password is required');
    }
    if (value.length < 8) {
      return const Invalid('Password must be at least 8 characters');
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return const Invalid('Password must contain an uppercase letter');
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return const Invalid('Password must contain a lowercase letter');
    }
    if (!value.contains(RegExp(r'\d'))) {
      return const Invalid('Password must contain a number');
    }
    return const Valid();
  }

  static ValidationResult validateConfirmPassword(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return const Invalid('Please confirm your password');
    }
    if (value != password) {
      return const Invalid('Passwords do not match');
    }
    return const Valid();
  }

  static ValidationResult validateRequired(String? value, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return Invalid('$field is required');
    }
    return const Valid();
  }

  static ValidationResult validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const Invalid('Name is required');
    }
    if (value.trim().length < 2) {
      return const Invalid('Name must be at least 2 characters');
    }
    if (value.trim().length > 50) {
      return const Invalid('Name must be at most 50 characters');
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return const Invalid('Name can only contain letters and spaces');
    }
    return const Valid();
  }

  static ValidationResult validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const Invalid('Phone number is required');
    }
    final phone = value.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (phone.length < 7 || phone.length > 15) {
      return const Invalid('Please enter a valid phone number');
    }
    if (!RegExp(r'^\+?\d+$').hasMatch(phone)) {
      return const Invalid('Phone number can only contain digits');
    }
    return const Valid();
  }

  static ValidationResult validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const Invalid('URL is required');
    }
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-\.~:/?#\[\]@!$&()*+,;=]*)?$',
    );
    if (!urlRegex.hasMatch(value.trim())) {
      return const Invalid('Please enter a valid URL');
    }
    return const Valid();
  }

  static ValidationResult validateMinLength(String? value, int minLength, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return Invalid('$field is required');
    }
    if (value.trim().length < minLength) {
      return Invalid('$field must be at least $minLength characters');
    }
    return const Valid();
  }

  static ValidationResult validateMaxLength(String? value, int maxLength, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return const Valid();
    }
    if (value.trim().length > maxLength) {
      return Invalid('$field must be at most $maxLength characters');
    }
    return const Valid();
  }

  static ValidationResult validateNumber(String? value, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return Invalid('$field is required');
    }
    if (double.tryParse(value.trim()) == null) {
      return Invalid('$field must be a valid number');
    }
    return const Valid();
  }

  static ValidationResult validatePositiveNumber(String? value, [String field = 'This field']) {
    final result = validateNumber(value, field);
    if (result is Invalid) return result;
    if (double.tryParse(value!.trim())! <= 0) {
      return Invalid('$field must be a positive number');
    }
    return const Valid();
  }

  static String? Function(String?)? email() => (value) {
        final result = validateEmail(value);
        return result is Invalid ? result.message : null;
      };

  static String? Function(String?)? password() => (value) {
        final result = validatePassword(value);
        return result is Invalid ? result.message : null;
      };

  static String? Function(String?)? required([String field = 'This field']) =>
      (value) {
        final result = validateRequired(value, field);
        return result is Invalid ? result.message : null;
      };

  static String? Function(String?)? name() => (value) {
        final result = validateName(value);
        return result is Invalid ? result.message : null;
      };

  static String? Function(String?)? phone() => (value) {
        final result = validatePhone(value);
        return result is Invalid ? result.message : null;
      };
}

class InputFormatters {
  const InputFormatters._();

  static final FilteringTextInputFormatter phoneFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'^\+?[\d\s\-()]*$'));

  static final FilteringTextInputFormatter digitsOnly =
      FilteringTextInputFormatter.digitsOnly;

  static final FilteringTextInputFormatter alphanumeric =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'));

  static final FilteringTextInputFormatter noSpaces =
      FilteringTextInputFormatter.deny(RegExp(r'\s'));

  static TextInputFormatter maxLength(int max) =>
      LengthLimitingTextInputFormatter(max);
}
