import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/registration/bloc/registration_bloc.dart';
import 'package:teamgoflutterapp/registration/bloc/registration_event.dart';
import 'package:teamgoflutterapp/registration/bloc/registration_state.dart';
import 'package:teamgoflutterapp/registration/registration_page.dart';

import '../test_utils.dart';

void main() {
  const imagePickerChannel = MethodChannel('plugins.flutter.io/image_picker');
  RegistrationBloc registrationBloc;

  setUp(() {
    registrationBloc = MockRegistrationBloc();
  });

  Widget initRegistrationWidget() => BlocProvider.value(
        value: registrationBloc,
        child: RegistrationPage(),
      );

  Future enterUsernameAndPassword(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.pumpWidget(widget);
    await tester.enterText(find.byKey(Key('Username')), 'Username');
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key('Password')), 'Password');
    await tester.pumpAndSettle();
  }

  group('registrationPage', () {
    testWidgets('Should display placeholder when photo is not selected',
        (WidgetTester tester) async {
      //given
      when(registrationBloc.state).thenReturn(InitialRegistrationState());
      final widget = initTestApp(initRegistrationWidget());

      //when
      await tester.pumpWidget(widget);

      //then
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('Should display photo when selected',
        (WidgetTester tester) async {
      //given
      final file = File('/mock.png');
      when(registrationBloc.state).thenReturn(PhotoUploaded(file));
      final widget = initTestApp(initRegistrationWidget());

      //when
      await tester.pumpWidget(widget);

      //then
      expect(find.byIcon(Icons.person), findsNothing);
      expect(find.byKey(Key('fileImage')), findsOneWidget);
    });

    testWidgets('Should display photo when selected for loading state',
        (WidgetTester tester) async {
      //given
      final file = File('/mock.png');
      when(registrationBloc.state).thenReturn(RegistrationLoading(file));
      final widget = initTestApp(initRegistrationWidget());

      //when
      await tester.pumpWidget(widget);

      //then
      expect(find.byIcon(Icons.person), findsNothing);
      expect(find.byKey(Key('fileImage')), findsOneWidget);
    });

    testWidgets('Should show progress when loading state',
        (WidgetTester tester) async {
      //given
      when(registrationBloc.state).thenReturn(RegistrationLoading(null));
      final widget = initTestApp(initRegistrationWidget());

      //when
      await tester.pumpWidget(widget);

      //then
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('Should error message when registration failed',
        (WidgetTester tester) async {
      //given
      when(registrationBloc.state).thenReturn(RegistrationFailure());
      final widget = initTestApp(initRegistrationWidget());

      //when
      await tester.pumpWidget(widget);

      //then
      expect(find.text('Cannot create an account'), findsOneWidget);
    });

    testWidgets('Should show error messages when vaildation failed',
        (WidgetTester tester) async {
      //given
      when(registrationBloc.state).thenReturn(InitialRegistrationState());
      final widget = initTestApp(initRegistrationWidget());
      await tester.pumpWidget(widget);

      //when
      await tester.tap(find.byType(RaisedButton));
      await tester.pumpAndSettle();

      //then
      expect(find.text('Username must have at least 5 characters'),
          findsOneWidget);
      expect(find.text('Password must have at least 5 characters'),
          findsOneWidget);
    });

    testWidgets('Should send register user event', (WidgetTester tester) async {
      //given
      when(registrationBloc.state).thenReturn(InitialRegistrationState());
      final widget = initTestApp(initRegistrationWidget());
      await enterUsernameAndPassword(tester, widget);

      //when
      await tester.tap(find.byType(RaisedButton));
      await tester.pumpAndSettle();

      //then
      verify(registrationBloc
          .add(RegisterUserEvent(username: 'Username', password: 'Password')));
    });

    testWidgets('Should send event with selected photo',
        (WidgetTester tester) async {
      //given
      imagePickerChannel
          .setMockMethodCallHandler((_) => Future.value('/image.png'));
      when(registrationBloc.state).thenReturn(InitialRegistrationState());
      final widget = initTestApp(initRegistrationWidget());
      await tester.pumpWidget(widget);

      //when
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      //then
      verify(registrationBloc
          .add(UploadPhotoEvent(photoFile: File('/image.png'))));
    });
  });
}

class MockRegistrationBloc
    extends MockBloc<RegistrationEvent, RegistrationState>
    implements RegistrationBloc {}
