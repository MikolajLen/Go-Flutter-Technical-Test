import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../generated/i18n.dart';
import '../../utils/widget_utils.dart';
import '../repository/activity.dart';
import 'bloc/new_activity_bloc.dart';
import 'bloc/new_activity_event.dart';
import 'bloc/new_activity_state.dart';

class NewActivityPage extends StatefulWidget {
  @override
  _NewActivityPageState createState() => _NewActivityPageState();
}

class _NewActivityPageState extends State<NewActivityPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  static const minLines = 5;
  static const maxLines = 10;

  String photoUrl;
  String what;
  String where;
  String when;
  String desc;

  String validator(String val) =>
      val.trim().isNotEmpty ? null : S.of(context).validator_error_message;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewActivityBloc, NewActivityState>(builder: (context, state) {
        final activity = state is ActivityCreated ? state.activity : Activity();
        return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).add_activity_title),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      BlocProvider.of<NewActivityBloc>(context).add(
                          AddNewActivityEvent(
                              activity.id, photoUrl, what, where, when, desc));
                    }
                  },
                  child: Text(
                    S.of(context).save,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            body: FullScreenProgress(
              showProgress: state is UpdatingState,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.marginStandard),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.marginSmall),
                            child: Text(
                              S.of(context).image_url,
                              style: Styles.activityLabelStyle,
                            )),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: S.of(context).image_url),
                          onSaved: (val) => photoUrl = val,
                          key: Key('photoUrl'),
                          controller:
                              TextEditingController(text: activity.photoUrl),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.marginSmall),
                            child: Text(S.of(context).what,
                                style: Styles.activityLabelStyle)),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: S.of(context).what),
                          validator: validator,
                          onSaved: (val) => what = val,
                          key: Key('what'),
                          controller:
                              TextEditingController(text: activity.what),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.marginSmall),
                            child: Text(
                              S.of(context).when,
                              style: Styles.activityLabelStyle,
                            )),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: S.of(context).when),
                          validator: validator,
                          key: Key('when'),
                          onSaved: (val) => when = val,
                          controller:
                              TextEditingController(text: activity.when),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.marginSmall),
                            child: Text(
                              S.of(context).where,
                              style: Styles.activityLabelStyle,
                            )),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: S.of(context).where),
                          onSaved: (val) => where = val,
                          validator: validator,
                          key: Key('where'),
                          controller:
                              TextEditingController(text: activity.where),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.marginSmall),
                            child: Text(
                              S.of(context).details,
                              style: Styles.activityLabelStyle,
                            )),
                        TextFormField(
                          minLines: minLines,
                          maxLines: maxLines,
                          validator: validator,
                          key: Key('description'),
                          controller: TextEditingController(
                              text: activity.detailedDescription),
                          onSaved: (val) => desc = val,
                          decoration:
                              InputDecoration(hintText: S.of(context).details),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
      });
}
