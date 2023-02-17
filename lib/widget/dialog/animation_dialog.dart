import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
Future<T?> showAnimatedDialog<T extends Object?>({
  required BuildContext context,
  bool useRootNavigator = false,
  bool barrierDismissible = false,
  Color barrierColor = TColors.black50,
  required WidgetBuilder builder,
  int durationMillis = 300,
  Alignment alignment = Alignment.center,
  Axis? axis = Axis.horizontal,
}) {
  final ThemeData theme = Theme.of(context);

  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        top: false,
        child: Builder(builder: (BuildContext context) {
          return Theme(data: theme, child: pageChild);
        }),
      );
    },
    useRootNavigator: useRootNavigator,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    transitionDuration: Duration(milliseconds: durationMillis),
    transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        transformHitTests: false,
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.linear)).animate(animation),
        child: child,
      );
    },
  );
}
