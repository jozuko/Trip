import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/widget/button/square_icon_button.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class TitleBar extends StatelessWidget {
  static const _defaultHeight = 60.0;

  final String title;
  final IconData? leadingIcon;
  final Color leadingIconColor = TColors.titleForeground;
  final VoidCallback? onTapLeadingIcon;
  final IconData? rightButton;
  final VoidCallback? onTapRightIcon;

  const TitleBar({
    super.key,
    this.title = appName,
    bool isBack = false,
    this.onTapLeadingIcon,
    this.rightButton,
    this.onTapRightIcon,
  }) : leadingIcon = isBack ? Icons.arrow_back_ios_new_rounded : null;

  @override
  Widget build(BuildContext context) {
    final contents = <Widget>[];

    final leadingIconWidget = _buildLeadingIcon();
    if (leadingIconWidget != null) {
      contents.add(leadingIconWidget);
    }

    final titleWidget = _buildTitle();
    contents.add(Center(child: titleWidget));

    final rightIconWidget = _buildRightIcon();
    if (rightIconWidget != null) {
      contents.add(rightIconWidget);
    }

    return Container(
      color: TColors.titleBackground,
      height: 60.0,
      child: Stack(
        children: contents,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: TextStyleEx.titleStyle(),
    );
  }

  Widget? _buildLeadingIcon() {
    final leadingIcon = this.leadingIcon;
    if (leadingIcon == null) {
      return null;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: SquareIconButton.transparent(
        leadingIcon,
        size: _defaultHeight - marginS,
        iconColor: leadingIconColor,
        onPressed: onTapLeadingIcon,
      ),
    );
  }

  Widget? _buildRightIcon() {
    final rightButton = this.rightButton;
    if (rightButton == null) {
      return null;
    }

    return Align(
      alignment: Alignment.centerRight,
      child: SquareIconButton.transparent(
        rightButton,
        size: _defaultHeight - marginS,
        iconColor: leadingIconColor,
        onPressed: onTapRightIcon,
      ),
    );
  }
}
