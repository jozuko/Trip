import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/repository/google_maps/place_api_client.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/repository/shared_holder.dart';
import 'package:trip/service/plan_service.dart';
import 'package:trip/util/global.dart';

import '../../domain/firestore/location.dart';

///
/// Created by jozuko on 2023/02/22.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class HomeBloc extends Bloc<HomeEventBase, HomeState> {
  final sharedHolder = getIt.get<SharedHolder>();
  final planService = getIt.get<PlanService>();

  HomeBloc() : super(const HomeState()) {
    on<HomeInitEvent>(_onInit);
  }

  Future<void> _onInit(HomeInitEvent event, emit) async {
    planService.getPlans();

    await getIt.get<GoogleMapsPlaceApi>().searchFromLatLng(Location.def);

    TripLog.d('Home#_onInit');
    emit(const HomeState());
  }
}

abstract class HomeEventBase extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitEvent extends HomeEventBase {}

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}
