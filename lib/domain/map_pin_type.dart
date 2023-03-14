import 'package:trip/domain/spot_type.dart';

///
/// Created by jozuko on 2023/03/14.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
enum MapPinType {
  home,
  kanko,
  stay,
  onsen,
  stayOnsen,
}

extension MapPinTypeEx on MapPinType {
  static MapPinType fromSpotType(SpotType spotType) {
    switch (spotType) {
      case SpotType.kanko:
        return MapPinType.kanko;

      case SpotType.stay:
        return MapPinType.stay;

      case SpotType.onsen:
        return MapPinType.onsen;

      case SpotType.stayOnsen:
        return MapPinType.stayOnsen;
    }
  }

  String get assetsPinName {
    switch (this) {
      case MapPinType.kanko:
        return 'assets/images/map_pin_kanko.png';

      case MapPinType.stay:
        return 'assets/images/map_pin_stay.png';

      case MapPinType.onsen:
        return 'assets/images/map_pin_onsen.png';

      case MapPinType.stayOnsen:
        return 'assets/images/map_pin_stay_onsen.png';

      case MapPinType.home:
        return 'assets/images/map_pin_home.png';
    }
  }
}
