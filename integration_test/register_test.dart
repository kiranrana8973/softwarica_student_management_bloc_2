import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/register_view.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/entity/batch_entity.dart';
import 'package:softwarica_student_management_bloc/features/batch/presentation/view_model/batch_bloc.dart';
import 'package:softwarica_student_management_bloc/features/course/domain/entity/course_entity.dart';
import 'package:softwarica_student_management_bloc/features/course/presentation/view_model/course_bloc.dart';

import '../test/features/auth/presentation/test_data/batch_test_data.dart';
import '../test/features/auth/presentation/test_data/course_test_data.dart';

class MockBatchBloc extends MockBloc<BatchEvent, BatchState>
    implements BatchBloc {}

class MockCourseBloc extends MockBloc<CourseEvent, CourseState>
    implements CourseBloc {}

class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterBloc {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockBatchBloc batchBloc;
  late MockCourseBloc courseBloc;
  late MockRegisterBloc registerBloc;

  setUp(() {
    batchBloc = MockBatchBloc();
    courseBloc = MockCourseBloc();
    registerBloc = MockRegisterBloc();
  });

  Widget loadRegisterView(Widget body) {
    when(() => batchBloc.state).thenReturn(BatchState(
      isLoading: false,
      error: '',
      batches: BatchTestData.getBatchTestData(),
    ));
    // Load CourseTestData
    when(() => courseBloc.state).thenReturn(CourseState(
      isLoading: false,
      error: '',
      courses: CourseTestData.getCourseTestData(),
    ));
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BatchBloc>.value(value: batchBloc),
          BlocProvider<CourseBloc>.value(value: courseBloc),
          BlocProvider<RegisterBloc>.value(value: registerBloc),
        ],
        child: RegisterView(),
      ),
    );
  }

  testWidgets('Check for  the title', (tester) async {
    await tester.pumpWidget(loadRegisterView(RegisterView()));

    await tester.pumpAndSettle();

    expect(find.text('Register'), findsOneWidget);
  });

  // Check for the Dropdown data
  testWidgets('Load Dropdown value and select second index data',
      (tester) async {
    await tester.pumpWidget(loadRegisterView(RegisterView()));

    await tester.pumpAndSettle();

    final dropdownFinder = find.byType(DropdownButtonFormField<BatchEntity>);
    await tester.ensureVisible(dropdownFinder);

    await tester.tap(dropdownFinder);

    // Use this because the menu items are not visible
    await tester.pumpAndSettle();

    //tap on the first item in the dropdown
    await tester.tap(find.byType(DropdownMenuItem<BatchEntity>).at(1));
    //Use this to close the dropdown
    await tester.pumpAndSettle();

    expect(find.text('30-B'), findsOneWidget);
  });

  // Check for the MultiSelect Dialog field
  testWidgets('Load MultiSelect Dialog and select Flutter and Api',
      (tester) async {
    await tester.pumpWidget(loadRegisterView(RegisterView()));

    await tester.pumpAndSettle();
    final multiSelectFinder = find.byType(MultiSelectDialogField<CourseEntity>);
    await tester.ensureVisible(multiSelectFinder);

    await tester.tap(multiSelectFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Flutter'));
    await tester.tap(find.text('Api'));

    await tester.tap(find.text('OK'));

    await tester.pumpAndSettle();

    expect(find.text('Flutter'), findsOneWidget);
  });

  // Test all the fields
  testWidgets('Check for the validator error', (tester) async {
    await tester.pumpWidget(loadRegisterView(RegisterView()));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Kiran');
    await tester.enterText(find.byType(TextFormField).at(1), 'Rana');
    await tester.enterText(find.byType(TextFormField).at(2), '9844332211');
    await tester.enterText(find.byType(TextFormField).at(3), 'kiran');
    await tester.enterText(find.byType(TextFormField).at(4), 'kiran123');

    //=========================== Find the dropdownformfield===========================

    final dropdownFinder = find.byType(DropdownButtonFormField<BatchEntity>);
    await tester.ensureVisible(dropdownFinder);

    await tester.tap(dropdownFinder);

    // Use this because the menu items are not visible
    await tester.pumpAndSettle();

    //tap on the first item in the dropdown
    await tester.tap(find.byType(DropdownMenuItem<BatchEntity>).at(0));
    //Use this to close the dropdown
    await tester.pumpAndSettle();

    //=========================== Find the MultiSelectDialogField===========================
    final multiSelectFinder = find.byType(MultiSelectDialogField<CourseEntity>);
    await tester.ensureVisible(multiSelectFinder);

    await tester.tap(multiSelectFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Flutter'));
    await tester.tap(find.text('Api'));

    await tester.tap(find.text('OK'));

    await tester.pumpAndSettle();

    //=========================== Find the register button===========================
    final registerButtonFinder =
        find.widgetWithText(ElevatedButton, 'Register');

    await tester.tap(registerButtonFinder);

    await tester.pumpAndSettle();

    expect(find.text('Please enter username'), findsNothing);
  });
}
