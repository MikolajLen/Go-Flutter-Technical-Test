import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../generated/i18n.dart';
import '../repository/activity.dart';

class ActivityWidget extends StatelessWidget {
  const ActivityWidget({Key key, this.widgetActivity}) : super(key: key);

  final Activity widgetActivity;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(Dimensions.marginSmall),
              child: Text(
                S.of(context).who,
                style: Styles.activityLabelStyle,
              )),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.marginSmall,
                horizontal: Dimensions.marginStandard),
            child: Row(
              children: <Widget>[
                if (widgetActivity.userPhoto != null)
                  CircleAvatar(
                    backgroundImage: FileImage(
                      widgetActivity.userPhoto,
                    ),
                  )
                else
                  ClipOval(
                    child: Container(
                      color: Colors.blueGrey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Container(
                    padding: EdgeInsets.only(left: Dimensions.marginSmall),
                    child: Text(widgetActivity.username))
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(Dimensions.marginSmall),
              child: Text(
                S.of(context).what,
                style: Styles.activityLabelStyle,
              )),
          Container(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.marginSmall,
                  horizontal: Dimensions.marginStandard),
              child: Text(
                widgetActivity.what,
                style: Styles.activityValueStyle,
              )),
          Container(
              padding: EdgeInsets.all(Dimensions.marginSmall),
              child: Text(
                S.of(context).when,
                style: Styles.activityLabelStyle,
              )),
          Container(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.marginSmall,
                  horizontal: Dimensions.marginStandard),
              child: Text(
                widgetActivity.when,
                style: Styles.activityValueStyle,
              )),
          Container(
              padding: EdgeInsets.all(Dimensions.marginSmall),
              child: Text(
                S.of(context).where,
                style: Styles.activityLabelStyle,
              )),
          Container(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.marginSmall,
                  horizontal: Dimensions.marginStandard),
              child: Text(
                widgetActivity.where,
                style: Styles.activityValueStyle,
              ))
        ],
      );
}
