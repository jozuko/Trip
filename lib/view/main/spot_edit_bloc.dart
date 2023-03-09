import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/bookmark.dart';
import 'package:trip/domain/firestore/open_time.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/domain/location_data.dart';
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
    on<SpotEditSetLocationDataEvent>(_onSetLocationData);
    on<SpotEditChangeFromTimeEvent>(_onChangeFromTime);
    on<SpotEditChangeToTimeEvent>(_onChangeToTime);
    on<SpotEditRemoveOpenTimeEvent>(_onRemoveOpenTime);
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

  void _onSetLocationData(SpotEditSetLocationDataEvent event, emit) {
    var state = _initializedState;
    if (state.name.isEmpty) {
      state = state.copyWith(name: event.value.name);
    }
    if (state.address.isEmpty) {
      state = state.copyWith(address: event.value.address);
    }
    state = state.copyWith(location: event.value.location.label);
    emit(state);
  }

  void _onChangeFromTime(SpotEditChangeFromTimeEvent event, emit) {
    final openTimes = _initializedState.openTimes.replaceTime(event.index, from: event.value);
    emit(_initializedState.copyWith(openTimes: openTimes));
  }

  void _onChangeToTime(SpotEditChangeToTimeEvent event, emit) {
    final openTimes = _initializedState.openTimes.replaceTime(event.index, to: event.value);
    emit(_initializedState.copyWith(openTimes: openTimes));
  }

  void _onRemoveOpenTime(SpotEditRemoveOpenTimeEvent event, emit) {
    final openTimes = _initializedState.openTimes.remove(event.index);
    emit(_initializedState.copyWith(openTimes: openTimes));
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

class SpotEditSetLocationDataEvent extends SpotEditBaseEvent {
  final LocationData value;

  SpotEditSetLocationDataEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class SpotEditChangeFromTimeEvent extends SpotEditBaseEvent {
  final int index;
  final String value;

  SpotEditChangeFromTimeEvent({
    required this.index,
    required this.value,
  });

  @override
  List<Object?> get props => [index, value];
}

class SpotEditChangeToTimeEvent extends SpotEditBaseEvent {
  final int index;
  final String value;

  SpotEditChangeToTimeEvent({
    required this.index,
    required this.value,
  });

  @override
  List<Object?> get props => [index, value];
}

class SpotEditRemoveOpenTimeEvent extends SpotEditBaseEvent {
  final int index;

  SpotEditRemoveOpenTimeEvent({
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}

class SpotEditState extends Equatable {
  final bool initialized;
  final Spot? source;
  final SpotType spotType;
  final String name;
  final String phone;
  final String address;
  final String url;
  final String location;
  final OpenTimes openTimes;
  final String nameError;
  final String phoneError;
  final String addressError;
  final String urlError;
  final String locationError;

  const SpotEditState({
    required this.initialized,
    required this.source,
    required this.spotType,
    required this.name,
    required this.phone,
    required this.address,
    required this.url,
    required this.location,
    required this.openTimes,
    required this.nameError,
    required this.phoneError,
    required this.addressError,
    required this.urlError,
    required this.locationError,
  });

  factory SpotEditState.fromSource(Spot? source) {
    return SpotEditState(
      initialized: false,
      source: source,
      spotType: source?.spotType ?? SpotType.kanko,
      name: source?.name ?? "",
      phone: source?.phone ?? "",
      address: source?.address ?? "",
      url: source?.url ?? "",
      location: source?.location?.label ?? "",
      openTimes: source?.openTimes ?? const OpenTimes(),
      nameError: "",
      phoneError: "",
      addressError: "",
      urlError: "",
      locationError: "",
    );
  }

  SpotEditState copyWith({
    bool? initialized,
    SpotType? spotType,
    String? name,
    String? phone,
    String? address,
    String? url,
    String? location,
    OpenTimes? openTimes,
    String? nameError,
    String? phoneError,
    String? addressError,
    String? urlError,
    String? locationError,
  }) {
    return SpotEditState(
      initialized: initialized ?? this.initialized,
      source: source,
      spotType: spotType ?? this.spotType,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      url: url ?? this.url,
      location: location ?? this.location,
      openTimes: openTimes ?? this.openTimes,
      nameError: nameError ?? this.nameError,
      phoneError: phoneError ?? this.phoneError,
      addressError: addressError ?? this.addressError,
      urlError: urlError ?? this.urlError,
      locationError: locationError ?? this.locationError,
    );
  }

  @override
  List<Object?> get props => [
        initialized,
        source,
        spotType,
        name,
        phone,
        address,
        url,
        location,
        openTimes,
        nameError,
        phoneError,
        addressError,
        urlError,
        locationError,
      ];
}
