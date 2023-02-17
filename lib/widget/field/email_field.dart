import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/string_ex.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class EmailField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String? initialValue;
  final String? errorText;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  const EmailField({
    super.key,
    this.labelText = 'メールアドレス',
    this.hintText = 'aaa@bbb.com',
    this.initialValue,
    this.errorText,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: errorText == null ? 80 : 100,
      decoration: const BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: TextFormField(
        initialValue: initialValue,
        focusNode: focusNode,
        onChanged: onChanged,
        cursorColor: TColors.blackText,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          errorText: errorText.emptyToNull,
          labelStyle: const TextStyle(color: TColors.blackText, fontWeight: FontWeight.bold),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: TColors.blackText)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: TColors.blackText)),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: textInputAction,
        maxLines: 1,
      ),
    );
  }
}
