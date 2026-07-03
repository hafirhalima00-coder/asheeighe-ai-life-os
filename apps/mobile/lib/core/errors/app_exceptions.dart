class AppException implements Exception {
  final String message;
  final int? code;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppException: $message (code: $code)';
  }
}

class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication error',
    super.code,
    super.stackTrace,
  });
}

class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({
    super.message = 'Validation error',
    super.code,
    this.fieldErrors,
    super.stackTrace,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Network error',
    super.code,
    super.stackTrace,
  });
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error',
    super.code,
    super.stackTrace,
  });
}

class StorageException extends AppException {
  const StorageException({
    super.message = 'Storage error',
    super.code,
    super.stackTrace,
  });
}

class PermissionException extends AppException {
  const PermissionException({
    super.message = 'Permission denied',
    super.code,
    super.stackTrace,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Operation timed out',
    super.code,
    super.stackTrace,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.code = 404,
    super.stackTrace,
  });
}

class BadRequestException extends AppException {
  const BadRequestException({
    super.message = 'Bad request',
    super.code = 400,
    super.stackTrace,
  });
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Internal server error',
    super.code = 500,
    super.stackTrace,
  });
}
