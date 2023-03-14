import 'package:flutter/material.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/domain/spot_type.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/widget/button/square_icon_button.dart';
import 'package:trip/widget/button/square_text_button.dart';
import 'package:trip/widget/network_image_widget.dart';

///
/// Created by jozuko on 2023/03/07.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotWidget extends StatefulWidget {
  final Spot? spot;
  final VoidCallback? onPressedEdit;
  final VoidCallback? onPressedRemove;
  final VoidCallback? onPressedMap;
  final VoidCallback? onPressedOpenWeb;

  const SpotWidget({
    super.key,
    required this.spot,
    this.onPressedEdit,
    this.onPressedRemove,
    this.onPressedMap,
    this.onPressedOpenWeb,
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
                        SquareIconButton(icon: Icons.edit_rounded, onPressed: widget.onPressedEdit),
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

  List<String> getDetails(Spot spot) {
    final details = <String>[];
    details.add(spot.name);
    if (spot.phone.isNotEmpty) {
      details.add(spot.phone);
    }
    if (spot.address.isNotEmpty) {
      details.add(spot.address);
    }
    if (spot.memo.isNotEmpty) {
      details.add(spot.memo);
    }

    return details;
  }

  Widget _buildSpot(BuildContext context, Spot spot) {
    final spotDetails = getDetails(spot);

    return SquareWidgetButton(
      onPressed: null,
      height: 180,
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
              color: TColors.white,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NetworkImageWidget(spot.imageUrl, size: 100),
                    const SizedBox(width: marginS),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: spotDetails.length,
                        itemBuilder: (context, index) {
                          final textStyle = index == 0 ? TextStyleEx.normalStyle(textColor: TColors.blackStrongText, isBold: true) : TextStyleEx.smallStyle();
                          return SelectableText(spotDetails[index], style: textStyle);
                        },
                      ),
                    ),
                    const SizedBox(width: marginS),
                  ],
                ),
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
                            SquareIconButton(icon: Icons.edit_rounded, onPressed: widget.onPressedEdit),
                            const SizedBox(width: marginS),
                            SquareIconButton(icon: Icons.remove_rounded, onPressed: widget.onPressedRemove),
                            const SizedBox(width: marginS),
                            SquareIconButton(icon: Icons.map_rounded, onPressed: widget.onPressedMap),
                            const SizedBox(width: marginS),
                            SquareIconButton(icon: Icons.public_rounded, onPressed: widget.onPressedOpenWeb),
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
