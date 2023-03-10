import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/domain/location_data.dart';
import 'package:trip/domain/spot_type.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotMapBloc extends Bloc<SpotMapBaseEvent, SpotMapState> {
  SpotMapBloc(LocationData? locationData, SpotType spotType)
      : super(SpotMapState(
          source: locationData ?? const LocationData(location: Location.def),
          spotType: spotType,
        )) {
    on<SpotMapInitEvent>(_onInit);
  }

  void _onInit(SpotMapInitEvent event, emit) {}
}

abstract class SpotMapBaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SpotMapInitEvent extends SpotMapBaseEvent {}

class SpotMapState extends Equatable {
  final LocationData source;
  final SpotType spotType;

  const SpotMapState({
    required this.source,
    required this.spotType,
  });

  @override
  List<Object?> get props => [source, spotType];
}
