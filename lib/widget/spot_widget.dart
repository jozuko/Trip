import 'package:flutter/material.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/domain/spot_type.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/widget/button/square_icon_button.dart';
import 'package:trip/widget/button/square_text_button.dart';

///
/// Created by jozuko on 2023/03/07.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotWidget extends StatefulWidget {
  final Spot? spot;
  final VoidCallback? onPressEdit;
  final VoidCallback? onPressRemove;
  final VoidCallback? onPressOpenWeb;
  final VoidCallback? onPressLink;

  const SpotWidget({
    super.key,
    required this.spot,
    this.onPressEdit,
    this.onPressRemove,
    this.onPressOpenWeb,
    this.onPressLink,
  });

  @override
  State<StatefulWidget> createState() {
    return _SpotState();
  }
}

class _SpotState extends BaseState<SpotWidget> {
  @override
  Widget build(BuildContext context) {
    final spot = widget.spot;
    if (spot == null) {
      return _buildEmptySpot(context);
    } else {
      return _buildSpot(context, spot);
    }
  }

  Widget _buildEmptySpot(BuildContext context) {
    return SquareWidgetButton(
      onPressed: null,
      height: 160,
      radius: 10,
      width: double.infinity,
      backgroundColor: TColors.white,
      borderColor: TColors.whiteButtonBorder,
      showBarrier: false,
      showBorder: true,
      child: Column(
        children: [
          Container(height: 100),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SquareIconButton(icon: Icons.edit_rounded, onPressed: widget.onPressEdit),
                        const SizedBox(width: marginS),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpot(BuildContext context, Spot spot) {
    return SquareWidgetButton(
      onPressed: null,
      height: 160,
      radius: 10,
      width: double.infinity,
      backgroundColor: spot.spotType.backgroundColor,
      borderColor: TColors.whiteButtonBorder,
      showBarrier: false,
      showBorder: true,
      inkColor: TColors.whiteButtonInk,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              spot.spotType.assetsIconName,
              width: 120,
              height: 120,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  // TODO URLから画像を取得するWidgetが必要
                  Container(
                    color: TColors.lightGray,
                    height: 100,
                    width: 100,
                    child: const Icon(
                      Icons.photo,
                      size: 48,
                      color: TColors.darkGray,
                    ),
                  ),
                  const SizedBox(width: marginS),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSingleLineText(spot.name ?? "", style: TextStyleEx.normalStyle(textColor: TColors.blackStrongText, isBold: true)),
                        _buildSingleLineText(spot.phone ?? "", style: TextStyleEx.smallStyle(textColor: TColors.blackText, isBold: false)),
                        _buildSingleLineText(spot.address ?? "", style: TextStyleEx.smallStyle(textColor: TColors.blackText, isBold: false)),
                      ],
                    ),
                  ),
                  const SizedBox(width: marginS),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(width: marginS),
                    Text("滞在", style: TextStyleEx.smallStyle(textColor: TColors.blackText, isBold: false)),
                    _buildStayTimeText(spot.stayTime),
                    Text("分", style: TextStyleEx.smallStyle(textColor: TColors.blackText, isBold: false)),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SquareIconButton(icon: Icons.edit_rounded, onPressed: widget.onPressEdit),
                            const SizedBox(width: marginS),
                            SquareIconButton(icon: Icons.remove_rounded, onPressed: widget.onPressRemove),
                            const SizedBox(width: marginS),
                            SquareIconButton(icon: Icons.public_rounded, onPressed: widget.onPressOpenWeb),
                            const SizedBox(width: marginS),
                            SquareIconButton(icon: Icons.link_rounded, onPressed: widget.onPressLink),
                            const SizedBox(width: marginS),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleLineText(String label, {required TextStyle style}) {
    return Text(
      label,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStayTimeText(int stayTime) {
    return Container(
      width: 48,
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: TColors.black))),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          "$stayTime",
          style: TextStyleEx.normalStyle(textColor: TColors.blackStrongText, isBold: true),
        ),
      ),
    );
  }
}
