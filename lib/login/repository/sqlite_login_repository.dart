import 'dart:io';

import 'package:flutter/material.dart';

import 'login_persister.dart';
import 'login_repository.dart';
import 'sqlite_login_helper.dart';

class SqLiteLoginRepository implements LoginRepository {
  SqLiteLoginRepository(this._helper, this._loginPersister);

  final SqLiteLoginHelper _helper;
  final LoginPersister _loginPersister;

  @override
  Future<bool> logUser(
      {@required String username, @required String password}) async {
    final _user = await _helper.getUser(username, password);
    return _user != null;
  }

  @override
  Future<bool> logOutUser() async {
    await _loginPersister.wipeUserData();
    return true;
  }

  @override
  Future<bool> registerUser(
      {String username, String password, File photo}) async {
    final _user = await _helper.registerUser(username, password, photo);
    if (_user != null) {
      await _loginPersister.persistUserId(_user.id);
    }
    return _user != null;
  }

  @override
  Future<int> getUserId() => _loginPersister.getUserId();
}
