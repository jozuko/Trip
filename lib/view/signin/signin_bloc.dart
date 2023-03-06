import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/service/auth_service.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(const SignInState()) {
    on<SignInGoogleEvent>(_onAuthGoogle);
    on<SignInAppleEvent>(_onAuthApple);
    on<SignInClearMessageEvent>(_onClearMessage);
  }

  Future<void> _onAuthGoogle(event, emit) async {
    final authService = getIt.get<AuthService>();

    emit(state.copyWith(isLoading: true));
    final authResult = await authService.authWithGoogle();
    switch (authResult) {
      case AuthResultThirdParty.success:
        emit(state.copyWith(isLoading: false, isDoneAuth: true));
        break;
      case AuthResultThirdParty.failed:
        emit(state.copyWith(message: 'ログインできませんでした。'));
        break;
    }
  }

  Future<void> _onAuthApple(event, emit) async {
    final authService = getIt.get<AuthService>();

    emit(state.copyWith(isLoading: true));
    final authResult = await authService.authWithApple();
    switch (authResult) {
      case AuthResultThirdParty.success:
        emit(state.copyWith(isLoading: false, isDoneAuth: true));
        break;
      case AuthResultThirdParty.failed:
        emit(state.copyWith(message: 'ログインできませんでした。'));
        break;
    }
  }

  void _onClearMessage(event, emit) {
    emit(state.copyWith(message: ''));
  }
}

abstract class SignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInGoogleEvent extends SignInEvent {}

class SignInAppleEvent extends SignInEvent {}

class SignInClearMessageEvent extends SignInEvent {}

class SignInState extends Equatable {
  final bool isLoading;
  final bool isDoneAuth;
  final String message;

  const SignInState({
    this.isLoading = false,
    this.isDoneAuth = false,
    this.message = '',
  });

  SignInState copyWith({
    bool? isLoading,
    bool? isDoneAuth,
    String? message,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      isDoneAuth: isDoneAuth ?? this.isDoneAuth,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isDoneAuth,
        message,
      ];
}
