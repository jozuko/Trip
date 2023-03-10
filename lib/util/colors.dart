import 'package:flutter/material.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class TColors {
  TColors._();

  static const Color transparent = Colors.transparent;

  static const Color black = Color(0xFF333333);
  static const Color black25 = Color(0x40333333);
  static const Color black50 = Color(0xF7333333);
  static const Color black75 = Color(0xBF333333);

  static const Color white = Color(0xFFFEFFFF);
  static const Color white25 = Color(0x40FEFFFF);
  static const Color white50 = Color(0xF7FEFFFF);
  static const Color white75 = Color(0xBFFEFFFF);

  static const Color lightGray = Color(0xFFE2E2E2);
  static const Color darkGray = Color(0xFF707070);

  static const Color blackText = darkGray;
  static const Color blackStrongText = black;
  static const Color whiteText = white;

  static const Color appBack = white;

  static const Color blackButtonBack = darkGray;
  static const Color blackButtonText = whiteText;
  static const Color blackButtonBorder = blackButtonBack;
  static const Color blackButtonInk = whiteText;
  static const Color blackButtonBarrierBack = white50;
  static const Color blackButtonBarrierText = darkGray;

  static const Color whiteButtonBack = white;
  static const Color whiteButtonText = blackText;
  static const Color whiteButtonBorder = darkGray;
  static const Color whiteButtonInk = blackText;
  static const Color whiteButtonBarrierBack = black50;
  static const Color whiteButtonBarrierText = white;

  static const Color titleBackground = Color(0xFFF7F7F7);
  static const Color titleForeground = darkGray;

  static const Color spotKankoBackground = Color(0xFFD1FED0);
  static const Color spotOnsenBackground = Color(0xFFFED0D0);
  static const Color spotStayBackground = Color(0xFFD4D0FE);
}
