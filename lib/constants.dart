import 'package:flutter/material.dart';

class Dimensions {
  static const marginStandard = 16.0;
  static const marginSmall = 8.0;
  static const marginLarge = 32.0;
  static const textInputBorder = 4.0;
  static const logoSize = 64.0;
  static const logoPadding = 32.0;
}

class Styles {
  static const titleTextStyle =
      TextStyle(fontWeight: FontWeight.w700, fontSize: 36.0);

  static const subtitleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0);

  static const errorMessageTextStyle = TextStyle(color: Colors.red);

  static const activityLabelStyle  = TextStyle(
  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 20);

  static const activityTitleStyle  =  TextStyle(fontSize: 24);

  static const activityValueStyle  =  TextStyle(fontSize: 16);
}

class InputStyles {
  static InputDecoration inputDecoration(String text) => InputDecoration(
      labelText: text,
      border: OutlineInputBorder(
          borderSide: BorderSide(width: Dimensions.textInputBorder)));
}
