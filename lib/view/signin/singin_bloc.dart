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
  }

  Future<void> _onAuthGoogle(event, emit) async {
    final authService = getIt.get<AuthService>();

    emit(state.copyWith(isLoading: true));
    final result = await authService.authWithGoogle();
    emit(state.copyWith(isLoading: false));
  }
}

abstract class SignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInGoogleEvent extends SignInEvent {}

class SignInState extends Equatable {
  final bool isLoading;
  final bool isDoneAuth;

  const SignInState({
    this.isLoading = false,
    this.isDoneAuth = false,
  });

  SignInState copyWith({
    bool? isLoading,
    bool? isDoneAuth,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      isDoneAuth: isDoneAuth ?? this.isDoneAuth,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isDoneAuth,
      ];
}
