import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/login_usecase.dart';

import '../../../batch/domain/use_case/token.mock.dart';
import 'auth_repo.mock.dart';

void main() {
  late AuthRepoMock repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late LoginUseCase usecase;

  setUp(() {
    repository = AuthRepoMock();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = LoginUseCase(repository, tokenSharedPrefs);
  });

  test('should call the [AuthRepo.login]', () async {
    when(() => repository.loginStudent(any(), any())).thenAnswer(
      (invocation) async {
        final username = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;
        if (username == 'kiran' && password == 'kiran123') {
          return Future.value(const Right('token'));
        } else {
          return Future.value(
              const Left(ApiFailure(message: 'Invalid username or password')));
        }
      },
    );

    when(() => tokenSharedPrefs.saveToken(any())).thenAnswer(
      (_) async => Right(null),
    );

    final result = await usecase(LoginParams(
      username: 'kiran',
      password: 'kiran123',
    ));

    expect(result, const Right('token'));

    verify(() => repository.loginStudent(any(), any())).called(1);
    verify(() => tokenSharedPrefs.saveToken(any())).called(1);

    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });
}

// void main() {
//   late MockApiClient mockApiClient;
//   late MockTokenSharedPrefs mockTokenSharedPrefs;
//   late AuthRepositoryImpl authRepositoryImpl;

//   const tEmail = 'test@example.com';
//   const tPassword = 'Test@123';
//   const tToken = 'test_token';
//   const tUserModel = UserModel(id: '1', email: tEmail);

//   setUp(() {
//     mockApiClient = MockApiClient();
//     mockTokenSharedPrefs = MockTokenSharedPrefs();
//     authRepositoryImpl = AuthRepositoryImpl(
//       apiClient: mockApiClient,
//       tokenSharedPrefs: mockTokenSharedPrefs,
//     );
//   });

//   group('login', () {
//     test('should return UserModel and save token when login is successful', () async {
//       // Arrange
//       when(() => mockApiClient.login(any(), any()))
//           .thenAnswer((_) async => const {'token': tToken, 'user': tUserModel.toJson()});
//       when(() => mockTokenSharedPrefs.saveToken(any()))
//           .thenAnswer((_) async => {});

//       // Act
//       final result = await authRepositoryImpl.login(tEmail, tPassword);

//       // Assert
//       verify(() => mockApiClient.login(tEmail, tPassword)).called(1);
//       verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);
//       expect(result, const Right(tUserModel));
//     });

//     test('should return ServerFailure when API call fails', () async {
//       // Arrange
//       when(() => mockApiClient.login(any(), any()))
//           .thenThrow(ServerException());

//       // Act
//       final result = await authRepositoryImpl.login(tEmail, tPassword);

//       // Assert
//       verify(() => mockApiClient.login(tEmail, tPassword)).called(1);
//       expect(result, Left(ServerFailure()));
//     });
//   });

//   group('logout', () {
//     test('should delete token when logout is successful', () async {
//       // Arrange
//       when(() => mockApiClient.logout())
//           .thenAnswer((_) async => {});
//       when(() => mockTokenSharedPrefs.deleteToken())
//           .thenAnswer((_) async => {});

//       // Act
//       final result = await authRepositoryImpl.logout();

//       // Assert
//       verify(() => mockApiClient.logout()).called(1);
//       verify(() => mockTokenSharedPrefs.deleteToken()).called(1);
//       expect(result, const Right(unit));
//     });
//   });

//   group('checkAuthStatus', () {
//     test('should return UserModel when token exists', () async {
//       // Arrange
//       when(() => mockTokenSharedPrefs.getToken())
//           .thenAnswer((_) async => tToken);
//       when(() => mockApiClient.getCurrentUser())
//           .thenAnswer((_) async => tUserModel.toJson());

//       // Act
//       final result = await authRepositoryImpl.checkAuthStatus();

//       // Assert
//       verify(() => mockTokenSharedPrefs.getToken()).called(1);
//       verify(() => mockApiClient.getCurrentUser()).called(1);
//       expect(result, const Right(tUserModel));
//     });

//     test('should return UnauthenticatedFailure when no token exists', () async {
//       // Arrange
//       when(() => mockTokenSharedPrefs.getToken())
//           .thenAnswer((_) async => null);

//       // Act
//       final result = await authRepositoryImpl.checkAuthStatus();

//       // Assert
//       verify(() => mockTokenSharedPrefs.getToken()).called(1);
//       expect(result, Left(UnauthenticatedFailure()));
//     });
//   });
// }
