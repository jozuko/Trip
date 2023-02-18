import 'package:flutter/material.dart';
import 'package:trip/widget/dialog/animation_dialog.dart';
import 'package:trip/widget/dialog/default_dialog.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
abstract class BaseState<T extends StatefulWidget> extends State<T> {
  Future<void> showMessage(String? message, {VoidCallback? callback}) async {
    if (message == null) {
      return;
    }

    showAnimatedDialog(
      context: context,
      builder: (_) {
        return DefaultDialog(
          text: message,
          onPressedButton: (canceled) {
            Navigator.pop(context);
          },
        );
      },
    ).then((value) {
      callback?.call();
    });
  }
}
