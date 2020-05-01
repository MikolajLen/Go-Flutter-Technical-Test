import 'dart:io';

class DbUser {
  DbUser(this.id, this.username, this.photoFile);

  factory DbUser.fromMap(Map<String, dynamic> map, imagePathPrefix) => DbUser(
      map['_id'], map['name'], File('$imagePathPrefix/${map['avatar']}'));

  final int id;
  final String username;
  final File photoFile;
}
