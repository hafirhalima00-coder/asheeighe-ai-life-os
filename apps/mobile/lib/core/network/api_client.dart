import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app/app_config.dart';
import '../constants/api_constants.dart';
import 'api_exceptions.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
});

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiClient({
    required FlutterSecureStorage secureStorage,
    Dio? dio,
  }) : _secureStorage = secureStorage {
    _dio = dio ?? _createDio();
    _dio.interceptors.addAll([
      _AuthInterceptor(_secureStorage),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
      _RetryInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: {
          ApiConstants.contentType: ApiConstants.applicationJson,
          ApiConstants.acceptLanguage: 'en',
          ApiConstants.xAppVersion: AppConfig.appVersion,
          ApiConstants.xPlatform: 'mobile',
        },
      ),
    );
    return dio;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> upload<T>(
    String path, {
    required FormData data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      options: options ??
          Options(contentType: ApiConstants.multipartForm),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }
}

class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  _AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authorization] =
          '${ApiConstants.bearer}$token';
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _secureStorage.delete(key: 'auth_token');
    }
    handler.next(err);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final error = _handleDioException(err);
    handler.reject(error);
  }

  DioException _handleDioException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          requestOptions: err.requestOptions,
          message: 'Connection timed out. Please try again.',
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          requestOptions: err.requestOptions,
          message: 'No internet connection.',
        );
      case DioExceptionType.badResponse:
        return _handleStatusCode(err);
      case DioExceptionType.cancel:
        return CancelException(
          requestOptions: err.requestOptions,
          message: 'Request was cancelled.',
        );
      case DioExceptionType.badCertificate:
        return SecurityException(
          requestOptions: err.requestOptions,
          message: 'SSL certificate error.',
        );
      case DioExceptionType.unknown:
      default:
        return UnknownException(
          requestOptions: err.requestOptions,
          message: err.message ?? 'An unexpected error occurred.',
        );
    }
  }

  DioException _handleStatusCode(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    final message = data is Map ? data['message'] as String? : null;

    switch (statusCode) {
      case 400:
        return BadRequestException(
          requestOptions: err.requestOptions,
          message: message ?? 'Invalid request.',
          response: err.response,
        );
      case 401:
        return UnauthorizedException(
          requestOptions: err.requestOptions,
          message: message ?? 'Session expired. Please login again.',
          response: err.response,
        );
      case 403:
        return ForbiddenException(
          requestOptions: err.requestOptions,
          message: message ?? 'Access denied.',
          response: err.response,
        );
      case 404:
        return NotFoundException(
          requestOptions: err.requestOptions,
          message: message ?? 'Resource not found.',
          response: err.response,
        );
      case 409:
        return ConflictException(
          requestOptions: err.requestOptions,
          message: message ?? 'Resource conflict.',
          response: err.response,
        );
      case 422:
        return ValidationException(
          requestOptions: err.requestOptions,
          message: message ?? 'Validation failed.',
          response: err.response,
        );
      case 429:
        return RateLimitException(
          requestOptions: err.requestOptions,
          message: message ?? 'Too many requests. Please slow down.',
          response: err.response,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(
          requestOptions: err.requestOptions,
          message: message ?? 'Server error. Please try again later.',
          response: err.response,
        );
      default:
        return UnknownException(
          requestOptions: err.requestOptions,
          message: message ?? 'An unexpected error occurred.',
          response: err.response,
        );
    }
  }
}

class _RetryInterceptor extends Interceptor {
  final int _maxRetries;
  final Duration _retryDelay;

  _RetryInterceptor({
    int maxRetries = AppConfig.maxRetries,
    Duration retryDelay = AppConfig.retryDelay,
  })  : _maxRetries = maxRetries,
        _retryDelay = retryDelay;

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRetry(err)) {
      final retryCount =
          err.requestOptions.extra['retryCount'] as int? ?? 0;
      if (retryCount < _maxRetries) {
        await Future.delayed(_retryDelay * (retryCount + 1));
        err.requestOptions.extra['retryCount'] = retryCount + 1;
        try {
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          handler.next(e as DioException);
          return;
        }
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.type == DioExceptionType.badResponse &&
            err.response?.statusCode == 503);
  }
}
