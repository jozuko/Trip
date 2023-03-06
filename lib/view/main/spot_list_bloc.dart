import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/service/spot_service.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotListBloc extends Bloc<SpotListBaseEvent, SpotListState> {
  final _spotService = getIt.get<SpotService>();

  SpotListBloc() : super(const SpotListState(spots: [])) {
    on<SpotListInitEvent>(_onInit);
  }

  void _onInit(SpotListInitEvent event, emit) {
    final spots = _spotService.getSpot();
    emit(SpotListState(spots: spots));
  }
}

abstract class SpotListBaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SpotListInitEvent extends SpotListBaseEvent {}

class SpotListState extends Equatable {
  final List<Spot> spots;

  const SpotListState({required this.spots});

  @override
  List<Object?> get props => [spots];
}
