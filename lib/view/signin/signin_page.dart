import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:trip/util/global.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/init/application_bloc.dart';
import 'package:trip/view/signin/singin_bloc.dart';
import 'package:trip/view/signin/singin_mail_bloc.dart';
import 'package:trip/view/signin/singin_mail_page.dart';
import 'package:trip/widget/loading.dart';
import 'package:trip/widget/title_bar.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends BaseState<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) async {
        if (state.message.isNotEmpty) {
          showMessage(state.message, callback: () {
            context.read<SignInMailBloc>().add(SignInMailClearMessageEvent());
          });
        }

        if (state.isDoneAuth) {
          BlocProvider.of<ApplicationBloc>(context).add(ApplicationCheckAuthEvent());
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildTitleBar(),
                Padding(
                  padding: const EdgeInsets.all(margin),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SignInButton(Buttons.email, onPressed: _onTapEmail),
                      SignInButton(Buttons.google, onPressed: _onTapGoogle),
                      if (Platform.isIOS) SignInButton(Buttons.apple, onPressed: _onTapApple),
                    ],
                  ),
                ),
              ],
            ),
            LoadingWidget(visible: state.isLoading),
          ],
        );
      },
    );
  }

  Widget _buildTitleBar() {
    return const TitleBar(title: '旅行プラン作成アプリ');
  }

  void _onTapEmail() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => SignInMailBloc(),
          child: const SignInMailPage(),
        ),
      ),
    );
  }

  void _onTapGoogle() {
    BlocProvider.of<SignInBloc>(context).add(SignInGoogleEvent());
  }

  void _onTapApple() {
    BlocProvider.of<SignInBloc>(context).add(SignInAppleEvent());
  }
}
