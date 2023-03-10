import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/view/init/application_bloc.dart';
import 'package:trip/view/init/init_page.dart';
import 'package:trip/view/main/home_page.dart';
import 'package:trip/view/receive_share/receive_share_page.dart';
import 'package:trip/view/signin/signin_page.dart';

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
  @override
  void initState() {
    super.initState();

    BlocProvider.of<ApplicationBloc>(context).add(ApplicationInitEvent());
  }

  @override
  void dispose() {
    BlocProvider.of<ApplicationBloc>(context).dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplicationBloc, ApplicationState>(
      listener: (context, state) {
        if (state.sharedText.isNotEmpty) {
          TripLog.d('_ReceiveShareState::build ReceiveSharePage');
          _moveToReceiveSharePage(state);
        }
      },
      builder: (context, state) {
        TripLog.d("ApplicationPage::build !! $state");
        Widget child;

        if (state.initialized) {
          if (state.signedIn) {
            child = HomePage.newPage();
          } else {
            child = SignInPage.newPage();
          }
        } else {
          child = InitPage.newPage();
        }
        TripLog.d('_ReceiveShareState::build $child');

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

  void _moveToReceiveSharePage(ApplicationState state) {
    Navigator.of(context).push(ReceiveSharePage.routePage(sharedText: state.sharedText));
  }
}
