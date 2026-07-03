import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/network/api_client.dart';

part 'auth_provider.g.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading }

class AuthState {
  final AuthUser? user;
  final AuthStatus status;

  const AuthState({this.user, this.status = AuthStatus.unknown});

  AuthState copyWith({AuthUser? user, AuthStatus? status}) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository _repository;

  @override
  FutureOr<AuthState> build() async {
    final secureStorage = ref.watch(secureStorageProvider);
    final hiveBox = await Hive.openBox('asheeighe_box');
    final apiClient = ref.watch(apiClientProvider);

    final localDataSource = AuthLocalDataSource(secureStorage, hiveBox);
    final remoteDataSource = AuthRemoteDataSource(apiClient);
    _repository = AuthRepositoryImpl(remoteDataSource, localDataSource);

    return _checkAuth();
  }

  Future<AuthState> _checkAuth() async {
    final result = await _repository.getCurrentUser();
    return result.fold(
      (_) => const AuthState(status: AuthStatus.unauthenticated),
      (user) {
        if (user != null) {
          return AuthState(user: user, status: AuthStatus.authenticated);
        }
        return const AuthState(status: AuthStatus.unauthenticated);
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    final result = await _repository.login(email: email, password: password);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (user) => state = AsyncValue.data(
        AuthState(user: user, status: AuthStatus.authenticated),
      ),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.register(
      name: name,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (user) => state = AsyncValue.data(
        AuthState(user: user, status: AuthStatus.authenticated),
      ),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await _repository.logout();
    state = const AsyncValue.data(AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> checkAuth() async {
    state = const AsyncValue.loading();
    final authState = await _checkAuth();
    state = AsyncValue.data(authState);
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    final result = await _repository.signInWithGoogle();
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (user) => state = AsyncValue.data(
        AuthState(user: user, status: AuthStatus.authenticated),
      ),
    );
  }

  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    final result = await _repository.signInWithApple();
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (user) => state = AsyncValue.data(
        AuthState(user: user, status: AuthStatus.authenticated),
      ),
    );
  }

  Future<void> sendPasswordReset(String email) async {
    final result = await _repository.sendPasswordReset(email: email);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state,
    );
  }
}
