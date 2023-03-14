import 'package:flutter/material.dart';
import 'package:trip/domain/bookmark.dart';
import 'package:trip/util/global.dart';
import 'package:trip/widget/bookmark_widget.dart';
import 'package:trip/widget/button/square_text_button.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SelectBookmarkDialog extends StatelessWidget {
  const SelectBookmarkDialog({
    super.key,
    required this.items,
    required this.onCanceled,
    required this.onSelected,
  });

  final List<Bookmark> items;
  final VoidCallback onCanceled;
  final ValueChanged<Bookmark>? onSelected;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
      content: SizedBox(
        width: width - (margin * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int idx) {
                    return BookmarkWidget(
                      bookmark: items[idx],
                      onPressed: () {
                        onSelected?.call(items[idx]);
                      },
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: margin, right: margin, left: margin),
              child: SquareWidgetButton.whiteButton(
                'キャンセル',
                onPressed: onCanceled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
