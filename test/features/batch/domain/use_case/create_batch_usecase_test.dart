import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/entity/batch_entity.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/use_case/create_batch_usecase.dart';

import 'repository.mock.dart';

void main() {
  late MockBatchRepository repository;
  late CreateBatchUseCase usecase;

  setUp(() {
    repository = MockBatchRepository();
    usecase = CreateBatchUseCase(batchRepository: repository);
    registerFallbackValue(BatchEntity.empty());
  });

  final params = CreateBatchParams.empty();

  test('should call the [BatchRepo.createBatch]', () async {
    // Arrange : Stubbing the method , we are hijaccking the method
    // Then return : Use wheh the method is not a Future
    // Then answer : Use when the method is a Future

    when(() => repository.createBatch(any())).thenAnswer(
      (_) async => Right(null),
    );

    // Act
    final result = await usecase(params);

    // Assert
    // expect(result, equals(const Right<dynamic, void>(null)));
    expect(result, Right(null));

    // Verify

    verify(() => repository.createBatch(any())).called(1);

    verifyNoMoreInteractions(repository);
  });
}
