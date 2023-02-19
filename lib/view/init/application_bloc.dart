import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/service/auth_service.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/string_ex.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final _authService = getIt.get<AuthService>();
  StreamSubscription? _intentDataStreamSubscription;

  ApplicationBloc() : super(const ApplicationState(isLoading: true, initialized: false, signedIn: false)) {
    on<ApplicationInitEvent>(_onInit);
    on<ApplicationCheckAuthEvent>(_onCheckAuth);
    on<ApplicationReceiveSharedEvent>(_onReceiveShared);
  }

  void dispose() {
    _intentDataStreamSubscription?.cancel();
  }

  Future<void> _onInit(ApplicationInitEvent event, Emitter<ApplicationState> emit) async {
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
      TripLog.d("ApplicationBloc::getTextStream value:$value");
      add(ApplicationReceiveSharedEvent(value: value));
    }, onError: (e) {
      TripLog.e("ApplicationBloc::getTextStream error: $e");
    });

    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value.nullToEmpty.isNotEmpty) {
        TripLog.d("ApplicationBloc::getInitialText value:$value");
        add(ApplicationReceiveSharedEvent(value: value!));
      }
    });

    _authService.initialize((user) {
      emit(state.copyWith(initialized: true, signedIn: user != null));
    });
  }

  void _onReceiveShared(ApplicationReceiveSharedEvent event, emit) {
    emit(state.copyWith(sharedText: event.value));
  }

  void _onCheckAuth(ApplicationCheckAuthEvent event, emit) {
    if (_authService.user == null) {
      TripLog.d("ApplicationBloc::_onCheckAuth user is null");
      emit(state.copyWith(isLoading: false, initialized: true, signedIn: false));
    } else {
      TripLog.d("ApplicationBloc::_onCheckAuth user is not null");
      emit(state.copyWith(isLoading: false, initialized: true, signedIn: true));
    }
  }
}

abstract class ApplicationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApplicationInitEvent extends ApplicationEvent {}

class ApplicationCheckAuthEvent extends ApplicationEvent {}

class ApplicationReceiveSharedEvent extends ApplicationEvent {
  final String value;

  ApplicationReceiveSharedEvent({
    required this.value,
  });

  @override
  List<Object?> get props => [value];
}

class ApplicationState extends Equatable {
  final bool isLoading;
  final bool initialized;
  final bool signedIn;
  final String sharedText;

  const ApplicationState({
    this.isLoading = true,
    this.initialized = false,
    this.signedIn = false,
    this.sharedText = '',
  });

  ApplicationState copyWith({
    bool? isLoading,
    bool? initialized,
    bool? signedIn,
    String? sharedText,
  }) {
    return ApplicationState(
      isLoading: isLoading ?? this.isLoading,
      initialized: initialized ?? this.initialized,
      signedIn: signedIn ?? this.signedIn,
      sharedText: sharedText ?? this.sharedText,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        initialized,
        signedIn,
        sharedText,
      ];

  @override
  String toString() {
    return 'isLoading:$isLoading, '
        'initialized:$initialized, '
        'signedIn:$signedIn, '
        'sharedText:$sharedText';
  }
}
