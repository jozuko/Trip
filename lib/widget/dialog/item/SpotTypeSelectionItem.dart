import 'package:flutter/material.dart';
import 'package:trip/domain/spot_type.dart';
import 'package:trip/widget/dialog/select_dialog.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotTypeSelectionItem extends SelectDialogItem<SpotType> {
  static List<SpotTypeSelectionItem> getItems(ValueChanged<SpotType>? onSelected) {
    return SpotType.values
        .map(
          (spotType) => SpotTypeSelectionItem(
            value: spotType,
            label: spotType.label,
          ),
        )
        .toList();
  }

  const SpotTypeSelectionItem({
    required super.value,
    required super.label,
  });
}
