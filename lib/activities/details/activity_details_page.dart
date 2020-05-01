import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../generated/i18n.dart';
import '../widget/activity_widget.dart';
import 'bloc/activity_details_bloc.dart';
import 'bloc/activity_details_event.dart';
import 'bloc/activity_details_state.dart';

class ActivityDetailsWidget extends StatelessWidget {
  const ActivityDetailsWidget({Key key, this.editable}) : super(key: key);

  final bool editable;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).activity_details),
          actions: <Widget>[
            if (editable)
              MaterialButton(
                  onPressed: () {
                    BlocProvider.of<ActivityDetailsBloc>(context)
                        .add(EditActivityEvent());
                  },
                  child: Text(S.of(context).edit,
                      style: TextStyle(color: Colors.white)))
          ],
        ),
        body: BlocBuilder<ActivityDetailsBloc, ActivityDetailsState>(
            builder: (context, state) {
          if (state is ActivityLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInImage.assetNetwork(
                      placeholder: 'assets/default.png',
                      image: state.activity.photoUrl),
                  ActivityWidget(
                    widgetActivity: state.activity,
                  ),
                  Container(
                    padding: EdgeInsets.all(Dimensions.marginSmall),
                    child: Text(
                      S.of(context).details,
                      style: Styles.activityLabelStyle,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.marginSmall,
                        horizontal: Dimensions.marginStandard),
                    child: Text(
                      state.activity.detailedDescription,
                      style: Styles.activityValueStyle,
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      );
}
