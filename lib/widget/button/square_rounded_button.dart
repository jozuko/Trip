import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';

///
/// Custom Button
/// - background: white
/// - edges: round
/// - only text
///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SquareRoundedButton extends StatelessWidget {
  static const _buttonHeight = 60.0;

  final VoidCallback? onPressed;
  final Widget child;
  final Widget? barrierChild;

  final double? width;
  final double height;
  final double? radius;

  final bool showBarrier;
  final bool showBorder;

  final Color backgroundColor;
  final Color borderColor;
  final Color inkColor;
  final Color barrierColor;

  const SquareRoundedButton({
    super.key,
    this.onPressed,
    required this.child,
    this.barrierChild,
    this.width,
    this.height = _buttonHeight,
    this.radius,
    this.showBarrier = false,
    this.showBorder = false,
    this.backgroundColor = TColors.blackButtonBack,
    this.inkColor = TColors.blackButtonInk,
    this.borderColor = TColors.blackButtonBorder,
    this.barrierColor = TColors.blackButtonBarrierBack,
  });

  @override
  Widget build(BuildContext context) {
    final radius = this.radius ?? height / 4;

    if (showBarrier) {
      return _buildBarrierButton(radius);
    } else {
      return _buildButton(radius);
    }
  }

  Widget _buildButton(double radius) {
    return _buildBase(
      radius,
      Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onPressed,
          splashColor: inkColor,
          child: child,
        ),
      ),
    );
  }

  Widget _buildBarrierButton(double radius) {
    return Stack(
      children: [
        _buildContent(radius),
        _buildBarrier(radius),
      ],
    );
  }

  Widget _buildContent(double radius) {
    return _buildBase(radius, child);
  }

  Widget _buildBase(double radius, Widget child) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      foregroundDecoration: BoxDecoration(
        border: showBorder ? Border.all(color: borderColor) : null,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: child,
    );
  }

  Widget _buildBarrier(double radius) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: barrierColor,
        border: showBorder ? Border.all(color: borderColor) : null,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: barrierChild,
    );
  }
}
