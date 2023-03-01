import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/main/home_bloc.dart';
import 'package:trip/widget/button/square_icon_button.dart';
import 'package:trip/widget/title_bar.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends BaseState<HomePage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<HomeBloc>(context).add(HomeInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildTitle(),
            Padding(
              padding: const EdgeInsets.all(margin),
              child: Column(
                children: [
                  _buildListTitle(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitle() {
    return TitleBar(
      rightButton: Icons.settings_outlined,
      onTapRightIcon: _onTapSettings,
    );
  }

  Widget _buildListTitle() {
    return Row(
      children: [
        Text('計画一覧', style: TextStyleEx.normalStyle(isBold: true)),
        const Spacer(),
        SquareIconButton.transparent(
          Icons.add_circle_outline_rounded,
          onPressed: () {},
        ),
      ],
    );
  }

  void _onTapSettings() {
    // TODO open settings
  }
}
