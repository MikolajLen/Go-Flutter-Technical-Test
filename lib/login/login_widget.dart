import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_provider.dart';
import '../db/file_manager.dart';
import 'persister/sqlite_login_persister.dart';
import 'repository/sqlite_login_helper.dart';
import 'repository/sqlite_login_repository.dart';
import '../navigation/custom_navigator.dart';

import 'bloc/login_bloc.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key key, this.navigatorKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => LoginBloc(
            SqLiteLoginRepository(
                SqLiteLoginHelper(DatabaseProvider(), FileManager()),
                SqliteLoginPersister(SharedPreferences.getInstance())),
            CustomNavigator(navigatorKey)));
}
