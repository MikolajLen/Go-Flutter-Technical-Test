import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../generated/i18n.dart';
import '../repository/activity.dart';
import '../widget/activity_widget.dart';
import 'bloc/activities_bloc.dart';
import 'bloc/activities_event.dart';
import 'bloc/activities_state.dart';

class ActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).activities_page_title),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () =>
                      BlocProvider.of<ActivitiesBloc>(context).add(LogOut()))
            ],
          ),
          body: BlocBuilder<ActivitiesBloc, ActivitiesState>(
              builder: (context, state) {
            if (state is ActivitiesLoaded) {
              return ListView.builder(
                  itemBuilder: (context, index) =>
                      _buildActivitiyItem(state.activities[index], context),
                  itemCount: state.activities.length);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                BlocProvider.of<ActivitiesBloc>(context).add(AddActivity()),
            child: Icon(Icons.add),
          ),
        ),
      );

  Widget _buildActivitiyItem(Activity activity, BuildContext context) =>
      Container(
        padding: EdgeInsets.all(Dimensions.marginStandard),
        child: Card(
            key: Key('activity:${activity.id}'),
            child: InkWell(
              onTap: () => BlocProvider.of<ActivitiesBloc>(context)
                  .add(ShowDetails(activity)),
              child: ActivityWidget(widgetActivity: activity,),
            )),
      );
}
