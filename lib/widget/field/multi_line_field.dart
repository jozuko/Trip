import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/string_ex.dart';
import 'package:trip/util/text_style_ex.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class MultiLineField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? errorText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const MultiLineField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.textInputAction,
    this.errorText,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() {
    return _MultiLineFieldState();
  }
}

class _MultiLineFieldState extends State<MultiLineField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TColors.blackText),
        borderRadius: BorderRadius.circular(5.0),
      ),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(left: marginS, right: marginS),
        child: SingleChildScrollView(
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
            cursorColor: TColors.blackText,
            decoration: InputDecoration(
              hintText: widget.hintText,
              labelText: widget.labelText,
              errorText: widget.errorText.emptyToNull,
              labelStyle: TextStyleEx.normalStyle(isBold: true),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 100,
            textInputAction: widget.textInputAction,
          ),
        ),
      ),
    );
  }
}
