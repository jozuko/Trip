import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class AccountBloc extends Bloc<AccountBaseEvent, AccountState> {
  AccountBloc() : super(AccountState()) {
    on<AccountInitEvent>(_onInit);
  }

  void _onInit(AccountInitEvent event, emit) {}
}

abstract class AccountBaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccountInitEvent extends AccountBaseEvent {}

class AccountState extends Equatable {
  @override
  List<Object?> get props => [];
}
