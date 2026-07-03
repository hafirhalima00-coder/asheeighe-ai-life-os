import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  final dynamic error;

  const Failure({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  List<Object?> get props => [message, statusCode, error];
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred.',
    super.statusCode,
    super.error,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred.',
    super.error,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed.',
    super.statusCode,
    super.error,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection.',
    super.error,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out.',
    super.error,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Validation failed.',
    super.error,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found.',
    super.statusCode = 404,
    super.error,
  });
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Permission denied.',
    super.statusCode = 403,
    super.error,
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred.',
    super.error,
  });
}
