import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/view/init/application_bloc.dart';
import 'package:trip/view/signin/singin_mail_bloc.dart';
import 'package:trip/widget/button/square_rounded_button.dart';
import 'package:trip/widget/dialog/animation_dialog.dart';
import 'package:trip/widget/dialog/default_dialog.dart';
import 'package:trip/widget/field/email_field.dart';
import 'package:trip/widget/field/password_field.dart';
import 'package:trip/widget/title_bar.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SignInMailPage extends StatefulWidget {
  const SignInMailPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignInMailState();
  }
}

class _SignInMailState extends State<SignInMailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInMailBloc, SignInMailState>(
      listener: (context, state) async {
        if (state.message.isNotEmpty) {
          _showMessage(state.message);
        }

        if (state.isDoneAuth) {
          BlocProvider.of<ApplicationBloc>(context).add(ApplicationCheckAuthEvent());
        } else {
          BlocProvider.of<ApplicationBloc>(context).add(ApplicationChangeLoadingEvent(isLoading: state.isLoading));
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            return !state.isLoading;
          },
          child: Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: TColors.appBack,
                    ),
                    child: Column(
                      children: [
                        _buildTitleBar(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(margin),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  EmailField(
                                    initialValue: state.email,
                                    errorText: state.errorEmail,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (value) {
                                      context.read<SignInMailBloc>().add(SignInMailEmailChangedEvent(email: value));
                                    },
                                  ),
                                  const SizedBox(height: margin),
                                  PasswordField(
                                      labelText: 'パスワード',
                                      obscureText: state.obscurePassword,
                                      initialValue: state.password,
                                      errorText: state.errorPassword,
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) {
                                        context.read<SignInMailBloc>().add(SignInMailPasswordChangedEvent(password: value));
                                      },
                                      onPressIcon: () {
                                        context.read<SignInMailBloc>().add(SignInMailPasswordChangeObscureEvent());
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: margin),
                        SquareRoundedButton(
                          width: 290,
                          height: 40,
                          backgroundColor: TColors.blackButtonBack,
                          inkColor: TColors.blackButtonInk,
                          showBarrier: false,
                          showBorder: false,
                          onPressed: _onClickSignIn,
                          child: const Center(
                            child: Text(
                              'ログイン',
                              style: TextStyle(color: TColors.blackButtonText, fontSize: fontSize3, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: margin),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleBar() {
    return const TitleBar(title: 'メールアドレス認証');
  }

  void _onClickSignIn() {
    primaryFocus?.unfocus();
    BlocProvider.of<SignInMailBloc>(context).add(SignInMailSubmitEvent());
  }

  Future<void> _showMessage(String? message) async {
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
      context.read<SignInMailBloc>().add(SignInMailClearMessageEvent());
    });
  }
}
