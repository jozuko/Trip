import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/widget/button/square_rounded_button.dart';

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
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: TColors.blackText),
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

    final okButton = SquareRoundedButton(
      width: buttonSize,
      height: buttonHeight,
      radius: buttonHeight / 2,
      backgroundColor: TColors.blackButtonBack,
      inkColor: TColors.blackButtonInk,
      showBarrier: false,
      showBorder: false,
      onPressed: () {
        onPressedButton(false);
      },
      child: Center(
        child: Text(
          okLabel,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: TColors.blackButtonText),
        ),
      ),
    );

    if (showCancel) {
      final cancelButton = SquareRoundedButton(
        width: buttonSize,
        height: buttonHeight,
        radius: buttonHeight / 2,
        backgroundColor: TColors.whiteButtonBack,
        inkColor: TColors.whiteButtonInk,
        borderColor: TColors.whiteButtonBorder,
        showBarrier: false,
        showBorder: true,
        onPressed: () {
          onPressedButton(true);
        },
        child: Center(
          child: Text(
            cancelLabel,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: TColors.whiteButtonText),
          ),
        ),
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
