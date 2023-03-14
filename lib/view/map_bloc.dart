import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/domain/map_pin_type.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class MapBloc extends Bloc<MapBaseEvent, MapState> {
  MapBloc(Location? location, MapPinType mapPinType, bool isEditable)
      : super(MapState(
          isEditable: isEditable,
          source: location ?? Location.def,
          mapPinType: mapPinType,
        )) {
    on<MapInitEvent>(_onInit);
  }

  void _onInit(MapInitEvent event, emit) {}
}

abstract class MapBaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MapInitEvent extends MapBaseEvent {}

class MapState extends Equatable {
  final bool isEditable;
  final Location source;
  final MapPinType mapPinType;

  const MapState({
    required this.isEditable,
    required this.source,
    required this.mapPinType,
  });

  @override
  List<Object?> get props => [isEditable, source, mapPinType];
}
