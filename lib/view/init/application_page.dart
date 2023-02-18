import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/string_ex.dart';
import 'package:trip/view/init/application_bloc.dart';
import 'package:trip/view/init/init_page.dart';
import 'package:trip/view/main/home_page.dart';
import 'package:trip/view/receive_share/receive_share_bloc.dart';
import 'package:trip/view/receive_share/receive_share_page.dart';
import 'package:trip/view/signin/signin_page.dart';
import 'package:trip/view/signin/singin_bloc.dart';

///
/// Created by jozuko on 2023/02/16.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class ApplicationPage extends StatefulWidget {
  const ApplicationPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _ApplicationState();
  }
}

class _ApplicationState extends State<ApplicationPage> {
  StreamSubscription? _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
      BlocProvider.of<ApplicationBloc>(context).add(ApplicationReceiveSharedUrlEvent(sharedText: value));
    }, onError: (err) {
      TripLog.e("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value.nullToEmpty.isNotEmpty) {
        BlocProvider.of<ApplicationBloc>(context).add(ApplicationReceiveSharedUrlEvent(sharedText: value!));
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, state) {
        TripLog.d("ApplicationPage::build !! $state");
        Widget child;

        if (state.sharedText.isNotEmpty) {
          child = BlocProvider(
            create: (context) => ReceiveShareBloc(url: state.sharedText)..add(ReceiveShareUrlEvent()),
            child: const ReceiveSharePage(),
          );
        } else {
          if (state.initialized) {
            if (state.signedIn) {
              child = const HomePage();
            } else {
              child = BlocProvider(
                create: (context) => SignInBloc(),
                child: const SignInPage(),
              );
            }
          } else {
            child = const InitPage();
          }
        }

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
      },
    );
  }
}
