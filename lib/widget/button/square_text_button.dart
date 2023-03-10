import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/text_style_ex.dart';

///
/// Custom Button
/// - background: white
/// - edges: round
/// - only text
///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SquareWidgetButton extends StatelessWidget {
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

  const SquareWidgetButton({
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

  static SquareWidgetButton blackButton(
    String label, {
    double? width,
    double height = 40,
    double? radius,
    VoidCallback? onPressed,
  }) {
    return SquareWidgetButton(
      width: width,
      height: height,
      radius: radius,
      backgroundColor: TColors.blackButtonBack,
      inkColor: TColors.blackButtonInk,
      showBarrier: false,
      showBorder: false,
      onPressed: onPressed,
      child: Center(
        child: Text(
          label,
          style: TextStyleEx.normalStyle(textColor: TColors.blackButtonText, isBold: true),
        ),
      ),
    );
  }

  static SquareWidgetButton whiteButton(
    String label, {
    double? width,
    double height = 40,
    double? radius,
    VoidCallback? onPressed,
  }) {
    return whiteWidgetButton(
      child: Center(
        child: Text(
          label,
          style: TextStyleEx.normalStyle(textColor: TColors.whiteButtonText, isBold: false),
        ),
      ),
      width: width,
      height: height,
      radius: radius,
      onPressed: onPressed,
    );
  }

  static SquareWidgetButton whiteWidgetButton({
    required Widget child,
    double? width,
    double height = 40,
    double? radius,
    VoidCallback? onPressed,
  }) {
    return SquareWidgetButton(
      width: width,
      height: height,
      radius: radius,
      backgroundColor: TColors.whiteButtonBack,
      inkColor: TColors.whiteButtonInk,
      borderColor: TColors.whiteButtonBorder,
      showBarrier: false,
      showBorder: true,
      onPressed: onPressed,
      child: child,
    );
  }
}
