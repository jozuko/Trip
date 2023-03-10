import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/firestore/poi.dart';
import 'package:trip/service/poi_service.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class PoiListBloc extends Bloc<PoiListBaseEvent, PoiListState> {
  final _poiService = getIt.get<PoiService>();

  PoiListBloc() : super(PoiListState(pois: getIt.get<PoiService>().getPois())) {}
}

abstract class PoiListBaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PoiListInitEvent extends PoiListBaseEvent {}

class PoiListState extends Equatable {
  final List<Poi> pois;

  const PoiListState({required this.pois});

  @override
  List<Object?> get props => [pois];
}
