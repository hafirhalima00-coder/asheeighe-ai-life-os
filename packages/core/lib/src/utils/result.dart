import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(String message, {Object? error, StackTrace? stackTrace}) = Failure<T>;
}

extension ResultX<T> on Result<T> {
  T? get dataOrNull => switch (this) {
        Success(data: final d) => d,
        Failure() => null,
      };

  String? get errorOrNull => switch (this) {
        Success() => null,
        Failure(message: final m) => m,
      };

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T get dataOrThrow => switch (this) {
        Success(data: final d) => d,
        Failure(message: final m) => throw Exception(m),
      };

  R fold<R>(R Function(T) onSuccess, R Function(String) onFailure) =>
      switch (this) {
        Success(data: final d) => onSuccess(d),
        Failure(message: final m) => onFailure(m),
      };
}
