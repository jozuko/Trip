import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/view/init/application_bloc.dart';
import 'package:trip/view/init/init_page.dart';
import 'package:trip/view/main/home_page.dart';
import 'package:trip/view/receive_share/receive_share_bloc.dart';
import 'package:trip/view/receive_share/receive_share_page.dart';
import 'package:trip/view/signin/signin_page.dart';
import 'package:trip/view/signin/singin_bloc.dart';
import 'package:trip/widget/loading.dart';

///
/// Created by jozuko on 2023/02/16.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
enum _ApplicationPageType {
  init,
  sign,
  receiveShare,
  home,
}

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
  _ApplicationPageType _selectedPageType = _ApplicationPageType.init;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [];
  final List<RouteObserver<PageRoute>> _routeObservers = [];
  final Map<_ApplicationPageType, Widget> _pages = {};

  final ReceiveShareBloc _receiveShareBloc = ReceiveShareBloc();
  StreamSubscription? _intentDataStreamSubscription;
  String? _sharedText;

  _ApplicationState() : super() {
    for (var page in _ApplicationPageType.values) {
      final globalKey = GlobalKey<NavigatorState>();
      _navigatorKeys.add(globalKey);

      final routeObserver = RouteObserver<PageRoute>();
      _routeObservers.add(routeObserver);

      switch (page) {
        case _ApplicationPageType.init:
          _pages[page] = const InitPage();
          break;
        case _ApplicationPageType.sign:
          _pages[page] = BlocProvider(create: (context) => SignInBloc(), child: const SignInPage());
          break;
        case _ApplicationPageType.receiveShare:
          _pages[page] = BlocProvider(create: (context) => _receiveShareBloc, child: const ReceiveSharePage());
          break;
        case _ApplicationPageType.home:
          _pages[page] = const HomePage();
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
      });
    }, onError: (err) {
      TripLog.e("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        _sharedText = value;
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'NotoSansJP',
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      home: BlocBuilder<ApplicationBloc, ApplicationState>(
        builder: (context, state) {
          if (_sharedText != null && _sharedText?.isNotEmpty == true) {
            _receiveShareBloc.add(ReceiveShareUrlEvent(url: _sharedText!));
            _selectedPageType = _ApplicationPageType.receiveShare;
          } else {
            if (!state.initialized) {
              _selectedPageType = _ApplicationPageType.init;
            } else if (!state.signedIn) {
              _selectedPageType = _ApplicationPageType.sign;
            } else {
              _selectedPageType = _ApplicationPageType.home;
            }
          }

          return WillPopScope(
            onWillPop: () async {
              return _canPop(state);
            },
            child: Stack(
              children: [
                Scaffold(
                  body: SafeArea(
                    child: _buildContents(),
                  ),
                ),
                LoadingWidget(visible: state.isLoading),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> _canPop(ApplicationState state) async {
    if (state.isLoading) {
      return false;
    }

    final currentKeyState = _navigatorKeys[_selectedPageType.index].currentState;
    if (currentKeyState?.canPop() == true) {
      return await currentKeyState?.maybePop() == false;
    }

    return true;
  }

  Widget _buildContents() {
    final pageContents = <Widget>[];
    for (var page in _ApplicationPageType.values) {
      pageContents.add(
        Navigator(
          key: _navigatorKeys[page.index],
          observers: [_routeObservers[page.index]],
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                return _pages[page] ?? Container();
              },
            );
          },
        ),
      );
    }

    return IndexedStack(
      index: _selectedPageType.index,
      children: pageContents,
    );
  }
}
