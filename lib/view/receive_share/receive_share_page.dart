import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/receive_share/receive_share_bloc.dart';
import 'package:trip/widget/field/single_line_field.dart';
import 'package:trip/widget/loading.dart';
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
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    TripLog.d('_ReceiveShareState::initState call analyze');
    BlocProvider.of<ReceiveShareBloc>(context).add(ReceiveShareInitEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiveShareBloc, ReceiveShareBaseState>(
      listener: (context, state) {
        if (state is ReceiveShareDoneState) {
          _onPressedBack();
        }
      },
      builder: (context, state) {
        if (state is ReceiveShareState) {
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildTitleBar(),
                  Padding(
                    padding: const EdgeInsets.all(margin),
                    child: _buildContents(state),
                  ),
                ],
              ),
              LoadingWidget(visible: state.isLoading),
            ],
          );
        } else {
          return Container(
            color: TColors.appBack,
          );
        }
      },
    );
  }

  Widget _buildTitleBar() {
    if (Platform.isAndroid) {
      return TitleBar(
        title: 'URLを追加',
        isBack: true,
        onTapLeadingIcon: _onPressedBack,
        rightButton: Icons.send,
        onTapRightIcon: _onPressedAdd,
      );
    } else {
      return TitleBar(
        title: 'URLを追加',
        rightButton: Icons.send,
        onTapRightIcon: _onPressedAdd,
      );
    }
  }

  Widget _buildContents(ReceiveShareState state) {
    if (!state.initialized) {
      _titleController.text = state.bookmark.title;
      _titleController.value = _titleController.value.copyWith(selection: TextSelection(baseOffset: state.bookmark.title.length, extentOffset: state.bookmark.title.length));

      _urlController.text = state.bookmark.url;
      _urlController.value = _urlController.value.copyWith(selection: TextSelection(baseOffset: state.bookmark.url.length, extentOffset: state.bookmark.url.length));
    }

    return Column(
      children: [
        SingleLineField(
          labelText: 'タイトル',
          hintText: 'ブックマークタイトル',
          controller: _titleController,
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            context.read<ReceiveShareBloc>().add(ReceiveShareChangeTitleEvent(title: value));
          },
        ),
        SingleLineField(
          labelText: 'URL',
          hintText: 'https://***',
          controller: _urlController,
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            context.read<ReceiveShareBloc>().add(ReceiveShareChangeUrlEvent(url: value));
          },
        ),
      ],
    );
  }

  void _onPressedBack() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    }
  }

  void _onPressedAdd() {
    context.read<ReceiveShareBloc>().add(ReceiveShareAddBookmarkEvent());
  }
}
