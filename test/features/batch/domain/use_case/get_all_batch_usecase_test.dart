import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/entity/batch_entity.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/use_case/get_all_batch_usecase.dart';

import 'repository.mock.dart';

void main() {
  late MockBatchRepository repository;
  late GetAllBatchUseCase usecase;

  setUp(() {
    repository = MockBatchRepository();
    usecase = GetAllBatchUseCase(batchRepository: repository);
  });

  final tBatch = BatchEntity(
    batchId: '1',
    batchName: 'Test Batch',
  );

  final tBatch2 = BatchEntity(
    batchId: '2',
    batchName: 'Test Batch 2',
  );

  final tBatches = [tBatch, tBatch2];

  test('should get batches from repository', () async {
    // Arrange
    when(() => repository.getBatches())
        .thenAnswer((_) async => Right(tBatches));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(tBatches));

    // Verify
    verify(() => repository.getBatches()).called(1);
  });
}


