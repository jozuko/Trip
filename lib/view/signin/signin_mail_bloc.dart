import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/service/auth_service.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SignInMailBloc extends Bloc<SignInMailEvent, SignInMailState> {
  SignInMailBloc() : super(const SignInMailState()) {
    on<SignInMailEmailChangedEvent>(_onChangeEmail);
    on<SignInMailPasswordChangedEvent>(_onChangePassword);
    on<SignInMailPasswordChangeObscureEvent>(_onChangeObscurePassword);
    on<SignInMailSubmitEvent>(_onSubmit);
    on<SignInMailClearMessageEvent>(_onClearMessage);
  }

  void _onChangeEmail(SignInMailEmailChangedEvent event, Emitter<SignInMailState> emit) {
    var state = this.state.copyWith(email: event.email);

    if (state.submitted) {
      state = _validateEmail(state);
    }

    emit(state);
  }

  void _onChangePassword(SignInMailPasswordChangedEvent event, Emitter<SignInMailState> emit) {
    var signInState = state.copyWith(password: event.password);

    if (signInState.submitted) {
      signInState = _validatePassword(signInState);
    }

    emit(signInState);
  }

  SignInMailState _validateEmail(SignInMailState state) {
    if (state.email.isEmpty) {
      return state.copyWith(errorEmail: 'メールアドレスを入力してください');
    } else {
      return state.copyWith(errorEmail: '');
    }
  }

  SignInMailState _validatePassword(SignInMailState state) {
    if (state.password.isEmpty) {
      return state.copyWith(errorPassword: 'パスワードを入力してください');
    } else {
      return state.copyWith(errorPassword: '');
    }
  }

  void _onChangeObscurePassword(SignInMailPasswordChangeObscureEvent event, Emitter<SignInMailState> emit) {
    final obscurePassword = state.obscurePassword;
    emit(state.copyWith(obscurePassword: !obscurePassword));
  }

  Future<void> _onSubmit(SignInMailSubmitEvent event, Emitter<SignInMailState> emit) async {
    var state = this.state.copyWith(submitted: true);
    state = _validateEmail(state);
    state = _validatePassword(state);
    if (state.errorEmail.isNotEmpty || state.errorPassword.isNotEmpty) {
      emit(state);
      return;
    }

    emit(state.copyWith(isLoading: true));

    final authService = getIt.get<AuthService>();
    final authResult = await authService.authWithMail(state.email, state.password);
    switch (authResult) {
      case AuthResultMail.success:
        emit(state.copyWith(isLoading: false, isDoneAuth: true));
        break;
      case AuthResultMail.weekPassword:
        emit(state.copyWith(errorPassword: 'もう少し複雑なパスワードを指定してください'));
        break;
      case AuthResultMail.userNotFound:
      case AuthResultMail.wrongPassword:
      case AuthResultMail.failed:
        emit(state.copyWith(message: 'ログインできませんでした。\nメールアドレスとパスワードをご確認の上、通信環境の良いところで再度お試しください。'));
        break;
    }
  }

  void _onClearMessage(SignInMailClearMessageEvent event, emit) {
    emit(state.copyWith(message: ''));
  }
}

abstract class SignInMailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInMailSubmitEvent extends SignInMailEvent {}

class SignInMailClearMessageEvent extends SignInMailEvent {}

class SignInMailEmailChangedEvent extends SignInMailEvent {
  final String email;

  SignInMailEmailChangedEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class SignInMailPasswordChangedEvent extends SignInMailEvent {
  final String password;

  SignInMailPasswordChangedEvent({required this.password});

  @override
  List<Object> get props => [password];
}

class SignInMailPasswordChangeObscureEvent extends SignInMailEvent {}

class SignInMailState extends Equatable {
  final bool isLoading;
  final String email;
  final String password;
  final bool obscurePassword;
  final bool submitted;
  final String errorEmail;
  final String errorPassword;
  final String message;
  final bool isDoneAuth;

  const SignInMailState({
    this.isLoading = false,
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.submitted = false,
    this.errorEmail = '',
    this.errorPassword = '',
    this.message = '',
    this.isDoneAuth = false,
  });

  SignInMailState copyWith({
    bool? isLoading,
    String? email,
    String? password,
    bool? obscurePassword,
    bool? submitted,
    String? errorEmail,
    String? errorPassword,
    String? message,
    bool? isDoneAuth,
  }) {
    return SignInMailState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      submitted: submitted ?? this.submitted,
      errorEmail: errorEmail ?? this.errorEmail,
      errorPassword: errorPassword ?? this.errorPassword,
      message: message ?? this.message,
      isDoneAuth: isDoneAuth ?? this.isDoneAuth,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        email,
        password,
        obscurePassword,
        submitted,
        errorEmail,
        errorPassword,
        message,
        isDoneAuth,
      ];

  @override
  String toString() {
    return 'isLoading: $isLoading, '
        'email: $email, '
        'password: $password, '
        'obscurePassword: $obscurePassword, '
        'submitted: $submitted, '
        'errorEmail: $errorEmail, '
        'errorPassword: $errorPassword, '
        'message: $message, '
        'isDoneAuth: $isDoneAuth';
  }
}
