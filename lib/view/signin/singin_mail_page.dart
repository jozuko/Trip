import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/util/global.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/init/application_bloc.dart';
import 'package:trip/view/signin/singin_mail_bloc.dart';
import 'package:trip/widget/button/square_text_button.dart';
import 'package:trip/widget/field/email_field.dart';
import 'package:trip/widget/field/password_field.dart';
import 'package:trip/widget/loading.dart';
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

class _SignInMailState extends BaseState<SignInMailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInMailBloc, SignInMailState>(
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
        return WillPopScope(
          onWillPop: () async {
            return !state.isLoading;
          },
          child: Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
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
                                  value: state.email,
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
                      Padding(
                        padding: const EdgeInsets.all(margin),
                        child: SquareTextButton.blackButton('ログイン', onPressed: _onClickSignIn),
                      ),
                    ],
                  ),
                  LoadingWidget(visible: state.isLoading),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleBar() {
    return TitleBar(
      title: 'メールアドレス認証',
      isBack: true,
      onTapLeadingIcon: () {
        Navigator.pop(context);
      },
    );
  }

  void _onClickSignIn() {
    primaryFocus?.unfocus();
    BlocProvider.of<SignInMailBloc>(context).add(SignInMailSubmitEvent());
  }
}
