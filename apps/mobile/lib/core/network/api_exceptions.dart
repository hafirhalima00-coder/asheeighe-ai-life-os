import 'package:dio/dio.dart';

class ApiException extends DioException {
  final String userMessage;

  ApiException({
    required super.requestOptions,
    required this.userMessage,
    super.message,
    super.response,
    super.type = DioExceptionType.unknown,
    super.error,
  });

  @override
  String toString() {
    return '$runtimeType: $userMessage (${message ?? "no details"})';
  }
}

class TimeoutException extends ApiException {
  TimeoutException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.connectionTimeout,
  }) : super(userMessage: message ?? 'Connection timed out.');
}

class NetworkException extends ApiException {
  NetworkException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.connectionError,
  }) : super(userMessage: message ?? 'No internet connection.');
}

class BadRequestException extends ApiException {
  BadRequestException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.badResponse,
  }) : super(userMessage: message ?? 'Invalid request.');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.badResponse,
  }) : super(userMessage: message ?? 'Session expired.');
}

class ForbiddenException extends ApiException {
  ForbiddenException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.badResponse,
  }) : super(userMessage: message ?? 'Access denied.');
}

class NotFoundException extends ApiException {
  NotFoundException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.badResponse,
  }) : super(userMessage: message ?? 'Resource not found.');
}

class ConflictException extends ApiException {
  ConflictException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.badResponse,
  }) : super(userMessage: message ?? 'Resource conflict.');
}

class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;

  ValidationException({
    required super.requestOptions,
    super.message,
    this.errors,
    super.response,
    super.type = DioExceptionType.badResponse,
  }) : super(userMessage: message ?? 'Validation failed.');
}

class RateLimitException extends ApiException {
  RateLimitException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.badResponse,
  }) : super(userMessage: message ?? 'Too many requests.');
}

class ServerException extends ApiException {
  ServerException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.badResponse,
  }) : super(userMessage: message ?? 'Server error.');
}

class CancelException extends ApiException {
  CancelException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.cancel,
  }) : super(userMessage: message ?? 'Request cancelled.');
}

class SecurityException extends ApiException {
  SecurityException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.badCertificate,
  }) : super(userMessage: message ?? 'SSL certificate error.');
}

class UnknownException extends ApiException {
  UnknownException({
    required super.requestOptions,
    super.message,
    super.response,
    super.type = DioExceptionType.unknown,
  }) : super(userMessage: message ?? 'An unexpected error occurred.');
}
