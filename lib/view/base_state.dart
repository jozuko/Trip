import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/widget/dialog/animation_dialog.dart';
import 'package:trip/widget/dialog/default_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> showConfirm({
    required String message,
    String okLabel = 'OK',
    String cancelLabel = 'キャンセル',
    required Function(bool canceled) callback,
  }) async {
    showAnimatedDialog<bool>(
      context: context,
      builder: (_) {
        return DefaultDialog(
          text: message,
          okLabel: okLabel,
          cancelLabel: cancelLabel,
          showCancel: true,
          onPressedButton: (canceled) {
            Navigator.pop(context, canceled);
          },
        );
      },
    ).then((canceled) {
      if (canceled == true) {
        callback.call(true);
      } else {
        callback.call(false);
      }
    });
  }

  Widget buildRootPage({required Widget child}) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Container(
          color: TColors.appBack,
          child: SafeArea(
            child: child,
          ),
        ),
      ),
    );
  }

  Future<void> openGoogleMapsApp([Location location = Location.def]) async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'geo:${location.latitude},${location.longitude}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } else {
      url = 'comgooglemaps://?saddr=&daddr=${location.latitude},${location.longitude}&directionsmode=driving';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}
