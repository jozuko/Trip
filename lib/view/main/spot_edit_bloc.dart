import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/firestore/open_time.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/domain/spot_type.dart';
import 'package:trip/service/spot_service.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotEditBloc extends Bloc<SpotEditBaseEvent, SpotEditState> {
  final _spotService = getIt.get<SpotService>();

  SpotEditBloc(Spot? spot) : super(SpotEditState.fromSource(spot)) {
    on<SpotEditInitEvent>(_onInit);
    on<SpotEditChangeNameEvent>(_onChangeName);
    on<SpotEditChangePhoneEvent>(_onChangePhone);
    on<SpotEditChangeAddressEvent>(_onChangeAddress);
    on<SpotEditChangeUrlEvent>(_onChangeUrl);
    on<SpotEditChangeLocationEvent>(_onChangeLocation);
  }

  void _onInit(SpotEditInitEvent event, emit) {
    emit(state.copyWith(name: "aaaa"));
  }

  SpotEditState get _initializedState => state.copyWith(initialized: true);

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
}

abstract class SpotEditBaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SpotEditInitEvent extends SpotEditBaseEvent {}

class SpotEditInitDoneEvent extends SpotEditBaseEvent {}

abstract class SpotEditChangeBaseEvent extends SpotEditBaseEvent {
  final String value;

  SpotEditChangeBaseEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class SpotEditChangeNameEvent extends SpotEditChangeBaseEvent {
  SpotEditChangeNameEvent({required super.value});
}

class SpotEditChangePhoneEvent extends SpotEditChangeBaseEvent {
  SpotEditChangePhoneEvent({required super.value});
}

class SpotEditChangeAddressEvent extends SpotEditChangeBaseEvent {
  SpotEditChangeAddressEvent({required super.value});
}

class SpotEditChangeUrlEvent extends SpotEditChangeBaseEvent {
  SpotEditChangeUrlEvent({required super.value});
}

class SpotEditChangeLocationEvent extends SpotEditChangeBaseEvent {
  SpotEditChangeLocationEvent({required super.value});
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
  final List<OpenTime> openTimes;
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
      openTimes: source?.openTimes.times ?? [],
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
    List<OpenTime>? openTimes,
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
