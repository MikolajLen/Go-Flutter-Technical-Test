import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../generated/i18n.dart';
import '../utils/widget_utils.dart';
import 'bloc/registration_bloc.dart';
import 'bloc/registration_event.dart';
import 'bloc/registration_state.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String username;
  String password;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).register),
          ),
          body: BlocBuilder<RegistrationBloc, RegistrationState>(
            builder: (context, state) => FullScreenProgress(
              showProgress: state is RegistrationLoading,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            top: Dimensions.marginLarge,
                            left: Dimensions.marginStandard,
                            right: Dimensions.marginStandard),
                        child: Center(
                          child: Text(
                            S.of(context).register_page_title,
                            textAlign: TextAlign.center,
                            style: Styles.subtitleTextStyle,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(Dimensions.marginLarge),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              ImagePicker.pickImage(source: ImageSource.gallery)
                                  .then((image) {
                                if (image != null) {
                                  BlocProvider.of<RegistrationBloc>(context)
                                      .add(UploadPhotoEvent(photoFile: image));
                                }
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if ((state is PhotoUploaded ||
                                        state is RegistrationLoading) &&
                                    (state as dynamic).image != null)
                                  Image.file(
                                    (state as dynamic).image,
                                    key: Key('fileImage'),
                                    height: Dimensions.logoSize,
                                  )
                                else
                                  Icon(
                                    Icons.person,
                                    size: Dimensions.logoSize,
                                  ),
                                Text(S.of(context).select_photo_label),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(Dimensions.marginStandard),
                        child: TextFormField(
                          decoration: InputStyles.inputDecoration(
                              S.of(context).username),
                          key: Key('Username'),
                          validator: (name) => name.trim().length > 4
                              ? null
                              : S.of(context).username_error_message,
                          onSaved: (name) => username = name,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(Dimensions.marginStandard),
                        child: TextFormField(
                          obscureText: true,
                          key: Key('Password'),
                          decoration: InputStyles.inputDecoration(
                              S.of(context).password),
                          validator: (password) => password.trim().length > 4
                              ? null
                              : S.of(context).password_error_message,
                          onSaved: (pass) => password = pass,
                        ),
                      ),
                      if (state is RegistrationFailure)
                        Text(S.of(context).registration_error_message,
                            style: Styles.errorMessageTextStyle),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(Dimensions.marginStandard),
                        child: RaisedButton(
                            color: Colors.blueGrey,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                BlocProvider.of<RegistrationBloc>(context).add(
                                    RegisterUserEvent(
                                        username: username,
                                        password: password));
                              }
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.all(Dimensions.marginStandard),
                                child: Text(S.of(context).create_an_account,
                                    style: TextStyle(color: Colors.white)))),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
