import 'package:flutter/cupertino.dart';
import 'package:trip/util/colors.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class TitleBar extends StatelessWidget {
  static const _titleSize = 18.0;
  final String title;
  final IconData? leadingIcon;
  final Color leadingIconColor = TColors.titleForeground;
  final VoidCallback? onTapLeadingIcon;
  final IconData? rightButton;
  final VoidCallback? onTapRightIcon;

  const TitleBar({
    super.key,
    required this.title,
    this.leadingIcon,
    this.onTapLeadingIcon,
    this.rightButton,
    this.onTapRightIcon,
  });

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
      style: const TextStyle(
        color: TColors.titleForeground,
        fontSize: _titleSize,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget? _buildLeadingIcon() {
    final leadingIcon = this.leadingIcon;
    if (leadingIcon == null) {
      return null;
    }

    final iconWidget = Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
      child: Icon(
        leadingIcon,
        size: 40.0,
        color: leadingIconColor,
      ),
    );
    if (onTapLeadingIcon == null) {
      return iconWidget;
    } else {
      return GestureDetector(
        onTap: onTapLeadingIcon,
        child: iconWidget,
      );
    }
  }

  Widget? _buildRightIcon() {
    final rightButton = this.rightButton;
    if (rightButton == null) {
      return null;
    }

    final iconWidget = Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Icon(
          rightButton,
          size: 40.0,
          color: leadingIconColor,
        ),
      ),
    );
    if (onTapRightIcon == null) {
      return iconWidget;
    } else {
      return GestureDetector(
        onTap: onTapRightIcon,
        child: iconWidget,
      );
    }
  }
}
