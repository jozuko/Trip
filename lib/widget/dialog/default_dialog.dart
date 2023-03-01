import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/widget/button/square_text_button.dart';

typedef DefaultDialogButtonPressedCallback = void Function(bool canceled);

class DefaultDialog extends StatelessWidget {
  static const _margin = 28.0;

  const DefaultDialog({
    super.key,
    required this.text,
    required this.onPressedButton,
    this.showCancel = false,
    this.okLabel = 'OK',
    this.cancelLabel = 'キャンセル',
  });

  final String text;
  final DefaultDialogButtonPressedCallback onPressedButton;
  final bool showCancel;
  final String okLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: TColors.white,
          border: Border.all(color: TColors.whiteButtonBorder),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_margin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyleEx.normalStyle(textColor: TColors.blackText),
              ),
              const SizedBox(height: _margin),
              _buildBottomButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    const buttonHeight = 50.0;
    final displaySize = MediaQuery.of(context).size.width;
    final buttonSize = (displaySize - (_margin * 4) - 40.0) / 2;

    final okButton = SquareTextButton.blackButton(
      okLabel,
      width: buttonSize,
      height: buttonHeight,
      radius: buttonHeight / 2,
      onPressed: () {
        onPressedButton(false);
      },
    );

    if (showCancel) {
      final cancelButton = SquareTextButton.whiteButton(
        cancelLabel,
        width: buttonSize,
        height: buttonHeight,
        radius: buttonHeight / 2,
        onPressed: () {
          onPressedButton(true);
        },
      );
      return Row(
        children: [
          cancelButton,
          const Spacer(),
          okButton,
        ],
      );
    } else {
      return okButton;
    }
  }
}
