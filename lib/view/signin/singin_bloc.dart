import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInState());
}

abstract class SignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInState extends Equatable {
  @override
  List<Object?> get props => [];
}
