import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../generated/i18n.dart';
import '../utils/widget_utils.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).team_go),
          ),
          body: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) => FullScreenProgress(
                    showProgress: state is LoginLoading,
                    child: SingleChildScrollView(
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: Dimensions.logoPadding),
                              child: FlutterLogo(size: Dimensions.logoSize),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.all(Dimensions.marginSmall),
                              child: Center(
                                  child: Text(
                                S.of(context).team_go_app,
                                style: Styles.titleTextStyle,
                              )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.all(Dimensions.marginSmall),
                              child: Center(
                                  child: Text(
                                S.of(context).login_to_the_app,
                                style: Styles.subtitleTextStyle,
                              )),
                            ),
                            Container(
                              padding: const EdgeInsets.all(
                                  Dimensions.marginStandard),
                              child: TextFormField(
                                key: Key('Username'),
                                controller: _loginController,
                                decoration: InputStyles.inputDecoration(
                                    S.of(context).username),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(
                                  Dimensions.marginStandard),
                              child: TextFormField(
                                key: Key('Password'),
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputStyles.inputDecoration(
                                    S.of(context).password),
                              ),
                            ),
                            if (state is LoginFailure)
                              Text(
                                S.of(context).login_error_message,
                                style: Styles.errorMessageTextStyle,
                              ),
                            Container(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.marginStandard),
                                child: RaisedButton(
                                    onPressed: () {
                                      BlocProvider.of<LoginBloc>(context).add(
                                          LogUser(_loginController.text,
                                              _passwordController.text));
                                    },
                                    color: Colors.blueGrey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.marginStandard),
                                      child: Text(
                                        S.of(context).login,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ),
                            ),
                            Container(
                                width: double.infinity,
                                child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.marginStandard),
                                    child: MaterialButton(
                                      onPressed: () {
                                        BlocProvider.of<LoginBloc>(context)
                                            .add(RegisterUser());
                                      },
                                      child: Text('Create an account'),
                                    )))
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
      );
}
