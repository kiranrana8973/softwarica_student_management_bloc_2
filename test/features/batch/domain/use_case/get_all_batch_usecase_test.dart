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
    // add other properties
  );
  test('should get batches from repository', () async {
    // Arrange
    final tBatches = [tBatch];
    when(() => repository.getBatches())
        .thenAnswer((_) async => Right(tBatches));

    // Act
    final result = await usecase();

    // Assert
    verify(() => repository.getBatches()).called(1);
    expect(result, Right(tBatches));
  });
}
