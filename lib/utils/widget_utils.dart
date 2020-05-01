import 'package:flutter/material.dart';

class FullScreenProgress extends StatelessWidget {
  const FullScreenProgress({Key key, this.showProgress, this.child})
      : super(key: key);

  final bool showProgress;
  final Widget child;

  @override
  Widget build(BuildContext context) => showProgress
      ? Stack(
          children: <Widget>[
            child,
            Opacity(
              opacity: 0.5,
              child: ModalBarrier(
                dismissible: false,
                color: Colors.black,
              ),
            ),
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        )
      : child;
}
