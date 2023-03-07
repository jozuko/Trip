import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
enum SpotType {
  kanko,
  stay,
  onsen,
  stayOnsen,
}

extension SpotTypeEx on SpotType {
  static SpotType fromFirestore(dynamic value) {
    if (value == null) {
      return SpotType.kanko;
    }
    if (value is! int) {
      return SpotType.kanko;
    }

    if (value < 0 || value >= SpotType.values.length) {
      return SpotType.kanko;
    }
    return SpotType.values[value];
  }

  dynamic toFirestore() {
    return index;
  }

  Color get backgroundColor {
    switch (this) {
      case SpotType.kanko:
        return TColors.spotKankoBackground;

      case SpotType.stay:
        return TColors.spotStayBackground;

      case SpotType.onsen:
        return TColors.spotOnsenBackground;

      case SpotType.stayOnsen:
        return TColors.spotStayBackground;
    }
  }

  String get assetsIconName {
    switch (this) {
      case SpotType.kanko:
        return 'assets/images/spot_type_kanko.png';

      case SpotType.stay:
        return 'assets/images/spot_type_stay.png';

      case SpotType.onsen:
        return 'assets/images/spot_type_onsen.png';

      case SpotType.stayOnsen:
        return 'assets/images/spot_type_stay_onsen.png';
    }
  }

  String get label {
    switch (this) {
      case SpotType.kanko:
        return "観光スポット";

      case SpotType.stay:
        return "宿泊地";

      case SpotType.onsen:
        return "立ち寄り湯";

      case SpotType.stayOnsen:
        return "宿泊地(風呂付)";
    }
  }
}
