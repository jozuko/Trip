import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/string_ex.dart';

///
/// password field
///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class PasswordField extends StatefulWidget {
  final String labelText;
  final String? initialValue;
  final String? errorText;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onPressIcon;

  const PasswordField({
    super.key,
    this.labelText = 'パスワード',
    this.initialValue,
    this.errorText,
    this.obscureText = true,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onPressIcon,
  });

  @override
  State<StatefulWidget> createState() {
    return _LoginPasswordState();
  }
}

///
/// State password field
///
class _LoginPasswordState extends State<PasswordField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.skipTraversal = true;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
        initialValue: widget.initialValue ?? '',
        focusNode: widget.focusNode,
        obscureText: widget.obscureText,
        cursorColor: TColors.blackText,
        decoration: InputDecoration(
          labelText: widget.labelText,
          errorText: widget.errorText.emptyToNull,
          labelStyle: const TextStyle(color: TColors.blackText, fontWeight: FontWeight.bold),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: TColors.blackText)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: TColors.blackText)),
          suffixIcon: IconButton(
            focusNode: _focusNode,
            icon: widget.obscureText ? const Icon(Icons.visibility_off, color: TColors.blackText) : const Icon(Icons.visibility, color: TColors.blackText),
            onPressed: widget.onPressIcon,
          ),
        ),
        keyboardType: TextInputType.visiblePassword,
        textInputAction: widget.textInputAction,
        maxLines: 1,
        onChanged: widget.onChanged,
      ),
    );
  }
}
