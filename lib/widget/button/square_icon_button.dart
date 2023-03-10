import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SquareIconButton extends StatelessWidget {
  static const _defaultSize = 40.0;
  static const _defaultRadius = 10.0;

  final IconData icon;
  final double size;
  final double radius;

  final bool showBorder;

  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color inkColor;

  final VoidCallback? onPressed;

  const SquareIconButton({
    super.key,
    required this.icon,
    this.size = _defaultSize,
    this.radius = _defaultRadius,
    this.showBorder = false,
    this.iconColor = TColors.blackButtonText,
    this.backgroundColor = TColors.blackButtonBack,
    this.inkColor = TColors.blackButtonInk,
    this.borderColor = TColors.blackButtonBorder,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onPressed,
          splashColor: inkColor,
          child: Icon(
            icon,
            size: (size - marginS),
            color: iconColor,
          ),
        ),
      ),
    );
  }

  static SquareIconButton transparent(
    IconData icon, {
    double size = _defaultSize,
    Color iconColor = TColors.darkGray,
    VoidCallback? onPressed,
  }) {
    return SquareIconButton(
      icon: icon,
      size: size,
      iconColor: iconColor,
      backgroundColor: TColors.transparent,
      onPressed: onPressed,
    );
  }
}
