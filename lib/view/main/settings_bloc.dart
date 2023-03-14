import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/domain/firestore/user.dart';
import 'package:trip/service/user_service.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/14.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SettingsBloc extends Bloc<SettingsBaseEvent, SettingsState> {
  final _userService = getIt.get<UserService>();

  SettingsBloc() : super(const SettingsState(user: null)) {
    on<SettingsInitEvent>(_onInit);
    on<SettingsUpdateHomeEvent>(_onUpdateHome);
  }

  void _onInit(SettingsInitEvent event, emit) {
    emit(state.copyWith(user: _userService.getUser()));
  }

  Future<void> _onUpdateHome(SettingsUpdateHomeEvent event, emit) async {
    final user = await _userService.updateHomePos(event.location);
    emit(state.copyWith(user: user));
  }
}

abstract class SettingsBaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsInitEvent extends SettingsBaseEvent {}

class SettingsUpdateHomeEvent extends SettingsBaseEvent {
  final Location location;

  SettingsUpdateHomeEvent({required this.location});

  @override
  List<Object?> get props => [location];
}

class SettingsState extends Equatable {
  final User? user;

  const SettingsState({required this.user});

  SettingsState copyWith({User? user}) {
    return SettingsState(user: user ?? this.user);
  }

  @override
  List<Object?> get props => [user];
}
