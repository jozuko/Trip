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

  SpotListBloc() : super(const SpotListState(isLoading: false, spots: [])) {
    on<SpotListInitEvent>(_onInit);
    on<SpotListRefreshEvent>(_onRefresh);
    on<SpotListRemoveItemEvent>(_onRemoveItem);
  }

  void _onInit(SpotListInitEvent event, emit) {
    add(SpotListRefreshEvent());
  }

  void _onRefresh(SpotListRefreshEvent event, emit) {
    final spots = _spotService.getSpot();
    emit(state.copyWith(spots: spots));
  }

  Future<void> _onRemoveItem(SpotListRemoveItemEvent event, emit) async {
    await _spotService.remove(event.spot);
    add(SpotListRefreshEvent());
  }
}

abstract class SpotListBaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SpotListInitEvent extends SpotListBaseEvent {}

class SpotListRefreshEvent extends SpotListBaseEvent {}

class SpotListRemoveItemEvent extends SpotListBaseEvent {
  final Spot spot;

  SpotListRemoveItemEvent(this.spot);

  @override
  List<Object?> get props => [spot];
}

class SpotListState extends Equatable {
  final bool isLoading;
  final List<Spot> spots;

  const SpotListState({
    required this.isLoading,
    required this.spots,
  });

  SpotListState copyWith({
    bool? isLoading,
    List<Spot>? spots,
  }) {
    return SpotListState(
      isLoading: isLoading ?? this.isLoading,
      spots: spots ?? this.spots,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        spots,
      ];
}
