import 'package:flutter/material.dart';
import 'package:trip/domain/bookmark.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/widget/button/square_text_button.dart';

///
/// Created by jozuko on 2023/03/07.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class BookmarkWidget extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback? onPressed;

  const BookmarkWidget({
    super.key,
    required this.bookmark,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SquareWidgetButton.whiteWidgetButton(
      onPressed: onPressed,
      height: 100,
      radius: 10,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            color: TColors.lightGray,
            height: 100,
            width: 100,
            child: _buildImage(),
          ),
          const SizedBox(width: marginS),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSingleLineText(bookmark.title, style: TextStyleEx.normalStyle(textColor: TColors.blackStrongText, isBold: true)),
                _buildSingleMultilineText(bookmark.description, style: TextStyleEx.normalStyle()),
              ],
            ),
          ),
          const SizedBox(width: marginS),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (bookmark.imageUrl.isEmpty) {
      return const Icon(
        Icons.photo,
        size: 48,
        color: TColors.darkGray,
      );
    } else {
      return Image.network(
        bookmark.imageUrl,
        fit: BoxFit.fill,
      );
    }
  }

  Widget _buildSingleLineText(String label, {required TextStyle style}) {
    return Text(
      label,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSingleMultilineText(String label, {required TextStyle style}) {
    return Text(
      label,
      style: style,
      overflow: TextOverflow.ellipsis,
    );
  }
}
