import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/view/signin/singin_mail_bloc.dart';
import 'package:trip/view/signin/singin_mail_page.dart';
import 'package:trip/widget/button/square_rounded_button.dart';
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

class _SignInState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildTitleBar(),
        Padding(
          padding: const EdgeInsets.all(margin),
          child: _buildMailProvider(),
        ),
      ],
    );
  }

  Widget _buildTitleBar() {
    return const TitleBar(title: '旅行プラン作成アプリ');
  }

  Widget _buildMailProvider() {
    return SquareRoundedButton(
      onPressed: onTapMailProvider,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.mail,
              size: 40.0,
              color: TColors.white,
            ),
            SizedBox(
              width: marginS,
            ),
            Text(
              'メールアドレスで認証',
              style: TextStyle(
                fontSize: fontSize3,
                fontWeight: FontWeight.bold,
                color: TColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapMailProvider() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => SignInMailBloc(),
          child: const SignInMailPage(),
        ),
      ),
    );
  }
}
