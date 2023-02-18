import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/receive_share/receive_share_bloc.dart';
import 'package:trip/widget/button/square_rounded_button.dart';
import 'package:trip/widget/field/single_line_field.dart';
import 'package:trip/widget/title_bar.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class ReceiveSharePage extends StatefulWidget {
  const ReceiveSharePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ReceiveShareState();
  }
}

class _ReceiveShareState extends BaseState<ReceiveSharePage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiveShareBloc, ReceiveShareState>(
      listener: (context, state) async {
        changeLoading(state.isLoading);
      },
      builder: (context, state) {
        TripLog.d("ReceiveSharePage::build ${state.analyzedUrl?.url}");

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildTitleBar(),
            Padding(
              padding: const EdgeInsets.all(margin),
              child: Center(
                child: Column(
                  children: [
                    SingleLineField(
                      labelText: 'タイトル',
                      hintText: 'ブックマークタイトル',
                      value: state.analyzedUrl?.title,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        context.read<ReceiveShareBloc>().add(ReceiveShareChangeTitleEvent(title: value));
                      },
                    ),
                    SingleLineField(
                      labelText: 'URL',
                      hintText: 'https://***',
                      value: state.analyzedUrl?.url,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        context.read<ReceiveShareBloc>().add(ReceiveShareChangeUrlEvent(url: value));
                      },
                    ),
                    SquareRoundedButton(
                      width: 200,
                      height: 40,
                      radius: 40 / 2,
                      backgroundColor: TColors.blackButtonBack,
                      inkColor: TColors.blackButtonInk,
                      showBarrier: false,
                      showBorder: false,
                      onPressed: () {
                        _onPressedAdd();
                      },
                      child: const Center(
                        child: Text(
                          'ブックマークを追加',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: TColors.blackButtonText),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleBar() {
    return const TitleBar(title: '旅行プラン作成アプリ');
  }

  void _onPressedAdd() {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
