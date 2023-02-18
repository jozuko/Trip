import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/AnalyzedUrl.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/service/url_analyzer.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class ReceiveShareBloc extends Bloc<ReceiveShareEvent, ReceiveShareState> {
  ReceiveShareBloc() : super(const ReceiveShareState()) {
    on<ReceiveShareUrlEvent>(_onReceiveUrl);

    TripLog.d("ReceiveShareBloc::constructor");
  }

  Future<void> _onReceiveUrl(ReceiveShareUrlEvent event, emit) async {
    if (state.analyzedUrl?.url != event.url) {
      //emit(const ReceiveShareState(isLoading: true));

      final analyzer = getIt.get<UrlAnalyzer>();
      final analyzedUrl = await analyzer.analyze(event.url);
      emit(ReceiveShareState(analyzedUrl: analyzedUrl));
    }
  }
}

abstract class ReceiveShareEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReceiveShareUrlEvent extends ReceiveShareEvent {
  final String url;

  ReceiveShareUrlEvent({
    required this.url,
  });

  @override
  List<Object?> get props => [url];
}

class ReceiveShareChangeTitleEvent extends ReceiveShareEvent {
  final String title;

  ReceiveShareChangeTitleEvent({required this.title});

  @override
  List<Object?> get props => [title];
}

class ReceiveShareChangeUrlEvent extends ReceiveShareEvent {
  final String url;

  ReceiveShareChangeUrlEvent({required this.url});

  @override
  List<Object?> get props => [url];
}

class ReceiveShareState extends Equatable {
  final bool isLoading;
  final AnalyzedUrl? analyzedUrl;

  const ReceiveShareState({
    this.isLoading = false,
    this.analyzedUrl,
  });

  @override
  List<Object?> get props => [
        isLoading,
        analyzedUrl,
      ];
}
