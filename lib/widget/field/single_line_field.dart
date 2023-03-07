import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/string_ex.dart';
import 'package:trip/util/text_style_ex.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SingleLineField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SingleLineField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.textInputType,
    this.textInputAction,
    this.errorText,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() {
    return _SingleLineFieldState();
  }
}

class _SingleLineFieldState extends State<SingleLineField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: widget.errorText == null ? 80 : 100,
      decoration: const BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
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
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: TColors.blackText)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: TColors.blackText)),
        ),
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputAction,
        maxLines: 1,
      ),
    );
  }
}
