import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/string_ex.dart';
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

  Widget buildImage(String? url, {double size = 100}) {
    Widget child;
    if (url.nullToEmpty.isEmpty) {
      child = Center(
        child: Icon(
          Icons.photo,
          size: size / 2,
          color: TColors.darkGray,
        ),
      );
    } else {
      child = Image.network(
        url!,
        fit: BoxFit.fill,
      );
    }

    return Container(
      color: TColors.lightGray,
      height: size,
      width: size,
      child: child,
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
