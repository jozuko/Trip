import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/domain/spot_type.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotMapBloc extends Bloc<SpotMapBaseEvent, SpotMapState> {
  SpotMapBloc(Location? location, SpotType spotType, bool isEditable)
      : super(SpotMapState(
          isEditable: isEditable,
          source: location ?? Location.def,
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
  final bool isEditable;
  final Location source;
  final SpotType spotType;

  const SpotMapState({
    required this.isEditable,
    required this.source,
    required this.spotType,
  });

  @override
  List<Object?> get props => [source, spotType];
}
