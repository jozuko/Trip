import 'package:flutter/material.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/string_ex.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SingleLineField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? value;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const SingleLineField({
    super.key,
    this.labelText,
    this.hintText,
    this.value,
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
  final _inputController = TextEditingController();
  
  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    TripLog.d("SingleTextField::build label:${widget.labelText}, initialValue:${widget.value}");
    _inputController.text = widget.value ?? '';
    
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
        controller: _inputController,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        cursorColor: TColors.blackText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          errorText: widget.errorText.emptyToNull,
          labelStyle: const TextStyle(color: TColors.blackText, fontWeight: FontWeight.bold),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: TColors.blackText)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: TColors.blackText)),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: widget.textInputAction,
        maxLines: 1,
      ),
    );
  }
}
