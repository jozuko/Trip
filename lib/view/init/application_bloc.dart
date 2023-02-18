import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/service/auth_service.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc() : super(const ApplicationState()) {
    on<ApplicationInitEvent>(_onInit);
    on<ApplicationCheckAuthEvent>(_onCheckAuth);
    on<ApplicationReceiveSharedUrlEvent>(_onReceiveSharedText);

    add(ApplicationInitEvent());
  }

  Future<void> _onInit(ApplicationInitEvent event, Emitter<ApplicationState> emit) async {
    final authService = getIt.get<AuthService>();
    authService.initialize();
    await authService.signOut();

    emit(state.copyWith(isLoading: false, initialized: false, signedIn: false));
    add(ApplicationCheckAuthEvent());
  }

  void _onCheckAuth(ApplicationCheckAuthEvent event, emit) {
    final authService = getIt.get<AuthService>();
    if (authService.user == null) {
      TripLog.d("ApplicationBloc::_onCheckAuth user is null");
      emit(state.copyWith(isLoading: false, initialized: true, signedIn: false));
    } else {
      TripLog.d("ApplicationBloc::_onCheckAuth user is not null");
      emit(state.copyWith(isLoading: false, initialized: true, signedIn: true));
    }
  }

  void _onReceiveSharedText(ApplicationReceiveSharedUrlEvent event, emit) {
    emit(state.copyWith(sharedText: event.sharedText));
  }
}

abstract class ApplicationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApplicationInitEvent extends ApplicationEvent {}

class ApplicationCheckAuthEvent extends ApplicationEvent {}

class ApplicationReceiveSharedUrlEvent extends ApplicationEvent {
  final String sharedText;

  ApplicationReceiveSharedUrlEvent({
    required this.sharedText,
  });

  @override
  List<Object?> get props => [sharedText];
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
