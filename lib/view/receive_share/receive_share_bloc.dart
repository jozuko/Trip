import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/bookmark.dart';
import 'package:trip/service/bookmark_service.dart';
import 'package:trip/service/url_analyzer.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class ReceiveShareBloc extends Bloc<ReceiveShareBaseEvent, ReceiveShareBaseState> {
  final _urlAnalyzer = getIt.get<UrlAnalyzer>();
  final _bookmarkService = getIt.get<BookmarkService>();

  ReceiveShareBloc({required String url}) : super(ReceiveShareState(bookmark: Bookmark(url: url, title: '', description: '', imageUrl: ''))) {
    on<ReceiveShareUrlEvent>(_onReceiveUrl);
    on<ReceiveShareAddBookmarkEvent>(_onAddBookmark);
  }

  Future<void> _onReceiveUrl(ReceiveShareUrlEvent event, emit) async {
    final state = this.state;
    if (state is ReceiveShareState) {
      final url = state.bookmark?.url ?? '';
      if (url.isEmpty) {
        emit(ReceiveShareState(isLoading: false));
        return;
      }

      final analyzedUrl = await _urlAnalyzer.analyze(url);
      emit(ReceiveShareState(isLoading: false, bookmark: analyzedUrl));
    }
  }

  Future<void> _onAddBookmark(ReceiveShareAddBookmarkEvent event, emit) async {
    final state = this.state;
    if (state is ReceiveShareState) {
      _bookmarkService.add(state.bookmark);
      emit(ReceiveShareDoneState());
    }
  }
}

abstract class ReceiveShareBaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReceiveShareUrlEvent extends ReceiveShareBaseEvent {}

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
  final bool isLoading;
  final Bookmark? bookmark;

  ReceiveShareState({
    this.isLoading = true,
    this.bookmark,
  });

  @override
  List<Object?> get props => [
        isLoading,
        bookmark,
      ];
}

class ReceiveShareDoneState extends ReceiveShareBaseState {}
