import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/use_case/create_batch_usecase.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/use_case/delete_batch_usecase.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/use_case/get_all_batch_usecase.dart';

class MockCreateBatchUseCase extends Mock implements CreateBatchUseCase {}

class MockGetAllBatchUseCase extends Mock implements GetAllBatchUseCase {}

class MockDeleteBatchUsecase extends Mock implements DeleteBatchUsecase {}

void main() {
  late MockCreateBatchUseCase mockCreateBatchUseCase;
  late MockGetAllBatchUseCase mockGetAllBatchUseCase;
  late MockDeleteBatchUsecase mockDeleteBatchUsecase;

  testWidgets('batch bloc ...', (tester) async {
    // TODO: Implement test
  });
}
