import 'package:trip/domain/bookmark.dart';
import 'package:trip/domain/bookmark_list.dart';
import 'package:trip/repository/shared_holder.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/19.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class BookmarkService {
  final sharedHolder = getIt.get<SharedHolder>();

  void add(Bookmark? bookmark) {
    if (bookmark == null) {
      return;
    }

    final bookmarksJson = sharedHolder.bookmarks;
    final bookmarks = BookmarkList.fromJsonString(bookmarksJson);
    bookmarks.add(bookmark);
    sharedHolder.bookmarks = bookmarks.jsonString;
  }
}
