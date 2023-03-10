import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:trip/domain/bookmark.dart';

///
/// Created by jozuko on 2023/02/19.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class BookmarkList extends DelegatingList<Bookmark> {
  final List<Bookmark> _list;

  BookmarkList() : this._(<Bookmark>[]);

  BookmarkList._(list)
      : _list = list,
        super(list);

  factory BookmarkList.fromJsonString(String json) {
    if (json.isEmpty) {
      return BookmarkList();
    }

    List<dynamic> jsonList = const JsonDecoder().convert(json);
    final list = <Bookmark>[];
    for (var map in jsonList) {
      if (map is Map<String, dynamic>) {
        final bookmark = Bookmark.fromMap(map);
        list.add(bookmark);
      }
    }

    return BookmarkList._(list);
  }

  String get jsonString {
    if (_list.isEmpty) {
      return '';
    }

    return jsonEncode(_list.map((e) => e.jsonMap).toList());
  }
}
