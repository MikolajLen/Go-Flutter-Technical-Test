import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'activities/details/activity_details_page.dart';
import 'activities/details/bloc/activity_details_bloc.dart';
import 'activities/details/bloc/activity_details_event.dart';
import 'activities/list/activities_page.dart';
import 'activities/list/bloc/activities_bloc.dart';
import 'activities/list/bloc/activities_event.dart';
import 'activities/newActivity/bloc/new_activity_bloc.dart';
import 'activities/newActivity/bloc/new_activity_event.dart';
import 'activities/newActivity/new_activity_page.dart';
import 'activities/repository/activity.dart';
import 'activities/repository/sqlite_activities_helper.dart';
import 'activities/repository/sqlite_activities_repository.dart';
import 'db/database_provider.dart';
import 'db/file_manager.dart';
import 'generated/i18n.dart';
import 'login/bloc/login_bloc.dart';
import 'login/login_page.dart';
import 'login/persister/sqlite_login_persister.dart';
import 'login/repository/sqlite_login_helper.dart';
import 'login/repository/sqlite_login_repository.dart';
import 'navigation/custom_navigator.dart';
import 'navigation/navigator_widget.dart';
import 'registration/bloc/registration_bloc.dart';
import 'registration/registration_page.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'TeamGo app',
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: {
        AppRoutes.login: (context) => BlocProvider(
            create: (context) => LoginBloc(
                SqLiteLoginRepository(
                    SqLiteLoginHelper(DatabaseProvider(), FileManager()),
                    SqliteLoginPersister(SharedPreferences.getInstance())),
                CustomNavigator(_navigatorKey)),
            child: LoginPage()),
        AppRoutes.activitiesList: (context) => BlocProvider(
            create: (context) => ActivitiesBloc(
                SqliteActivitiesRepository(
                    SqliteActivitiesHelper(DatabaseProvider(), FileManager())),
                SqLiteLoginRepository(
                    SqLiteLoginHelper(DatabaseProvider(), FileManager()),
                    SqliteLoginPersister(SharedPreferences.getInstance())),
                CustomNavigator(_navigatorKey))
              ..add(Fetch()),
            child: ActivitiesPage()),
        AppRoutes.registration: (context) => BlocProvider(
            create: (context) => RegistrationBloc(
                SqLiteLoginRepository(
                    SqLiteLoginHelper(DatabaseProvider(), FileManager()),
                    SqliteLoginPersister(SharedPreferences.getInstance())),
                CustomNavigator(_navigatorKey)),
            child: RegistrationPage())
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.activityDetails) {
          return MaterialPageRoute(builder: (context) {
            final List params = settings.arguments;
            return BlocProvider(
                create: (context) => ActivityDetailsBloc(
                    SqliteActivitiesRepository(SqliteActivitiesHelper(
                        DatabaseProvider(), FileManager())),
                    CustomNavigator(_navigatorKey))
                  ..add(FetchActivity(params[0])),
                child: ActivityDetailsWidget(editable: params[1]));
          });
        }
        if (settings.name == AppRoutes.newActivity) {
          return MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (context) {
                    final bloc = NewActivityBloc(
                        SqliteActivitiesRepository(SqliteActivitiesHelper(
                            DatabaseProvider(), FileManager())),
                        SqLiteLoginRepository(
                            SqLiteLoginHelper(
                                DatabaseProvider(), FileManager()),
                            SqliteLoginPersister(
                                SharedPreferences.getInstance())),
                        CustomNavigator(_navigatorKey));
                    if (settings.arguments != null &&
                        settings.arguments is Activity) {
                      bloc.add(FillDataEvent(settings.arguments));
                    }
                    return bloc;
                  },
                  child: NewActivityPage()));
        }
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => LoginBloc(
                    SqLiteLoginRepository(
                        SqLiteLoginHelper(DatabaseProvider(), FileManager()),
                        SqliteLoginPersister(SharedPreferences.getInstance())),
                    CustomNavigator(_navigatorKey)),
                child: LoginPage()));
      },
      navigatorKey: _navigatorKey,
      home: NavigatorWidget(
        customNavigator: CustomNavigator(_navigatorKey),
        loginPersister: SqliteLoginPersister(SharedPreferences.getInstance()),
        fileManager: FileManager(),
      ));
}

class AppRoutes {
  static const login = '/login';
  static const activitiesList = '/activitiesList';
  static const activityDetails = '/activityDetails';
  static const newActivity = '/newActivity';
  static const registration = '/registration';
}
