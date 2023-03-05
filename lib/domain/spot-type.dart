///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
enum SpotType {
  kanko,
  stay,
  onsen,
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
}
