import 'package:flutter/material.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/widget/button/square_text_button.dart';

class SelectDialog<T> extends StatelessWidget {
  const SelectDialog({
    super.key,
    required this.items,
    required this.onCanceled,
    required this.onSelected,
  });

  final List<SelectDialogItem<T>> items;
  final VoidCallback onCanceled;
  final ValueChanged<T>? onSelected;

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
                    return _buildItems(items[idx]);
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

  Widget _buildItems(SelectDialogItem<T> item) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: margin, right: margin),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyleEx.normalStyle(isBold: true),
              ),
            ),
          ),
          SquareWidgetButton.blackButton(
            '選択',
            width: 80,
            onPressed: () {
              onSelected?.call(item.value);
            },
          ),
        ],
      ),
    );
  }
}

class SelectDialogItem<T> {
  final T value;
  final String label;

  const SelectDialogItem({
    required this.value,
    required this.label,
  });
}
