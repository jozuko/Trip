import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc() : super(const ApplicationState()) {
    on<ApplicationInit>(_onInit);
  }

  Future<void> _onInit(ApplicationInit event, Emitter<ApplicationState> emit) async {

  }
}

abstract class ApplicationEvent extends Equatable {}

class ApplicationInit extends ApplicationEvent {
  ApplicationInit();

  @override
  List<Object?> get props => [];
}

class ApplicationState extends Equatable {
  final bool isLoading;
  final bool initialized;

  const ApplicationState({
    this.isLoading = true,
    this.initialized = false,
  });

  @override
  List<Object?> get props => [isLoading, initialized];
}
