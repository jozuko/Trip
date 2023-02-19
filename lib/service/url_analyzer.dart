import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:trip/domain/bookmark.dart';
import 'package:trip/repository/log/trip_logger.dart';

///
/// Created by jozuko on 2023/02/18.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class UrlAnalyzer {
  Future<Bookmark> analyze(String url) async {
    TripLog.i('UrlAnalyzer::analyze start [$url]');
    var bookmark = Bookmark(url: url, title: '', description: '', imageUrl: '');

    try {
      Response response = await get(Uri.parse(url));
      final document = parse(response.body);
      final head = document.head;
      if (head == null) {
        TripLog.i('UrlAnalyzer::analyze no head url');
        return bookmark;
      }

      bookmark = bookmark.copyWith(title: getTitle(head));

      final metas = head.getElementsByTagName('meta');
      for (var meta in metas) {
        if (meta.attributes['name'] == 'description') {
          final description = meta.attributes['content'];
          bookmark = bookmark.copyWith(description: description);
          continue;
        }

        if (meta.attributes['property'] == 'og:image') {
          final image = meta.attributes['content'];
          bookmark = bookmark.copyWith(imageUrl: image);
          continue;
        }
      }

      return bookmark;
    } catch (e) {
      TripLog.e('UrlAnalyzer::analyze', e);
      return bookmark;
    }
  }

  String getTitle(Element head) {
    final titleElements = head.getElementsByTagName('title');
    if (titleElements.isEmpty) {
      return '';
    }
    return titleElements.first.innerHtml;
  }
}
