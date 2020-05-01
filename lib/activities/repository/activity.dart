import 'dart:io';

import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  const Activity(
      {this.id,
      this.userId,
      this.username,
      this.userPhoto,
      this.what,
      this.where,
      this.when,
      this.createdAt,
      this.photoUrl,
      this.detailedDescription});

  factory Activity.fromMap(Map<String, dynamic> map, String imagePath) =>
      Activity(
          id: map['id'],
          userId: map['userId'],
          username: map['username'],
          userPhoto: map['user_photo'] != null
              ? File('$imagePath/${map['user_photo']}')
              : null,
          what: map['what'],
          when: map['when_to_start'],
          where: map['place'],
          createdAt: map['created_at'],
          photoUrl: map['photo_url'],
          detailedDescription: map['detailed_desc']);

  @override
  List<Object> get props => [
        id,
        userId,
        username,
        userPhoto,
        what,
        where,
        when,
        createdAt,
        detailedDescription
      ];

  final int id;
  final int userId;
  final String username;
  final File userPhoto;
  final String what;
  final String where;
  final String when;
  final String createdAt;
  final String photoUrl;
  final String detailedDescription;
}
