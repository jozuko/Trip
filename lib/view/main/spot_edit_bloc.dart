import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/bookmark.dart';
import 'package:trip/domain/firestore/poi.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/domain/spot_type.dart';
import 'package:trip/service/bookmark_service.dart';
import 'package:trip/service/spot_service.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotEditBloc extends Bloc<SpotEditBaseEvent, SpotEditState> {
  final _spotService = getIt.get<SpotService>();
  final _bookmarkService = getIt.get<BookmarkService>();

  SpotEditBloc(Spot? spot) : super(SpotEditState.fromSource(spot)) {
    on<SpotEditInitEvent>(_onInit);
    on<SpotEditChangeSpotTypeEvent>(_onChangeSpotType);
    on<SpotEditChangeNameEvent>(_onChangeName);
    on<SpotEditChangePhoneEvent>(_onChangePhone);
    on<SpotEditChangeAddressEvent>(_onChangeAddress);
    on<SpotEditChangeUrlEvent>(_onChangeUrl);
    on<SpotEditChangeLocationEvent>(_onChangeLocation);
    on<SpotEditChangeMemoEvent>(_onChangeMemo);
    on<SpotEditSetPoiEvent>(_onSetPoi);
  }

  List<Bookmark> getBookmarks() {
    return _bookmarkService.getAll();
  }

  void _onInit(SpotEditInitEvent event, emit) {}

  SpotEditState get _initializedState => state.copyWith(initialized: true);

  void _onChangeSpotType(SpotEditChangeSpotTypeEvent event, emit) {
    emit(_initializedState.copyWith(spotType: event.value));
  }

  void _onChangeName(SpotEditChangeNameEvent event, emit) {
    emit(_initializedState.copyWith(name: event.value));
  }

  void _onChangePhone(SpotEditChangePhoneEvent event, emit) {
    emit(_initializedState.copyWith(phone: event.value));
  }

  void _onChangeAddress(SpotEditChangeAddressEvent event, emit) {
    emit(_initializedState.copyWith(address: event.value));
  }

  void _onChangeUrl(SpotEditChangeUrlEvent event, emit) {
    emit(_initializedState.copyWith(url: event.value));
  }

  void _onChangeLocation(SpotEditChangeLocationEvent event, emit) {
    emit(_initializedState.copyWith(location: event.value));
  }

  void _onChangeMemo(SpotEditChangeMemoEvent event, emit) {
    emit(_initializedState.copyWith(memo: event.value));
  }

  void _onSetPoi(SpotEditSetPoiEvent event, emit) {
    var state = _initializedState;
    emit(state.copyWith(
      placeId: event.value.docId,
      name: event.value.title,
      phone: event.value.phoneNumber,
      address: event.value.address,
      url: event.value.url,
      location: event.value.location.label,
      memo: event.value.memo,
    ));
  }
}

abstract class SpotEditBaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SpotEditInitEvent extends SpotEditBaseEvent {}

class SpotEditInitDoneEvent extends SpotEditBaseEvent {}

abstract class SpotEditChangeBaseEvent extends SpotEditBaseEvent {
  final String value;

  SpotEditChangeBaseEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class SpotEditChangeSpotTypeEvent extends SpotEditBaseEvent {
  final SpotType value;

  SpotEditChangeSpotTypeEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class SpotEditChangeNameEvent extends SpotEditChangeBaseEvent {
  SpotEditChangeNameEvent(super.value);
}

class SpotEditChangePhoneEvent extends SpotEditChangeBaseEvent {
  SpotEditChangePhoneEvent(super.value);
}

class SpotEditChangeAddressEvent extends SpotEditChangeBaseEvent {
  SpotEditChangeAddressEvent(super.value);
}

class SpotEditChangeUrlEvent extends SpotEditChangeBaseEvent {
  SpotEditChangeUrlEvent(super.value);
}

class SpotEditChangeLocationEvent extends SpotEditChangeBaseEvent {
  SpotEditChangeLocationEvent(super.value);
}

class SpotEditChangeMemoEvent extends SpotEditChangeBaseEvent {
  SpotEditChangeMemoEvent(super.value);
}

class SpotEditSetPoiEvent extends SpotEditBaseEvent {
  final Poi value;

  SpotEditSetPoiEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class SpotEditState extends Equatable {
  final bool initialized;
  final Spot? source;
  final String placeId;
  final SpotType spotType;
  final String name;
  final String phone;
  final String address;
  final String url;
  final String location;
  final String memo;

  const SpotEditState({
    required this.initialized,
    required this.source,
    required this.placeId,
    required this.spotType,
    required this.name,
    required this.phone,
    required this.address,
    required this.url,
    required this.location,
    required this.memo,
  });

  factory SpotEditState.fromSource(Spot? source) {
    return SpotEditState(
      initialized: false,
      source: source,
      placeId: source?.placeId ?? "",
      spotType: source?.spotType ?? SpotType.kanko,
      name: source?.name ?? "",
      phone: source?.phone ?? "",
      address: source?.address ?? "",
      url: source?.url ?? "",
      location: source?.location.label ?? "",
      memo: source?.memo ?? "",
    );
  }

  SpotEditState copyWith({
    bool? initialized,
    String? placeId,
    SpotType? spotType,
    String? name,
    String? phone,
    String? address,
    String? url,
    String? location,
    String? memo,
  }) {
    return SpotEditState(
      initialized: initialized ?? this.initialized,
      source: source,
      placeId: placeId ?? this.placeId,
      spotType: spotType ?? this.spotType,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      url: url ?? this.url,
      location: location ?? this.location,
      memo: memo ?? this.memo,
    );
  }

  @override
  List<Object?> get props => [
        initialized,
        source,
        placeId,
        spotType,
        name,
        phone,
        address,
        url,
        location,
        memo,
      ];
}
