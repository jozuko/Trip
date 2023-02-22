import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/bookmark.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/repository/shared_holder.dart';
import 'package:trip/service/bookmark_service.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/22.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class HomeBloc extends Bloc<HomeEventBase, HomeState> {
  final sharedHolder = getIt.get<SharedHolder>();
  final bookmarkService = getIt.get<BookmarkService>();

  HomeBloc() : super(const HomeState()) {
    on<HomeInitEvent>(_onInit);
  }

  Future<void> _onInit(HomeInitEvent event, emit) async {
    final bookmarks = bookmarkService.getAll();
    TripLog.d('Home#_onInit $bookmarks');
    emit(HomeState(bookmarks: bookmarks));
  }
}

abstract class HomeEventBase extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitEvent extends HomeEventBase {}

class HomeState extends Equatable {
  final List<Bookmark> bookmarks;

  const HomeState({
    this.bookmarks = const <Bookmark>[],
  });

  @override
  List<Object?> get props => [];
}
