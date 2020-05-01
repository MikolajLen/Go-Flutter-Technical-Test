import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/login/bloc/login_bloc.dart';
import 'package:teamgoflutterapp/login/bloc/login_event.dart';
import 'package:teamgoflutterapp/login/bloc/login_state.dart';
import 'package:teamgoflutterapp/login/login_page.dart';

import '../test_utils.dart';

void main() {
  LoginBloc loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();
  });

  Widget initLoginWidget() => BlocProvider.value(
        value: loginBloc,
        child: LoginPage(),
      );

  group('loginPage', () {
    Future enterUsernameAndPassword(WidgetTester tester, Widget widget) async {
      await tester.pumpWidget(widget);
      await tester.enterText(find.byKey(Key('Username')), 'login');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('Password')), 'Password');
      await tester.pumpAndSettle();
    }

    testWidgets('Should show error message when state is failure',
        (WidgetTester tester) async {
      //given
      when(loginBloc.state).thenReturn(LoginFailure());
      final widget = initTestApp(initLoginWidget());

      //when
      await tester.pumpWidget(widget);

      //then
      expect(find.text("Invalid Credentials"), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Should show progress when state is loading',
        (WidgetTester tester) async {
      //given
      when(loginBloc.state).thenReturn(LoginLoading());
      final widget = initTestApp(initLoginWidget());

      //when
      await tester.pumpWidget(widget);

      //then
      expect(find.text("Invalid Credentials"), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should send login event after pressing the button',
        (WidgetTester tester) async {
      //given
      when(loginBloc.state).thenReturn(InitialLoginState());
      final widget = initTestApp(initLoginWidget());
      await enterUsernameAndPassword(tester, widget);

      //when
      await tester.tap(find.byType(RaisedButton));
      await tester.pumpAndSettle();

      //then
      verify(loginBloc.add(LogUser('login', 'Password')));
      expect(find.text("Invalid Credentials"), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Should send register event after pressing regsiter button',
        (WidgetTester tester) async {
      //given
      when(loginBloc.state).thenReturn(InitialLoginState());
      final widget = initTestApp(initLoginWidget());
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      //when
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();

      //then
      verify(loginBloc.add(RegisterUser()));
    });
  });
}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}
