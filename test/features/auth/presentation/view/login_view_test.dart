import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/login_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/login_view.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/home_cubit.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterBloc extends Mock implements RegisterBloc {}

class MockHomeCubit extends Mock implements HomeCubit {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late LoginBloc loginBloc;
  late LoginUseCase loginUseCase;
  late RegisterBloc registerBloc;
  late BuildContext context;
  late HomeCubit homeCubit;

  setUp(() {
    loginUseCase = MockLoginUseCase();
    registerBloc = MockRegisterBloc();
    homeCubit = MockHomeCubit();
    context = MockBuildContext();
    loginBloc = LoginBloc(
      registerBloc: registerBloc,
      homeCubit: homeCubit,
      loginUseCase: loginUseCase,
    );
  });

  test('initial state should be LoginState.initial()', () {
    expect(loginBloc.state, equals(LoginState.initial()));
    expect(loginBloc.state.isLoading, false);
    expect(loginBloc.state.isSuccess, false);
  });

  testWidgets('Check for the username and password in the view',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider(
        create: (context) => loginBloc,
        child: LoginView(),
      ),
    ));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'kiran');
    await tester.enterText(find.byType(TextField).at(1), 'kiran123');

    expect(find.text('kiran'), findsOneWidget);
    expect(find.text('kiran123'), findsOneWidget);
  });

  // Check for the validator error
  testWidgets('Check for the validator error', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider(
        create: (context) => loginBloc,
        child: LoginView(),
      ),
    ));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '');
    await tester.enterText(find.byType(TextField).at(1), '');

    // await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.tap(find.byType(ElevatedButton).at(0));

    await tester.pumpAndSettle();

    expect(find.text('Please enter username'), findsOneWidget);
    expect(find.text('Please enter password'), findsOneWidget);
  });

  // Check for the login button click
  testWidgets('Check for the login button click', (tester) async {
    String correctUsername = 'kiran';
    String correctPassword = 'kiran123';

    when(
      () => loginUseCase(
        LoginParams(
          username: correctUsername,
          password: correctPassword,
        ),
      ),
    ).thenAnswer((invocation) async {
      final username = invocation.positionalArguments[0] as String;
      final password = invocation.positionalArguments[1] as String;

      if (username == correctUsername && password == correctPassword) {
        return Right('token');
      } else {
        return Left(ApiFailure(message: 'Invalid Credentials'));
      }
    });

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider(
        create: (context) => loginBloc,
        child: LoginView(),
      ),
    ));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'kiran');
    await tester.enterText(find.byType(TextField).at(1), 'kiran123');

    await tester.tap(find.byType(ElevatedButton).at(0));

    await tester.pumpAndSettle();

    expect(loginBloc.state.isLoading, true);
  });
}
