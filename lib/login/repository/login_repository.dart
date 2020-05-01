import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class LoginRepository {

  Future<bool> logUser({@required String username, @required String password});

  Future<bool> registerUser(
      {@required String username, @required String password, File photo});

  Future<bool> logOutUser();

  Future<int> getUserId();
}
