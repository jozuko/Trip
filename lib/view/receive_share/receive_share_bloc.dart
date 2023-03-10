import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/bookmark.dart';
import 'package:trip/domain/shared_poi.dart';
import 'package:trip/domain/shared_text.dart';
import 'package:trip/service/bookmark_service.dart';
import 'package:trip/service/poi_service.dart';
import 'package:trip/service/shared_text_analyzer.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class ReceiveShareBloc extends Bloc<ReceiveShareBaseEvent, ReceiveShareBaseState> {
  final _sharedTextAnalyzer = getIt.get<SharedTextAnalyzer>();
  final _bookmarkService = getIt.get<BookmarkService>();
  final _poiService = getIt.get<PoiService>();

  ReceiveShareBloc({required String sharedText}) : super(ReceiveShareState(sharedText: sharedText)) {
    on<ReceiveShareInitEvent>(_onInit);
    on<ReceiveShareChangeTitleEvent>(_onChangeTitle);
    on<ReceiveShareChangeUrlEvent>(_onChangeUrl);
    on<ReceiveShareAddBookmarkEvent>(_onAddBookmark);
  }

  Future<void> _onInit(ReceiveShareInitEvent event, emit) async {
    final state = this.state;
    if (state is ReceiveShareState) {
      final sharedText = state.sharedText;
      if (sharedText.isEmpty) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final analyzedData = await _sharedTextAnalyzer.analyze(sharedText);
      emit(state.copyWith(initialized: false, isLoading: false, sharedData: analyzedData));
    }
  }

  ReceiveShareState? get _initializedState {
    final currentState = state;
    if (currentState is ReceiveShareState) {
      return currentState.copyWith(initialized: true);
    }
    return null;
  }

  void _onChangeTitle(ReceiveShareChangeTitleEvent event, emit) {
    final state = _initializedState;
    if (state != null) {
      emit(state.copyWith(sharedData: state.sharedData.copyWith(title: event.title)));
    }
  }

  void _onChangeUrl(ReceiveShareChangeUrlEvent event, emit) {
    final state = _initializedState;
    if (state != null) {
      emit(state.copyWith(sharedData: state.sharedData.copyWith(url: event.url)));
    }
  }

  Future<void> _onAddBookmark(ReceiveShareAddBookmarkEvent event, emit) async {
    final state = _initializedState;
    if (state != null) {
      final sharedData = state.sharedData;

      if (sharedData is Bookmark) {
        await _bookmarkService.add(sharedData);
      }

      if (sharedData is SharedPoi) {
        await _poiService.save(sharedData);
      }

      emit(ReceiveShareDoneState());
    }
  }
}

abstract class ReceiveShareBaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReceiveShareInitEvent extends ReceiveShareBaseEvent {}

class ReceiveShareChangeTitleEvent extends ReceiveShareBaseEvent {
  final String title;

  ReceiveShareChangeTitleEvent({required this.title});

  @override
  List<Object?> get props => [title];
}

class ReceiveShareChangeUrlEvent extends ReceiveShareBaseEvent {
  final String url;

  ReceiveShareChangeUrlEvent({required this.url});

  @override
  List<Object?> get props => [url];
}

class ReceiveShareAddBookmarkEvent extends ReceiveShareBaseEvent {}

abstract class ReceiveShareBaseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReceiveShareState extends ReceiveShareBaseState {
  final bool initialized;
  final bool isLoading;
  final String sharedText;
  final SharedData sharedData;

  ReceiveShareState({
    this.initialized = false,
    this.isLoading = true,
    required this.sharedText,
    this.sharedData = const Bookmark(),
  });

  ReceiveShareState copyWith({
    bool? initialized,
    bool? isLoading,
    String? sharedText,
    SharedData? sharedData,
  }) {
    return ReceiveShareState(
      initialized: initialized ?? this.initialized,
      isLoading: isLoading ?? this.isLoading,
      sharedText: sharedText ?? this.sharedText,
      sharedData: sharedData ?? this.sharedData,
    );
  }

  @override
  List<Object?> get props => [
        initialized,
        isLoading,
        sharedText,
        sharedData,
      ];
}

class ReceiveShareDoneState extends ReceiveShareBaseState {}
