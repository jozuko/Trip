import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
extension TextStyleEx on TextStyle {
  static const double fontSize1 = 24.0;
  static const double fontSize2 = 18.0;
  static const double fontSize3 = 16.0;
  static const double fontSize4 = 14.0;

  static TextStyle titleStyle({
    Color textColor = TColors.titleForeground,
    bool isBold = false,
  }) {
    return TextStyle(
      fontSize: fontSize1,
      color: textColor,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle largeStyle({
    Color textColor = TColors.darkGray,
    bool isBold = false,
  }) {
    return TextStyle(
      fontSize: fontSize2,
      color: textColor,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle normalStyle({
    Color textColor = TColors.darkGray,
    bool isBold = false,
  }) {
    return TextStyle(
      fontSize: fontSize3,
      color: textColor,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle smallStyle({
    Color textColor = TColors.darkGray,
    bool isBold = false,
  }) {
    return TextStyle(
      fontSize: fontSize4,
      color: textColor,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
  }
}
