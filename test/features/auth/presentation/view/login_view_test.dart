import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/login_view.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockLoginBloc loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();
  });

  Widget loadLoginView() {
    return BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
      child: MaterialApp(home: LoginView()),
    );
  }

  testWidgets('check for the text in login ui', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    // find button by text
    final result = find.widgetWithText(ElevatedButton, 'Login');

    expect(result, findsOneWidget);
  });

  // Check for the validator error
  testWidgets('Check for the username and password', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'kiran');
    await tester.enterText(find.byType(TextField).at(1), 'kiran123');

    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(find.text('kiran'), findsOneWidget);
    expect(find.text('kiran123'), findsOneWidget);
  });

  testWidgets('Check for the validator error', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    // await tester.enterText(find.byType(TextField).at(0), '');
    // await tester.enterText(find.byType(TextField).at(1), '');

    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(find.text('Please enter username'), findsOneWidget);
    expect(find.text('Please enter password'), findsOneWidget);
  });

  // Should show progress indicator when loading
  testWidgets('Login success', (tester) async {
    when(() => loginBloc.state)
        .thenReturn(LoginState(isLoading: true, isSuccess: true));

    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'kiran');
    await tester.enterText(find.byType(TextField).at(1), 'kiran123');

    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(loginBloc.state.isSuccess, true);
  });
}

