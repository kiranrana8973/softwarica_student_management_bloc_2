import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/app/shared_prefs/token_shared_prefs.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/repository/auth_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/login_usecase.dart';

class AuthRepoMock extends Mock implements IAuthRepository {}

class TokenSharedPrefsMock extends Mock implements TokenSharedPrefs {}

void main() {
  late AuthRepoMock repository;
  late TokenSharedPrefsMock tokenSharedPrefs;
  late LoginUseCase usecase;

  setUp(() {
    repository = AuthRepoMock();
    tokenSharedPrefs = TokenSharedPrefsMock();
    usecase = LoginUseCase(repository, tokenSharedPrefs);
  });

  test('should call the [AuthRepo.login]', () async {
    when(() => repository.loginStudent(any(), any())).thenAnswer(
      (_) async => Right('token'),
    );

    when(() => tokenSharedPrefs.saveToken(any())).thenAnswer(
      (_) async => Right(null),
    );

    final result = await usecase(LoginParams(
      username: any(named: 'username'),
      password: any(named: 'password'),
    ));

    expect(result, equals(const Right<dynamic, void>(null)));

    verify(() => repository.loginStudent(any(), any())).called(1);
    verify(() => tokenSharedPrefs.saveToken(any())).called(1);

    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });
}
