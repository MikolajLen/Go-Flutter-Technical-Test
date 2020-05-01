
import 'package:flutter/material.dart';
import 'package:teamgoflutterapp/generated/i18n.dart';

Widget initTestApp(Widget child)=> MaterialApp(
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      home: child,
  );

