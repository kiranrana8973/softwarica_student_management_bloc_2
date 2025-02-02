import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/use_case/delete_batch_usecase.dart';

import 'repository.mock.dart';
import 'token.mock.dart';

void main() {
  late DeleteBatchUsecase usecase;
  late MockBatchRepository repository;
  late MockTokenSharedPrefs tokenSharedPrefs;

  setUp(() {
    repository = MockBatchRepository();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = DeleteBatchUsecase(
      batchRepository: repository,
      tokenSharedPrefs: tokenSharedPrefs,
    );
  });
  final tBatchId = '1';
  final token = 'token';
  final deleteBatchParams = DeleteBatchParams(batchId: tBatchId);

  test('delete batch using id ', () async {
    // Arrange
    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => Right(token));
    when(() => repository.deleteBatch(tBatchId, token)).thenAnswer(
      (_) async => Right(null),
    );

    // Act
    final result = await usecase(deleteBatchParams);

    // Assert
    expect(result, Right(null));

    // Verify
    verify(() => tokenSharedPrefs.getToken()).called(1);
    verify(() => repository.deleteBatch(tBatchId, token)).called(1);

    verifyNoMoreInteractions(repository);

    verifyNoMoreInteractions(tokenSharedPrefs);
  });
}
