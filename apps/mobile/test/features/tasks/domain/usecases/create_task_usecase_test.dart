import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinkz/core/errors/failures.dart';
import 'package:pinkz/features/tasks/domain/entities/task.dart';
import 'package:pinkz/features/tasks/domain/repositories/task_repository.dart';
import 'package:pinkz/features/tasks/domain/usecases/create_task_usecase.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late CreateTaskUseCase useCase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = CreateTaskUseCase(mockRepository);
  });

  final now = DateTime(2024, 6, 15);
  final testTask = Task(
    id: 'task1',
    title: 'Buy groceries',
    createdAt: now,
    updatedAt: now,
  );

  group('CreateTaskUseCase', () {
    test('should call repository.createTask with correct task', () async {
      when(() => mockRepository.createTask(any()))
          .thenAnswer((_) async => Right(testTask));

      final result = await useCase(testTask);

      verify(() => mockRepository.createTask(testTask)).called(1);
      expect(result, equals(Right(testTask)));
    });

    test('should return created task with id', () async {
      final createdTask = testTask.copyWith(id: 'new-id');
      when(() => mockRepository.createTask(any()))
          .thenAnswer((_) async => Right(createdTask));

      final result = await useCase(testTask);
      expect((result as Right).value.id, 'new-id');
    });

    test('should return ServerFailure on repository error', () async {
      const failure = ServerFailure(message: 'Database error');
      when(() => mockRepository.createTask(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(testTask);
      expect(result, equals(const Left(failure)));
    });

    test('should return ValidationFailure for invalid task', () async {
      const failure = ValidationFailure(message: 'Title required');
      when(() => mockRepository.createTask(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(testTask);
      expect(result, equals(const Left(failure)));
    });
  });
}
