import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/main/account_bloc.dart';
import 'package:trip/widget/title_bar.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class AccountPage extends StatefulWidget {
  static Route routePage({Key? key}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => AccountBloc(),
        child: AccountPage(key: key),
      ),
    );
  }

  const AccountPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AccountState();
  }
}

class _AccountState extends BaseState<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return buildRootPage(
          child: Column(
            children: [
              _buildTitle(),
              Padding(
                padding: const EdgeInsets.all(margin),
                child: Column(
                  children: [
                    Text(
                      'ニックネームの編集とサインアウト',
                      style: TextStyleEx.normalStyle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return TitleBar(
      isBack: true,
      onTapLeadingIcon: _onBackPress,
    );
  }

  void _onBackPress() {
    Navigator.pop(context);
  }
}
