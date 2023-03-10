import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:trip/util/text_style_ex.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SelectTime {
  Future<void> showModal(BuildContext context, DateTime initTime, Function(DateTime value) onSelect) async {
    await Picker(
      adapter: DateTimePickerAdapter(type: PickerDateTimeType.kHM, value: initTime, customColumnType: [3, 4]),
      title: const Text(""),
      onConfirm: (Picker picker, List value) {
        DateTime time = DateTime(initTime.year, initTime.month, initTime.day, value[0], value[1]);
        onSelect(time);
      },
      confirmText: '完了',
      confirmTextStyle: TextStyleEx.normalStyle(isBold: true),
      cancelText: 'キャンセル',
      cancelTextStyle: TextStyleEx.normalStyle(),
    ).showModal(context);
  }
}
