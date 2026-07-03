import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _remoteDataSource.login(request);
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      final user = response.user.toEntity();
      await _localDataSource.saveUser(user);
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e, s) {
      AppLogger.e('Login failed', error: e, stackTrace: s);
      return Left(AuthFailure(message: 'Login failed. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(name: name, email: email, password: password);
      final response = await _remoteDataSource.register(request);
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      final user = response.user.toEntity();
      await _localDataSource.saveUser(user);
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e, s) {
      AppLogger.e('Register failed', error: e, stackTrace: s);
      return Left(AuthFailure(message: 'Registration failed. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
    } on DioException catch (e) {
      AppLogger.w('Remote logout failed, clearing local', error: e);
    } catch (e, s) {
      AppLogger.w('Logout error', error: e, stackTrace: s);
    }
    await _localDataSource.clearAll();
    return const Right(null);
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      final hasSession = await _localDataSource.hasSession();
      if (!hasSession) return const Right(null);

      final cachedUser = await _localDataSource.getUser();
      return Right(cachedUser);
    } catch (e, s) {
      AppLogger.e('getCurrentUser failed', error: e, stackTrace: s);
      return Left(CacheFailure(message: 'Failed to load cached user.'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> refreshToken() async {
    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null) {
        return Left(AuthFailure(message: 'No refresh token available.'));
      }
      final response = await _remoteDataSource.refreshToken(refreshToken);
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      final user = response.user.toEntity();
      await _localDataSource.saveUser(user);
      return Right(user);
    } on DioException catch (e) {
      await _localDataSource.clearAll();
      return Left(_handleDioError(e));
    } catch (e, s) {
      AppLogger.e('refreshToken failed', error: e, stackTrace: s);
      return Left(AuthFailure(message: 'Session expired. Please login again.'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordReset({
    required String email,
  }) async {
    try {
      await _remoteDataSource.sendPasswordReset(email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e, s) {
      AppLogger.e('sendPasswordReset failed', error: e, stackTrace: s);
      return Left(AuthFailure(message: 'Failed to send password reset email.'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    try {
      final response = await _remoteDataSource.signInWithGoogle('');
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      final user = response.user.toEntity();
      await _localDataSource.saveUser(user);
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e, s) {
      AppLogger.e('Google sign-in failed', error: e, stackTrace: s);
      return Left(AuthFailure(message: 'Google sign-in failed.'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithApple() async {
    try {
      final response = await _remoteDataSource.signInWithApple({});
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      final user = response.user.toEntity();
      await _localDataSource.saveUser(user);
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e, s) {
      AppLogger.e('Apple sign-in failed', error: e, stackTrace: s);
      return Left(AuthFailure(message: 'Apple sign-in failed.'));
    }
  }

  Failure _handleDioError(DioException e) {
    if (e is UnauthorizedException) {
      return AuthFailure(
        message: e.userMessage,
        statusCode: 401,
        error: e,
      );
    }
    if (e is ValidationException) {
      return ValidationFailure(message: e.userMessage, error: e);
    }
    if (e is NetworkException) {
      return NetworkFailure(message: e.userMessage, error: e);
    }
    if (e is ServerException) {
      return ServerFailure(message: e.userMessage, statusCode: e.response?.statusCode, error: e);
    }
    return AuthFailure(message: e.message ?? 'Authentication failed.', error: e);
  }
}
